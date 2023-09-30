//
//  ProfileViewTest.swift
//  ProfileViewTest
//
//  Created by Валерия Медведева on 30.09.2023.
//


@testable import ImageFeed

import XCTest

 final class ProfileViewTests: XCTestCase {
     func testViewControllerCallsViewDidLoad() {
              let profileViewController = ProfileViewController()
              let profileViewPresenter = ProfileViewPresenterSpy()
         profileViewController.configure(profileViewPresenter as! ProfileViewPresenterProtocol)

              _ = profileViewController.view

              XCTAssertTrue(profileViewPresenter.viewDidLoadCalled)

     }
 }

