//
//  KeychainService.swift
//  Nomad
//
//  Created by Hayden Davis on 10/13/15.
//  Copyright © 2015 Tether. All rights reserved.
//


import Foundation
import Security

public class Keychain
{
  public class func set(key: String, value: String) -> Bool
  {
    if let data = value.dataUsingEncoding(NSUTF8StringEncoding)
    {
      return set(key, value: data)
    }
    
    return false
  }
  
  public class func set(key: String, value: NSData) -> Bool
  {
    let query = [
      (kSecClass as! String)       : kSecClassGenericPassword,
      (kSecAttrAccount as! String) : key,
      (kSecValueData as! String)   : value
    ]
    
    SecItemDelete(query as CFDictionaryRef)
    
    return SecItemAdd(query as CFDictionaryRef, nil) == noErr
  }
  
  public class func get(key: String) -> NSString?
  {
    if let data = getData(key)
    {
      return NSString(data: data, encoding: NSUTF8StringEncoding)
    }
    
    return nil
  }
  
  public class func getData(key: String) -> NSData?
  {
    let query = [
      (kSecClass as String)       : kSecClassGenericPassword,
      (kSecAttrAccount as String) : key,
      (kSecReturnData as String)  : kCFBooleanTrue,
      (kSecMatchLimit as String)  : kSecMatchLimitOne
    ]
    
    
    /*    var dataTypeRef: Unmanaged<AnyObject>?
    //let status = SecItemCopyMatching(query, &dataTypeRef)
    if status == noErr && dataTypeRef != nil
    {
    return dataTypeRef!.takeRetainedValue as? NSData
    //return dataTypeRef as? NSData
    }
    */
    var dataTypeRef: AnyObject?
    
    let status: OSStatus = withUnsafeMutablePointer(&dataTypeRef) { SecItemCopyMatching(query as CFDictionaryRef, UnsafeMutablePointer($0)) }
    
    if status == noErr {
      return dataTypeRef as? NSData
    }
    else {
      return nil
    }
    
    
    return nil
  }
  
  public class func delete(key: String) -> Bool
  {
    let query = [
      (kSecClass as! String)       : kSecClassGenericPassword,
      (kSecAttrAccount as! String) : key
    ]
    
    return SecItemDelete(query as CFDictionaryRef) == noErr
  }
  
  public class func clear() -> Bool
  {
    let query = [
      (kSecClass as String): kSecClassGenericPassword
    ]
    
    return SecItemDelete(query as CFDictionaryRef) == noErr
  }
}