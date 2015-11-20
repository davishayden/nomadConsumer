//
//  ReceiptService.swift
//  Nomad
//
//  Created by Hayden Davis on 10/14/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation

class ReceiptService {
  let client: NomadClient
  
  init(client: NomadClient) {
    self.client = client;
  }
  
  convenience init() {
    self.init(client: NomadClient());
  }
  
  func getReceipt(authToken: String, tabId: String, completionHandler: (ReceiptTransaction) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/receipts/getReceipt"
    let body = NSMutableDictionary();
    body.setValue(authToken, forKey: "authToken")
    body.setValue(tabId, forKey: "tabId")
    let callback: (ReceiptTransaction) -> Void = {(result: ReceiptTransaction) in
      theCurrentReceiptTrans = result
      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }

  
  func getReceipts(authToken: String,completionHandler: ([Receipt]) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/receipts/getAll";
    let placeholder: [Receipt] = client.getMultiple(route, queryString: nil, completionHandler: completionHandler, errorHandler: errorHandler);
    print(placeholder)
  }
  
}
