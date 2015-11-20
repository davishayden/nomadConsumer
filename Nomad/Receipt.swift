//
//  Receipt.swift
//  Nomad
//
//  Created by Hayden Davis on 10/14/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
import UIKit

class Receipt : JsonParseable {
  var id: String?
  var result: Bool?
  var closedAt: String?
  var locName: String?
  var subTotal: Float?
  var tax: Float?
  var tip: Float?
  var grandTotal: Float?
  var jsonTrans: [JSON]?
  var transactions: [Transaction] = []
  var avatarImage: UIImage?
  var avatarUrl: String?

  init() {
    
  }

  required init(json: JSON) {
    id = json["tab"]["_id"].string;
    avatarUrl = json["avatar"].string;
    locName = json["locName"].string;
    closedAt = json["tab"]["closedAt"].string
    subTotal = json["tab"]["subTotal"].float;
    tax = json["tab"]["tax"].float;
    tip = json["tab"]["tip"].float;
    grandTotal = json["tab"]["grandTotal"].float;
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
    if((closedAt) != nil) {
      let dateFormatter = NSDateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
      if let date = dateFormatter.dateFromString(closedAt!) {
        let formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "MM/dd/yyyy', 'hh:mm a"
        let stringDate: String = formatter.stringFromDate(date)
        closedAt = stringDate
      }
    }
  }
  
  func toJson() -> AnyObject {
    let dict: NSMutableDictionary = NSMutableDictionary();
    dict.setValue(self.result, forKey: "result");
    return dict;
  }
  
}