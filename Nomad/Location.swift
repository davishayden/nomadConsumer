//
//  Location.swift
//  Nomad
//
//  Created by Hayden Davis on 10/13/15.
//  Copyright © 2015 Tether. All rights reserved.
//


import Foundation
import UIKit

class Location : JsonParseable {
  var locationId: String?
  var merchantId: String?
  var name: String?
  var address: String?
  var avatarUrl: String?
  var avatarImage: UIImage?
  var tabCount: Float = 0

  init() {
    
  }
  
  required init(json: JSON) {
    tabCount = json["tabCount"].float!
    locationId = json["_id"].string;
    merchantId = json["merchantId"].string;
    name = json["name"].string;
    address = json["address"].string;
    avatarUrl = json["avatar"].string;
    
    
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
    dict.setValue(self.locationId, forKey: "locationId");
    dict.setValue(self.merchantId, forKey: "merchantId");
    dict.setValue(self.name, forKey: "name");
    dict.setValue(self.address, forKey: "address");
    dict.setValue(self.avatarUrl, forKey: "avatarUrl");
    dict.setValue(self.tabCount, forKey: "tabCount");

    return dict;
  }
  
}
