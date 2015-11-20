//
//  SessionService.swift
//  Nomad
//
//  Created by Hayden Davis on 10/13/15.
//  Copyright © 2015 Tether. All rights reserved.
//

import Foundation
class SessionService {
  
  private var client: NomadClient;
  
  init(client: NomadClient) {
    self.client = client;
  }
  
  convenience init() {
    self.init(client: NomadClient());
  }
  
  func signUp(userId: String, authToken: String, fullName: String, phoneNumber: String, email: String, defaultTip: String, completionHandler: (SignUpResult) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/signup"
    
    var body = NSMutableDictionary();
    body.setValue(userId, forKey: "userId")
    body.setValue(authToken, forKey: "authToken")
    body.setValue(fullName, forKey: "fullName")
    body.setValue(phoneNumber, forKey: "phoneNumber")
    body.setValue(email, forKey: "email")
    body.setValue(defaultTip, forKey: "defaultTip")
    // first set the token in the keychain, then we call the other completion handler
    var callback: (SignUpResult) -> Void = {(result: SignUpResult) in
      print(result.name)
      print(result.result)
      if(result.result == true) {
        validUser = true
        Keychain.set("validUser", value: "true")
        Keychain.set("nomadPhoneNumber", value: result.phoneNumber!)
        Keychain.set("nomadFullName", value:  result.name!)
        Keychain.set("nomadUserId", value: result.userId!)
        Keychain.set("nomadAuthToken", value: result.authToken!)
        Keychain.set("nomadEmail", value: result.email!)
        Keychain.set("nomadDefaultTip", value: result.defaultTip!)
      } else {
        validUser = false
        Keychain.set("validUser", value: "false")
        Keychain.delete("nomadPhoneNumber")
        Keychain.delete("nomadFullName")
        Keychain.delete("nomadUserId")
        Keychain.delete("nomadAuthToken")
        Keychain.delete("nomadEmail")
        Keychain.delete("nomadDefaultTip")
      }
      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }
  
  func logIn(userId: String, authToken: String, phoneNumber: String, completionHandler: (SignUpResult) -> Void, errorHandler: (NSError!) -> Void) {
    let route = "/login"
    var body = NSMutableDictionary();
    body.setValue(userId, forKey: "userId")
    body.setValue(authToken, forKey: "authToken")
    body.setValue(phoneNumber, forKey: "phoneNumber")
    // first set the token in the keychain, then we call the other completion handler
    var callback: (SignUpResult) -> Void = {(result: SignUpResult) in
      print(" IN THE CALL BACK")
        if(result.result == true) {
          validUser = true
          Keychain.set("validUser", value: "true")
          Keychain.set("nomadPhoneNumber", value: result.phoneNumber!)
          Keychain.set("nomadFullName", value:  result.name!)
          Keychain.set("nomadUserId", value: result.userId!)
          Keychain.set("nomadAuthToken", value: result.authToken!)
          Keychain.set("nomadEmail", value: result.email!)
          Keychain.set("nomadDefaultTip", value: result.defaultTip!)
        } else {
          validUser = false
          Keychain.set("validUser", value: "false")
          Keychain.delete("nomadPhoneNumber")
          Keychain.delete("nomadFullName")
          Keychain.delete("nomadUserId")
          Keychain.delete("nomadAuthToken")
          Keychain.delete("nomadEmail")
          Keychain.delete("nomadDefaultTip")
        }

      completionHandler(result);
    };
    client.post(route, body: body, completionHandler: callback, errorHandler: errorHandler);
  }
}