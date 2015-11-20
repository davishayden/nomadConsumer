//
//  SignUpLogIn.swift
//  Nomad
//
//  Created by Hayden Davis on 10/6/15.
//

import Foundation
import UIKit
import DigitsKit

class SignUpLogIn: UIViewController {
  var titleLabel: UILabel!
  var subtitleLabel: UILabel!
  var fullNameLabel: UILabel = UILabel()
  var fullNameField: UITextField = UITextField()
  var nameFieldBorder: UIView = UIView()
  
  var emailLabel: UILabel = UILabel()
  var emailField: UITextField = UITextField()
  var emailFieldBorder: UIView = UIView()

  var defaultTipLabel: UILabel = UILabel()
  var defaultTipField: UITextField = UITextField()
  var tipFieldBorder: UIView = UIView()

  
  let sessionService: SessionService = SessionService()
  var logo: UIImageView = UIImageView()
  var viewCover: UIView = UIView()
  
  override func viewDidLoad() {

    super.viewDidLoad()
    viewCover.backgroundColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    viewCover.frame = CGRectMake(0, 0, self.view.frame.width, self.view.frame.height)
    logo.frame = CGRectMake(100, 100, 240, 240)
    logo.center = self.view.center
    logo.image = UIImage(named: "launchImage.jpg")
    self.viewCover.addSubview(logo)
    self.view.addSubview(viewCover)

    titleLabel = UILabel(frame: CGRectMake(100, 100, self.view.frame.width, 45))
    titleLabel.textAlignment = NSTextAlignment.Center
    titleLabel.center = self.view.center
    titleLabel.frame.origin.y = self.view.frame.height * 0.1
    titleLabel.text = "Welcome to Nomad"
    titleLabel.font = UIFont(name: "JosefinSans-SemiBold",  size: 40)
    
    subtitleLabel = UILabel(frame: CGRectMake(100, 100, self.view.frame.width, 35))
    subtitleLabel.textAlignment = NSTextAlignment.Center
    subtitleLabel.center = self.view.center
    subtitleLabel.frame.origin.y = self.view.frame.height * 0.2
    subtitleLabel.text = "Don't wait for your bill. Ever."
    subtitleLabel.font = UIFont(name: "JosefinSans-SemiBold",  size: 24)
    
    fullNameField.backgroundColor = UIColor.whiteColor()
    fullNameField.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.30, self.view.frame.width * 0.90, self.view.frame.height * 0.06)
    fullNameField.textColor = UIColor.blackColor()
    fullNameField.placeholder = "Enter your name"
    fullNameField.font = UIFont(name: "JosefinSans-SemiBold",  size: 24)
    
    nameFieldBorder.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.35, self.view.frame.width * 0.90, 1)
    nameFieldBorder.backgroundColor = UIColor.blackColor()
    
    emailField.backgroundColor = UIColor.whiteColor()
    emailField.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.37, self.view.frame.width * 0.90, self.view.frame.height * 0.06)
    emailField.placeholder = "Enter your email"
    emailField.font = UIFont(name: "JosefinSans-SemiBold",  size: 24)

    emailFieldBorder.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.42 , self.view.frame.width * 0.90, 1)
    emailFieldBorder.backgroundColor = UIColor.blackColor()
    
    defaultTipField.backgroundColor = UIColor.whiteColor()
    defaultTipField.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.44, self.view.frame.width * 0.90, self.view.frame.height * 0.06)
    defaultTipField.font = UIFont(name: "JosefinSans-SemiBold",  size: 24)
    defaultTipField.placeholder = "Default tip % (You can change later!)"
    
    tipFieldBorder.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.49, self.view.frame.width * 0.90, 1)
    tipFieldBorder.backgroundColor = UIColor.blackColor()

    let authButton = DGTAuthenticateButton(authenticationCompletion: { (session: DGTSession?, error: NSError?) in
      if (session != nil) {
        authToken = (session?.authToken)!
        authTokenSecret = (session?.authTokenSecret)!
        userId = (session?.userID)!
        phoneNumber = (session?.phoneNumber)!
        fullName = self.fullNameField.text!
        let email: String = self.emailField.text!
        let defaultTip: String = self.defaultTipField.text!
        
        Keychain.set("nomadFullName", value: fullName as String)
        
        self.sessionService.signUp(userId as String, authToken: authToken as String, fullName: fullName as String , phoneNumber: phoneNumber as String, email: email, defaultTip: defaultTip,  completionHandler: { json in
          if(validUser == true) {
            print("IN HERE")
            Keychain.set("nomadUserId", value: userId as String)
            Keychain.set("nomadAuthToken", value: authToken as String)
            dispatch_async(dispatch_get_main_queue(), {
              self.performSegueWithIdentifier("pushLogin", sender: self)
            })
          } else {
            print("OUTHERE")
          }
          }, errorHandler: { error in
            // handle the error
            print(error);
        });
      }else {
        NSLog("Authentication error: %@", error!.localizedDescription)
      }
    })
    
    let loginButton = DGTAuthenticateButton(authenticationCompletion: { (session: DGTSession?, error: NSError?) in
      if (session != nil) {
        authToken = (session?.authToken)!
        authTokenSecret = (session?.authTokenSecret)!
        userId = (session?.userID)!
        phoneNumber = (session?.phoneNumber)!
        self.sessionService.logIn(userId as String, authToken: authToken as String, phoneNumber: phoneNumber as String, completionHandler: { json in
          if(validUser == true) {
            Keychain.set("nomadUserId", value: userId as String)
            Keychain.set("nomadAuthToken", value: authToken as String)
            dispatch_async(dispatch_get_main_queue(), {
              self.performSegueWithIdentifier("pushLogin", sender: self)
            })
          } else {
            
          }

          }, errorHandler: { error in
            // handle the error
            print(error);
        });
      }else {
        NSLog("Authentication error: %@", error!.localizedDescription)
      }
    })

    
    authButton.digitsAppearance = self.makeTheme()
    authButton.center = self.view.center
    authButton.center.y = self.view.frame.height * 0.55
    authButton.setTitle("Register with my phone number", forState: UIControlState.Normal)
    
    loginButton.digitsAppearance = self.makeTheme()
    loginButton.center = self.view.center
    loginButton.center.y = self.view.frame.height * 0.65
    loginButton.setTitle("Login", forState: UIControlState.Normal)

    if let nomadUserId: String = Keychain.get("nomadUserId") as? String {
      if let nomadAuthToken: String = Keychain.get("nomadAuthToken") as? String {
        if let nomadPhoneNumber: String = Keychain.get("nomadPhoneNumber") as? String {

          self.sessionService.logIn(nomadUserId, authToken: nomadAuthToken, phoneNumber: nomadPhoneNumber, completionHandler: { json in
            if(validUser == true) {
              print("2")
              dispatch_async(dispatch_get_main_queue(), {
                self.performSegueWithIdentifier("pushLogin", sender: self)
              })
            } else {
              print("3")
              self.viewCover.removeFromSuperview()
            }
            }, errorHandler: { error in
              print(error);
              print("5")
          });
        }
        
        self.sessionService.logIn(nomadUserId, authToken: nomadAuthToken, phoneNumber: "", completionHandler: { json in
          if(validUser == true) {
            print("2")
            dispatch_async(dispatch_get_main_queue(), {
              self.performSegueWithIdentifier("pushLogin", sender: self)
            })
          } else {
            print("3")
            self.viewCover.removeFromSuperview()
            dispatch_async(dispatch_get_main_queue(), {
              self.viewCover.removeFromSuperview()
              self.view.addSubview(self.titleLabel)
              self.view.addSubview(self.subtitleLabel)
              self.view.addSubview(self.fullNameField)
              self.view.addSubview(self.nameFieldBorder)
              self.view.addSubview(self.emailField)
              self.view.addSubview(self.emailFieldBorder)
              self.view.addSubview(self.defaultTipField)
              self.view.addSubview(self.tipFieldBorder)
              self.view.addSubview(authButton)
              self.view.addSubview(loginButton)
            })
          }
          print("4")
          }, errorHandler: { error in
            print(error);
            print("5")
            
        });
      }
    } else {
      dispatch_async(dispatch_get_main_queue(), {
        self.viewCover.removeFromSuperview()
        self.view.addSubview(self.titleLabel)
        self.view.addSubview(self.subtitleLabel)
        self.view.addSubview(self.fullNameField)
        self.view.addSubview(self.nameFieldBorder)
        self.view.addSubview(self.emailField)
        self.view.addSubview(self.emailFieldBorder)
        self.view.addSubview(self.defaultTipField)
        self.view.addSubview(self.tipFieldBorder)
        self.view.addSubview(authButton)
        self.view.addSubview(loginButton)
      })
    }

  }
  
  func makeTheme() -> DGTAppearance {
    let theme = DGTAppearance();
    theme.bodyFont = UIFont(name: "JosefinSans-SemiBold", size: 16);
    theme.labelFont = UIFont(name: "JosefinSans-SemiBold", size: 17);
    theme.accentColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    theme.backgroundColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    // TODO: set a UIImage as a logo with theme.logoImage
    return theme;
  }
  
  func login() {
    
    let theToken = Keychain.get("nomadAuthToken") as! String
    print(theToken)
    self.sessionService.logIn(Keychain.get("nomadUserId") as! String, authToken: theToken, phoneNumber: Keychain.get("nomadPhoneNumber") as! String, completionHandler: { json in
      if(validUser == true) {
        print("IN ")
        dispatch_async(dispatch_get_main_queue(), {
          self.performSegueWithIdentifier("pushLogin", sender: self)
        })
      } else {
        print("out")
      }
      }, errorHandler: { error in
        print(error);
        
    });
  }

  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    let tabC: UITabBarController = segue.destinationViewController as! UITabBarController
    tabC.navigationItem.hidesBackButton = true
    if let theView: [UIViewController] = tabC.viewControllers {
      var placesNearMeVC = theView[0]
      
    }
  }

}
  