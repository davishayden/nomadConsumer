//
//  SignUpResult.swift
//  Nomad
//
//  Created by Hayden Davis on 10/13/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
import UIKit

class SignUpResult : JsonParseable {
  var result: Bool?
  var phoneNumber: String?
  var name: String?
  var userId: String?
  var authToken: String?
  var email: String?
  var defaultTip: String?
  
  init() {
    
  }
  
  required init(json: JSON) {
    print(json)
    result = json["result"].bool;
    phoneNumber = json["phoneNumber"].string;
    name = json["name"].string;
    userId = json["userId"].string;
    authToken = json["authToken"].string;
    email = json["email"].string;
    defaultTip = json["defaultTip"].string;
    print(result)

  }
  
  func toJson() -> AnyObject {
    var dict: NSMutableDictionary = NSMutableDictionary();
    dict.setValue(self.result, forKey: "result");
    dict.setValue(self.phoneNumber, forKey: "phoneNumber");
    dict.setValue(self.name, forKey: "name");
    dict.setValue(self.userId, forKey: "userId");
    dict.setValue(self.authToken, forKey: "authToken");
    dict.setValue(self.email, forKey: "email");
    dict.setValue(self.defaultTip, forKey: "defaultTip");


    return dict;
  }
  
}
