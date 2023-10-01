//
//  ImageFeedUITestss.swift
//  ImageFeedUITestss
//
//  Created by Валерия Медведева on 01.10.2023.
//


import XCTest



final class ImageFeedUITests: XCTestCase {
    
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        XCTAssert(app.buttons["Authenticate"].waitForExistence(timeout: 4))
        app.buttons["Authenticate"].tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 4))
        //sleep(3)
        
        let loginTextField = webView.descendants(matching: .textField).element
        XCTAssert(loginTextField.waitForExistence(timeout: 7))
        loginTextField.tap()
        
        //sleep(3)
        loginTextField.typeText("khanzhinov@yandex.ru")
        //sleep(1)
        XCUIApplication().toolbars.buttons["Done"].tap()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssert(passwordTextField.waitForExistence(timeout: 6))
        
        passwordTextField.tap()
        
        XCUIApplication().toolbars.buttons["Done"].tap()
        passwordTextField.tap()
        sleep(2)
        //указать пароль
        passwordTextField.typeText("87Fihiti")
        sleep(3)
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssert(cell.waitForExistence(timeout: 8))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        firstCell.swipeUp()
        sleep(3)
        
        let anotherCell = tablesQuery.children(matching: .cell).element(boundBy: 1)
        anotherCell.buttons["LikeButton"].tap()
        sleep(7)
        anotherCell.buttons["LikeButton"].tap()
        sleep(7)
        anotherCell.tap()
        sleep(7)
        let image = app.scrollViews.images.element(boundBy: 0)
        XCTAssert(image.waitForExistence(timeout: 7))
        image.pinch(withScale: 3, velocity: 1)
        image.pinch(withScale: 0.5, velocity: -1)
        app.buttons["BackButton"].tap()
    }
    
    func testProfile() throws {
        XCTAssertTrue(app.tabBars.buttons.element(boundBy: 1).waitForExistence(timeout: 4))
        app.tabBars.buttons.element(boundBy: 1).tap()
        //указать ФИО
        XCTAssert(app.staticTexts["Pavel Khanzhinov"].exists)
        //указать НИК
        XCTAssert(app.staticTexts["@ezielx"].exists)
        
        app.buttons["logOutButton"].tap()
        sleep(3)
        app.alerts["Пока, пока!"].scrollViews.otherElements.buttons["Да"].tap()
        sleep(3)
        XCTAssert(app.buttons["Authenticate"].exists)
    }
}



























