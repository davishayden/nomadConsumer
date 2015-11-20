//
//  NomadClient.swift
//  Nomad
//
//  Created by Hayden Davis on 10/13/15.
//  Copyright © 2015 Tether. All rights reserved.
//


import Foundation

class NomadClient {
//IS YOUR WIFI On
//let baseUrl: String = "http://10.0.1.3:3000/api/v1"; //Chris House
//let baseUrl: String = "http://192.168.2.2:3000/api/v1"; //ClearView
  let baseUrl: String = "http://www.nomadtab.com/api/v1"; //Live Server


  
  
  
  
  let session: NSURLSession;
  
  init() {
    let config = NSURLSessionConfiguration.defaultSessionConfiguration();
    session = NSURLSession(configuration: config);
  }
  
  private func getUrl(path: String, queryString: Dictionary<String, String>?) -> String {
    var query = "";
    if (queryString != nil) {
      var amp = "?";
      for key in queryString!.keys {
        query += amp + key + "=" + queryString![key]!;
        amp = "&";
      }
    }
    
    return baseUrl + path + query;
  }
  
  func get<T: JsonParseable>(url: String, queryString: Dictionary<String, String>?, completionHandler: (T) -> Void, errorHandler: (NSError!) -> Void) -> T? {
    let fullUrl = getUrl(url, queryString: queryString);
    let request = NSMutableURLRequest(URL: NSURL(string: fullUrl)!);
    
    var authToken: String? = Keychain.get("nomadAuthToken") as! String;
    if (authToken != nil) {
      request.setValue(authToken, forHTTPHeaderField: "Authorization");
    }
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
      if (error != nil) {
        errorHandler(error);
        return;
      }
      
      var success = false;
      var statusCode: Int = -1;
      if let httpResponse = response as? NSHTTPURLResponse {
        statusCode = httpResponse.statusCode;
        success = statusCode == 200;
      }
      
      var jsonError: NSError?;
      if let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as JSON? {
        if (success) {
          let t: T = T(json: json);
          completionHandler(t);
        } else {
          errorHandler(NSError(domain: json["error"].stringValue, code: statusCode, userInfo: nil));
        }
      } else {
        errorHandler(jsonError);
      }
    });
    
    
    task.resume();
    
    return nil;
  }
  
  func delete(url: String, completionHandler: () -> Void, errorHandler: (NSError!) -> Void) {
    let fullUrl = getUrl(url, queryString: nil);
    let request = NSMutableURLRequest(URL: NSURL(string: fullUrl)!);
    request.HTTPMethod = "DELETE";
    
    var authToken: String? = Keychain.get("nomadAuthToken") as? String;
    if (authToken != nil) {
      request.setValue(authToken, forHTTPHeaderField: "Authorization");
    }
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
      if (error != nil) {
        errorHandler(error);
        return;
      }
      
      var success = false;
      var statusCode: Int = -1;
      if let httpResponse = response as? NSHTTPURLResponse {
        statusCode = httpResponse.statusCode;
        success = statusCode == 200;
      }
      
      var jsonError: NSError?;
      if let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as JSON? {
        if (success) {
          completionHandler();
        } else {
          errorHandler(NSError(domain: json["error"].stringValue, code: statusCode, userInfo: nil));
        }
      } else {
        errorHandler(jsonError);
      }
    });
    
    
    task.resume();
  }
  
  func getMultiple<T: JsonParseable>(url: String, queryString: Dictionary<String, String>?, completionHandler: ([T]) -> Void, errorHandler: (NSError!) -> Void) -> [T] {
    let fullUrl = getUrl(url, queryString: queryString);
    let request = NSMutableURLRequest(URL: NSURL(string: fullUrl)!);
    
    var authToken: String? = Keychain.get("nomadAuthToken") as? String;
    if (authToken != nil) {
      request.setValue(authToken, forHTTPHeaderField: "Authorization");
    }
    
  /*  if (body != nil) {
      //  request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body!, options: NSJSONWritingOptions(), error: error);
      request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body!, options: NSJSONWritingOptions())
    }
*/
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
      if (error != nil) {
        errorHandler(error);
        return;
      }
      
      var success = false;
      var statusCode: Int = -1;
      if let httpResponse = response as? NSHTTPURLResponse {
        statusCode = httpResponse.statusCode;
        success = statusCode == 200;
      }
      
      var jsonError: NSError?;
      if let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as JSON? {
        if (success) {
          var arr: [T] = [T]();
          for (index,sub):(String, JSON) in json {
            arr.append(T(json: sub))
          }
          
          completionHandler(arr);
        } else {
          errorHandler(NSError(domain: json["error"].stringValue, code: statusCode, userInfo: nil));
        }
      } else {
        errorHandler(jsonError);
      }
    });
    
    
    task.resume();
    
    return [T]();
  }
  
  private func makeRequest<T : JsonParseable>(httpMethod: String, url: String, body: AnyObject?, completionHandler: (T) -> Void, errorHandler: (NSError!) -> Void) -> T? {
    var nsUrl = NSURL(string: getUrl(url, queryString: nil))!;
    var request: NSMutableURLRequest = NSMutableURLRequest(URL: nsUrl);
    request.HTTPMethod = httpMethod;
    if (body != nil) {
      //  request.HTTPBody = NSJSONSerialization.dataWithJSONObject(body!, options: NSJSONWritingOptions(), error: error);
      request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(body!, options: NSJSONWritingOptions())
    }
    
    request.setValue("application/json", forHTTPHeaderField: "Content-Type");
    request.setValue("application/json", forHTTPHeaderField: "Media-Type");
    var authToken: String? = Keychain.get("nomadAuthToken") as? String;
    if (authToken != nil) {
      request.setValue(authToken, forHTTPHeaderField: "Authorization");
    } else {
      request.setValue("howdy fuckers", forHTTPHeaderField: "Authorization");
    }
    
    let task = session.dataTaskWithRequest(request, completionHandler: {(data, response, error) in
      if (error != nil) {
        errorHandler(error);
        return;
      }
      
      var success = false;
      var statusCode: Int = -1;
      if let httpResponse = response as? NSHTTPURLResponse {
        statusCode = httpResponse.statusCode;
        success = statusCode == 200;
      }
      
      var jsonError: NSError?;
      if let json = JSON(data: data!, options: NSJSONReadingOptions.MutableContainers, error: &jsonError) as JSON? {
        if (success) {
          let t: T = T(json: json);
          completionHandler(t);
        } else {
          errorHandler(NSError(domain: json["error"].stringValue, code: statusCode, userInfo: nil));
        }
      } else {
        errorHandler(jsonError);
      }
    });
    
    task.resume();
    
    return nil;
  }
  
  func post<T : JsonParseable>(url: String, body: AnyObject, completionHandler: (T) -> Void, errorHandler: (NSError!) -> Void) -> T? {
    
    return makeRequest("POST", url: url, body: body, completionHandler: completionHandler, errorHandler: errorHandler);
  }
  
  func put<T : JsonParseable>(url: String, body: AnyObject, completionHandler: (T) -> Void, errorHandler: (NSError!) -> Void) -> T? {
    return makeRequest("PUT", url: url, body: body, completionHandler: completionHandler, errorHandler: errorHandler);
  }
}
