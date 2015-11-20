//
//  TabService.swift
//  Nomad
//
//  Created by Hayden Davis on 10/14/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation

class TabService {
  let client: NomadClient
  
  init(client: NomadClient) {
    self.client = client;
  }
  
  convenience init() {
    self.init(client: NomadClient());
  }
  
  func startTab(authToken: String, locationId: String, tipPercent: String, completionHandler: (SignUpResult) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/tab/start"
    var body = NSMutableDictionary();
    body.setValue(authToken, forKey: "authToken")
    body.setValue(locationId, forKey: "locationId")
    body.setValue(tipPercent, forKey: "tip")

    var callback: (SignUpResult) -> Void = {(result: SignUpResult) in
      if(result.result == true) {
        print("Tab Started")
      } else {
        print("Failed :( ")
      }
      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }
  
  
  func getCurrentTab(authToken: String, completionHandler: (Tab) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/tab/currentTab"
    var body = NSMutableDictionary();
    body.setValue(authToken, forKey: "authToken")
    var callback: (Tab) -> Void = {(result: Tab) in
      if(result.result == true) {
        theCurrentTab = result
      } else {
        print("Failed")
      }
      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }
  
  func closeTab(authToken: String, tipPercent: String, completionHandler: (ServerResponse) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/tab/closeTab"
    var body = NSMutableDictionary();
    body.setValue(authToken, forKey: "authToken")
    body.setValue(tipPercent, forKey: "tip")
    var callback: (ServerResponse) -> Void = {(result: ServerResponse) in
      if(result.result == true) {
        print("Tab Closed")
        
      } else {
        print("Failed")
      }
      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }

}