//
//  Tab.swift
//  Nomad
//
//  Created by Hayden Davis on 10/14/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
import UIKit

class Tab : JsonParseable {
  var result: Bool?
  var locName: String?
  var subTotal: Float?
  var tax: Float?
  var grandTotal: Float?
  var jsonTrans: [JSON]?
  var transactions: [Transaction] = []
  
  init() {
    
  }
  
  required init(json: JSON) {
    result = json["result"].bool;
    locName = json["locName"].string;
    jsonTrans = json["transactions"].array;
    subTotal = json["subTotal"].float;
    tax = json["tax"].float;
    grandTotal = json["grandTotal"].float;
    for item in jsonTrans! {
      let name = item["name"]
      let quantity = item["quantity"]
      let total = item["total"]
      let trans: Transaction = Transaction()
      trans.name = name.string!
      trans.quantity = String(quantity.int!)
      trans.total = String(total.float!)
      transactions.append(trans)
    }
    
    let subCell: Transaction = Transaction()
    subCell.name = "Subtotal"
    subCell.quantity = ""
    subCell.total = String(subTotal!)
    transactions.append(subCell)
    let taxCell: Transaction = Transaction()
    taxCell.name = "Tax"
    taxCell.quantity = ""
    let formattedTax = String(format:"%.02f", tax!)
    taxCell.total = formattedTax//String(tax!)
    transactions.append(taxCell)
    let totalCell: Transaction = Transaction()
    totalCell.name = "Total"
    totalCell.quantity = ""
    let formattedTotal = String(format:"%.02f", grandTotal!)
    totalCell.total = formattedTotal
    transactions.append(totalCell)
    
  }
  
  func toJson() -> AnyObject {
    var dict: NSMutableDictionary = NSMutableDictionary();
    dict.setValue(self.result, forKey: "result");
    return dict;
  }
  
}