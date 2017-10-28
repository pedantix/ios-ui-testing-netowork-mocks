//
//  ViewController.swift
//  TestingMockedNetworkResponses
//
//  Created by Shaun Hubbard on 10/28/17.
//  Copyright © 2017 Shaun Codes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var label: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    loadIpData()
  }
}

extension ViewController {
  fileprivate func loadIpData() {
    guard let url = URL(string: Configuration.shared.apiUrl) else { fatalError("Unable to construct URL") }

    URLSession.shared.dataTask(with: url) { [weak self] (maybeData, maybeResponse, maybeError) in
      guard maybeError == nil else { fatalError(maybeError?.localizedDescription ?? "") }
      guard let httpResponse = maybeResponse as? HTTPURLResponse else { return NSLog("No response") }

      switch httpResponse.statusCode {
      case 200..<300:
        if let data = maybeData {
          self?.process(data: data)
        } else {
          NSLog("There was no data, error handling would be nice")
        }
      default:
        NSLog("There may have been issues with the request :\(httpResponse), error handling would be nice")
      }
    }.resume()
  }

  fileprivate func process(data: Data) {
    do {
      let ip = try JSONDecoder().decode(MyContainer.self, from: data).ip
      DispatchQueue.main.async { [weak self] in
        self?.label.text = ip
      }
    } catch let err {
      NSLog("Issues decoding \(err)")
    }
  }
}
