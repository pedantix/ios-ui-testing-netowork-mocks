//
//  Configuration.swift
//  TestingMockedNetworkResponses
//
//  Created by Shaun Hubbard on 10/28/17.
//  Copyright © 2017 Shaun Codes. All rights reserved.
//

import Foundation

struct Configuration {
  static var shared = Configuration()
  var apiUrl: String

  init() {
    guard let myApiUrl = Bundle.main.object(forInfoDictionaryKey: "MyApiUrl") as? String  else {
      fatalError("MyApiUrl not configured")
    }
    self.apiUrl = myApiUrl
  }
}
