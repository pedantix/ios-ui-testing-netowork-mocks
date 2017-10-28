//
//  UITestBase.swift
//  TestingMockedNetworkResponsesUITests
//
//  Created by Shaun Hubbard on 10/28/17.
//  Copyright © 2017 Shaun Codes. All rights reserved.
//

import Foundation
import XCTest

import Embassy
import Ambassador

class UITestBase: XCTestCase {
  let port = 8080
  var router: Router!
  var eventLoop: EventLoop!
  var server: HTTPServer!
  var app: XCUIApplication!

  var eventLoopThreadCondition: NSCondition!
  var eventLoopThread: Thread!

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    setupWebApp()
    setupApp()
  }

  // setup the Embassy web server for testing
  private func setupWebApp() {
    guard let kQueueSelector = try? KqueueSelector() else { fatalError() }
    eventLoop = try? SelectorEventLoop(selector: kQueueSelector)

    router = Router()
    server = DefaultHTTPServer(eventLoop: eventLoop, port: port, app: router.app)

    // Start HTTP server to listen on the port
    do {
      try server.start()
    } catch let err {
      fatalError("server failed to start \(err)")
    }

    eventLoopThreadCondition = NSCondition()
    eventLoopThread = Thread(target: self, selector: #selector(runEventLoop), object: nil)
    eventLoopThread.start()
  }

  // set up XCUIApplication
  private func setupApp() {
    app = XCUIApplication()
    app.launchEnvironment["ENVOY_BASEURL"] = "http://localhost:\(port)"
  }

  override func tearDown() {
    super.tearDown()
    app.terminate()
    server.stopAndWait()
    eventLoopThreadCondition.lock()
    eventLoop.stop()
    while eventLoop.running {
      if !eventLoopThreadCondition.wait(until: Date(timeIntervalSinceNow: 1)) {
        fatalError("Join eventLoopThread timeout")
      }
    }
  }

  @objc private func runEventLoop() {
    eventLoop.runForever()
    eventLoopThreadCondition.lock()
    eventLoopThreadCondition.signal()
    eventLoopThreadCondition.unlock()
  }

  func  notYetImplemented() {
    XCTAssert(false, "This case has not been implemented")
  }
}

