//
//  TapRecoUITests.swift
//  TapRecoUITests
//
//  Created by 佐川 晴海 on 2021/08/30.
//

import XCTest

class TapRecoUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLocalizedOnboarding() {
        let titles = [
            ("ja", "ワンタッチですぐ録音!"), ("en", "Record with one tap!"),
            ("ko", "한 번 탭하여 녹음!"), ("zh-Hant", "一點即錄！"),
            ("es", "¡Graba con un toque!"), ("pt-BR", "Grave com um toque!"),
            ("id", "Rekam sekali ketuk!")
        ]
        for (language, title) in titles {
            let app = XCUIApplication()
            let systemLanguage = language == "zh-Hant" ? "zh-Hant-TW" : language
            let regionLocale = ["ja": "ja_JP", "en": "en_US", "ko": "ko_KR", "zh-Hant": "zh_TW",
                                "es": "es_MX", "pt-BR": "pt_BR", "id": "id_ID"][language]!
            app.launchArguments = ["-AppleLanguages", "(\(systemLanguage))", "-AppleLocale", regionLocale,
                                   "-isNeedDisplayIntro", "YES"]
            app.launch()
            XCTAssertTrue(app.staticTexts[title].waitForExistence(timeout: 10), language)
            for page in 1...3 {
                let attachment = XCTAttachment(screenshot: app.screenshot())
                attachment.name = "\(language)-intro-\(page)"
                attachment.lifetime = .keepAlways
                add(attachment)
                if page < 3 { app.swipeLeft() }
            }
            let startTitles = ["ja": "たぷれこを始める！", "en": "Get started!", "ko": "시작하기!",
                               "zh-Hant": "開始使用！", "es": "¡Empezar!", "pt-BR": "Começar!", "id": "Mulai!"]
            app.buttons[startTitles[language]!].tap()
            let standby = XCTAttachment(screenshot: app.screenshot())
            standby.name = "\(language)-standby"
            standby.lifetime = .keepAlways
            add(standby)
            app.terminate()
        }
    }

    func testCaptureStoreScreenshots() {
        let locales = [("ja", "ja_JP"), ("en", "en_US"), ("ko", "ko_KR"),
                       ("zh-Hant-TW", "zh_TW"), ("es", "es_MX"), ("pt-BR", "pt_BR"), ("id", "id_ID")]
        for (language, locale) in locales {
            for scene in ["standby", "recording", "list", "share"] {
                let app = XCUIApplication()
                app.launchArguments = ["-AppleLanguages", "(\(language))", "-AppleLocale", locale,
                                       "-isNeedDisplayIntro", "NO", "-lastVersionPromptedForReview", "1.4.1"]
                app.launchEnvironment["TAPRECO_SCREENSHOT_SCENE"] = scene
                app.launch()
                XCTAssertTrue(app.wait(for: .runningForeground, timeout: 15))
                // Allow UIKit's activity sheet presentation to finish before capture.
                if scene == "share" { _ = app.buttons.firstMatch.waitForExistence(timeout: 5) }
                let image = XCTAttachment(screenshot: app.screenshot())
                let folderLanguage = language == "zh-Hant-TW" ? "zh-Hant" : language
                image.name = "store-\(folderLanguage)-\(scene)"
                image.lifetime = .keepAlways
                add(image)
                app.terminate()
            }
        }
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
