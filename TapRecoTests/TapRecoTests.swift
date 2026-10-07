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

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
