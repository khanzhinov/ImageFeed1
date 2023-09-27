

import XCTest

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
