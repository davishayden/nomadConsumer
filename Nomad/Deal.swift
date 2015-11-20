//
//  Deal.swift
//  Nomad
//
//  Created by Hayden Davis on 11/3/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
import UIKit

class Deal : JsonParseable {
  var id: String?
  var locationName: String?
  var message: String?
  var avatarUrl: String?
  var avatarImage: UIImage?
  var redeemed: Bool?
  
  init() {
    
  }
  
  required init(json: JSON) {
    id = json["_id"].string;
    locationName = json["locationName"].string;
    message = json["message"].string;
    avatarUrl = json["avatarUrl"].string;
    redeemed = json["redeemed"].bool;
    
    
    if (avatarUrl != nil) {
      if let img = imageCache[avatarUrl!] {
        avatarImage = img
      } else {
        let url = NSURL(string: avatarUrl!)
        if let data = NSData(contentsOfURL: url!) {
          //make sure your image in this url does exist, otherwise unwrap in a if let check
          avatarImage = UIImage(data: data)
          imageCache[avatarUrl!] = avatarImage
        }
      }
    }
  }
  
  func toJson() -> AnyObject {
    var dict: NSMutableDictionary = NSMutableDictionary();
    dict.setValue(self.id, forKey: "id");
    dict.setValue(self.locationName, forKey: "locationName");
    dict.setValue(self.message, forKey: "message");
    dict.setValue(self.avatarUrl, forKey: "avatarUrl");
    dict.setValue(self.redeemed, forKey: "redeemed");
    
    return dict;
  }
  
}

