//
//  TestingMockedNetworkResponsesUITests.swift
//  TestingMockedNetworkResponsesUITests
//
//  Created by Shaun Hubbard on 10/28/17.
//  Copyright © 2017 Shaun Codes. All rights reserved.
//

import XCTest
import Ambassador

class TestingMockedNetworkResponsesUITests: UITestBase {
  let myIp = "1.2.3.4"

  override func setUp() {
    super.setUp()

    // Using not found is extra cheasy
    router.notFoundResponse = DelayResponse(JSONResponse(statusCode: 200, handler: { _ -> Any in
      return ["ip" : self.myIp]
    }))
  }

  func testIpLoads() {
    app.launch()

    sleep(2)
    let labelWithIpAddress = app.staticTexts[myIp].firstMatch
    XCTAssert(labelWithIpAddress.exists)
  }
}
