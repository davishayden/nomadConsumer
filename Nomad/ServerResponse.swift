//
//  ServerResponse.swift
//  Nomad
//
//  Created by Hayden Davis on 10/14/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
import UIKit

class ServerResponse : JsonParseable {
  var result: Bool?

  init() {
    
  }
  
  required init(json: JSON) {
    result = json["result"]["result"].bool;
  }
  
  func toJson() -> AnyObject {
    var dict: NSMutableDictionary = NSMutableDictionary();
    dict.setValue(self.result, forKey: "result");
    return dict;
  }
  
}