//
//  TapRecoTests.swift
//  TapRecoTests
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import XCTest
@testable import TapReco

class TapRecoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testMicrophoneVolumeNormalizationRejectsNonFiniteValues() {
        XCTAssertEqual(MicrophoneLebelManager.normalizedVolume(averagePower: .nan), 0)
        XCTAssertEqual(MicrophoneLebelManager.normalizedVolume(averagePower: .infinity), 0)
        XCTAssertEqual(MicrophoneLebelManager.normalizedVolume(averagePower: -.infinity), 0)
    }

    func testMicrophoneVolumeNormalizationClampsValues() {
        XCTAssertEqual(MicrophoneLebelManager.normalizedVolume(averagePower: -100), 0)
        XCTAssertEqual(MicrophoneLebelManager.normalizedVolume(averagePower: -25), 0.5)
        XCTAssertEqual(MicrophoneLebelManager.normalizedVolume(averagePower: 10), 1)
    }

    func testGetDateHandlesMinimumIntegerWithoutOverflow() {
        let date = Date(timeIntervalSince1970: 1_000_000)
        XCTAssertEqual(date.getDate(daysAgo: .min), date)
    }

    func testLocalizedResourcesAreBundledForAppAndWidget() throws {
        let appBundle = Bundle(for: RecordingController.self)
        let widgetURL = try XCTUnwrap(appBundle.builtInPlugInsURL)
            .appendingPathComponent("TapRecoWidget.appex")
        let widgetBundle = try XCTUnwrap(Bundle(url: widgetURL))
        let expectedTitles = [
            "ja": "録音を開始", "en": "Start recording", "ko": "녹음 시작",
            "zh-Hant": "開始錄音", "es": "Iniciar grabación",
            "pt-BR": "Iniciar gravação", "id": "Mulai merekam"
        ]
        for bundle in [appBundle, widgetBundle] {
            for (language, title) in expectedTitles {
                let path = try XCTUnwrap(bundle.path(forResource: language, ofType: "lproj"))
                let localizedBundle = try XCTUnwrap(Bundle(path: path))
                XCTAssertEqual(localizedBundle.localizedString(forKey: "録音を開始", value: nil, table: nil), title)
                XCTAssertNotEqual(localizedBundle.localizedString(forKey: "CFBundleDisplayName", value: nil, table: "InfoPlist"), "CFBundleDisplayName")
                if bundle == appBundle {
                    let phrase = localizedBundle.localizedString(forKey: "${applicationName}で録音", value: nil, table: "AppShortcuts")
                    XCTAssertTrue(phrase.contains("${applicationName}"))
                    if language != "ja" { XCTAssertNotEqual(phrase, "${applicationName}で録音") }
                }
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
