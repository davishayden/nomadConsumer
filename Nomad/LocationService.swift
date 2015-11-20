//
//  LocationService.swift
//  Nomad
//
//  Created by Hayden Davis on 10/13/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation

class LocaitonService {
  let client: NomadClient
  
  init(client: NomadClient) {
    self.client = client;
  }
  
  convenience init() {
    self.init(client: NomadClient());
  }
  
  func getLocations(myLat: Float, myLong: Float, completionHandler: ([Location]) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/locations/get25Radius/\(myLat)/\(myLong)";
    let placeholder: [Location] = client.getMultiple(route, queryString: nil, completionHandler: completionHandler, errorHandler: errorHandler);
    print(placeholder)

  }
  
  func check300(lat: String, long: String, authToken: String, completionHandler: (SignUpResult) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/locations/check300"
    var body = NSMutableDictionary();
    body.setValue(lat, forKey: "lat")
    body.setValue(long, forKey: "long")
    body.setValue(authToken, forKey: "authToken")
    
    var callback: (SignUpResult) -> Void = {(result: SignUpResult) in
      if(result.result == true) {
        print("Tab Closed!")
      } else {
        print("Tab not closed fucker.")
      }
      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }

}