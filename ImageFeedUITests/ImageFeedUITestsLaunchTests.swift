//
//  ImageFeedUITestsLaunchTests.swift
//  ImageFeedUITests
//
//  Created by Валерия Медведева on 01.10.2023.
//



import XCTest
//import ImageFeed

final class ImageFeedUITestsLaunchTests: XCTestCase {
    let app = XCUIApplication()
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLaunch() throws {
        app.launch()
        
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

