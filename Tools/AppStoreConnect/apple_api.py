#!/usr/bin/env python3
"""Add localized metadata and screenshots without submitting a version for review.

Uses only the Python standard library and OpenSSL. Credentials are supplied via
arguments; private keys, JWTs, and signed asset URLs are never written to reports.
"""
import argparse
import base64
import hashlib
import json
import struct
import subprocess
import time
import urllib.error
import urllib.parse
import urllib.request
from pathlib import Path


BASE = "https://api.appstoreconnect.apple.com"
ROOT = Path(__file__).resolve().parents[2]


def save(path, value):
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n")


def relation(kind, identifier):
    return {"data": {"type": kind, "id": identifier}}


def payload(kind, attributes, relationships=None, identifier=None):
    data = {"type": kind, "attributes": attributes}
    if relationships:
        data["relationships"] = relationships
    if identifier:
        data["id"] = identifier
    return {"data": data}


class AppleAPI:
    def __init__(self, key, issuer):
        self.key = key
        self.issuer = issuer
        self.jwt = None
        self.expires = 0

    def token(self):
        if time.time() < self.expires - 60:
            return self.jwt
        def b64(value):
            return base64.urlsafe_b64encode(value).rstrip(b"=")
        now = int(time.time())
        kid = self.key.stem.removeprefix("AuthKey_")
        header = {"alg": "ES256", "kid": kid, "typ": "JWT"}
        claims = {"iss": self.issuer, "iat": now, "exp": now + 1100,
                  "aud": "appstoreconnect-v1"}
        if not self.issuer:
            claims.pop("iss")
            claims["sub"] = "user"
        message = b".".join(b64(json.dumps(v).encode()) for v in (header, claims))
        der = subprocess.run(["openssl", "dgst", "-sha256", "-sign", str(self.key)],
                             input=message, capture_output=True, check=True).stdout
        pos = 2 + (der[1] & 127) if der[1] & 128 else 2
        components = []
        for _ in range(2):
            assert der[pos] == 2
            size = der[pos + 1]
            pos += 2
            components.append(int.from_bytes(der[pos:pos + size], "big").to_bytes(32, "big"))
            pos += size
        self.jwt = (message + b"." + b64(b"".join(components))).decode()
        self.expires = now + 1100
        return self.jwt

    def request(self, path, method="GET", body=None):
        url = path if path.startswith(BASE + "/") else BASE + path
        if not url.startswith(BASE + "/"):
            raise ValueError("Unexpected API host")
        headers = {"Authorization": "Bearer " + self.token(), "Content-Type": "application/json"}
        data = None if body is None else json.dumps(body).encode()
        request = urllib.request.Request(url, data=data, method=method, headers=headers)
        try:
            with urllib.request.urlopen(request, timeout=60) as response:
                result = response.read()
                return json.loads(result) if result else None
        except urllib.error.HTTPError as error:
            raise RuntimeError(f"Apple API {method} {path.split('?')[0]}: "
                               f"{error.code} {error.read().decode()}") from None

    def all(self, path):
        result = []
        while path:
            response = self.request(path)
            result.extend(response["data"])
            path = response.get("links", {}).get("next")
        return result

