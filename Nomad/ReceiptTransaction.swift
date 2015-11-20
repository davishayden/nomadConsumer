//
//  ReceiptTransaction.swift
//  Nomad
//
//  Created by Hayden Davis on 10/14/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
import UIKit

class ReceiptTransaction : JsonParseable {
  var transactions: [Transaction] = []

  
  init() {
    
  }
  
  required init(json: JSON) {
    
    for (key, subJson) in json {
      let name = subJson["name"]
      let quantity = subJson["quantity"]
      let total = subJson["total"]
      let tip = subJson["tip"]
      let trans: Transaction = Transaction()
      print(name)
      
      
      trans.name = String(name)
      trans.quantity = String(quantity.int!)
      trans.total = String(total.float!)
      transactions.append(trans)
    }

    
    let subCell: Transaction = Transaction()
    subCell.name = "Subtotal"
    subCell.quantity = ""
    subCell.total = String(theCurrentReceipt.subTotal!)
    transactions.append(subCell)
    let taxCell: Transaction = Transaction()
    taxCell.name = "Tax"
    taxCell.quantity = ""
    let formattedTax = String(format:"%.02f", theCurrentReceipt.tax!)
    taxCell.total = formattedTax//String(tax!)
    transactions.append(taxCell)
    
    
    let tipCell: Transaction = Transaction()
    tipCell.name = "Tip"
    tipCell.quantity = ""
    if(theCurrentReceipt.tip != nil) {
      tipCell.total = String(theCurrentReceipt.tip!)
    } else {
      tipCell.total = "N/A"
    }
    transactions.append(tipCell)
    
    
    let totalCell: Transaction = Transaction()
    totalCell.name = "Total"
    totalCell.quantity = ""
    if(theCurrentReceipt.grandTotal != nil) {
      let formattedTotal = String(format:"%.02f", theCurrentReceipt.grandTotal!)
      totalCell.total = formattedTotal
    } else {
      totalCell.total = "N/A"
    }
    transactions.append(totalCell)

    
  }
  
  func toJson() -> AnyObject {
    var dict: NSMutableDictionary = NSMutableDictionary();
    return dict;
  }
  
}