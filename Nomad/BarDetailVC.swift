//
//  BarDetailVC.swift
//  Nomad
//
//  Created by Hayden Davis on 10/9/15.
//

import Foundation
import UIKit
class BarDetailVC:  UIViewController {
  var topBar: UIView = UIView()
  let swiftColor: UIColor = UIColor(red: 41.0/255.0, green: 189.0/255.0, blue: 56.0/255.0, alpha: 1.0)
  let quantityArray = ["1 X ", "2 X ", "1 X ", "3 X ", "1 X ", "", ""]
  let itemNames = ["Carbomb", "Beer Cheese Dip", "Bourbon Double", "Fireball", "Pizza Bites", "Tax", "Total"]
  let totalArray = ["4.00", "7.00", "6.50", "5.50", "9.00", "1.92", "$ 33.92"]
  var locationLabel: UILabel = UILabel()
  var titleLabel: UILabel = UILabel()
  var cancelCircle = UIButton()
  var defaultTipCircle = UIButton()
  var customTipCircle = UIButton()
  let closeTabButton = UIButton()
  var circleMenuOpen: Bool = false
  var paidCheckMark: UIButton = UIButton()
  var cardView: UIView = UIView()
  var avatarImageView: UIImageView = UIImageView()
  var descriptionTextView: UITextView = UITextView()
  var addressLabel: UILabel = UILabel()
  var startTabButton: UIButton = UIButton()
  let goBackButton: UIButton = UIButton()
  var avatarImage: UIImage = UIImage()
  var locationAddress: String = String()

  
  //Data vars my ninja
  var avatar: UIImage = UIImage()
  var avatarString: String = String()
  var descriptionText: String = String()
  var locationNameText:String = String()
  var addressText: String = String()
  var locationId: String = String()
  
  var tabService: TabService = TabService()
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cardView.frame = CGRectMake(10 , self.view.frame.height / 4 , self.view.frame.width - 20, self.view.frame.height / 2)
    cardView.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)//UIColor.whiteColor()
    cardView.clipsToBounds = true
    cardView.layer.cornerRadius = 10
    self.view.addSubview(cardView)
    self.view.backgroundColor = UIColor.whiteColor()
    
    avatarImageView.frame = CGRect(x: cardView.layer.frame.width / 2 - cardView.layer.frame.width / 8, y: cardView.layer.frame.height / 8, width: cardView.layer.frame.width / 4, height: cardView.layer.frame.height / 4)
    avatarImageView.clipsToBounds = true
    avatarImageView.layer.cornerRadius = 10
    avatarImageView.image = avatarImage//UIImage(named: avatarString)
    cardView.addSubview(avatarImageView)
    
    locationLabel.frame = CGRect(x: 0, y: cardView.layer.frame.height / 2.5, width: cardView.layer.frame.width, height: 50)
    locationLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
    locationLabel.textColor = UIColor.whiteColor()
    locationLabel.clipsToBounds = true
    locationLabel.textAlignment = NSTextAlignment.Center
    locationLabel.layer.cornerRadius = 10
    locationLabel.text = self.locationNameText
    self.cardView.addSubview(locationLabel)
    
    addressLabel.frame = CGRect(x: 0, y: cardView.layer.frame.height / 2.1, width: cardView.layer.frame.width, height: 50)
    addressLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    addressLabel.textColor = UIColor.whiteColor()
    addressLabel.clipsToBounds = true
    addressLabel.textAlignment = NSTextAlignment.Center
    addressLabel.layer.cornerRadius = 10
    addressLabel.text = locationAddress//"208 Grandville Ave. SW, Grand Rapids"
    self.cardView.addSubview(addressLabel)
    
    let topSeperator: UIView = UIView()
    topSeperator.frame = CGRect(x: 5, y: cardView.layer.frame.height / 1.74, width: cardView.layer.frame.width - 10, height: 2)
    topSeperator.backgroundColor =  UIColor.whiteColor()
    cardView.addSubview(topSeperator)

    
    descriptionTextView.frame = CGRect(x: 0, y: cardView.layer.frame.height / 1.70, width: cardView.layer.frame.width, height: cardView.layer.frame.width / 3)
    descriptionTextView.font = UIFont(name: "JosefinSans-SemiBold", size: 20);
    descriptionTextView.textColor = UIColor.whiteColor()
    descriptionTextView.backgroundColor = UIColor.clearColor()
    descriptionTextView.clipsToBounds = true
    descriptionTextView.textAlignment = NSTextAlignment.Center
    descriptionTextView.layer.cornerRadius = 10
    descriptionTextView.text = "Welcome to the Tin Can! Come in for your favorite canned beer and try the pudding shots! Open late Friday and Saturday."
    self.cardView.addSubview(descriptionTextView)
    
    startTabButton.frame = CGRectMake(10 , cardView.layer.frame.height - cardView.frame.height / 6 - 10, cardView.layer.frame.width - 20, cardView.frame.height / 6)
    startTabButton.backgroundColor = UIColor.clearColor()
    startTabButton.titleLabel?.textColor = UIColor(red: (119/255.0), green: (190/255.0), blue: (119/255.0), alpha: 1)
    startTabButton.setTitle("Start Tab", forState: UIControlState.Normal)
    startTabButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
    startTabButton.layer.borderWidth = 2.0
    startTabButton.layer.borderColor = UIColor(red: (119/255.0), green: (190/255.0), blue: (119/255.0), alpha: 1).CGColor
    startTabButton.setTitleColor(UIColor(red: (119/255.0), green: (190/255.0), blue: (119/255.0), alpha: 1), forState: .Normal)
    //119 190 119
    startTabButton.clipsToBounds = true
    startTabButton.layer.cornerRadius = 10
    startTabButton.addTarget(self, action: "startTabAction:", forControlEvents: UIControlEvents.TouchUpInside)
    cardView.addSubview(startTabButton)

    
    let closeImage = UIImage(named: "close.png") as UIImage?
    goBackButton.frame = CGRectMake(self.view.frame.width - 70, 10, 40, 40)
    goBackButton.setImage(closeImage, forState: .Normal)
    goBackButton.clipsToBounds = true
    goBackButton.layer.cornerRadius = 10
    goBackButton.addTarget(self, action: "dismissModal", forControlEvents: UIControlEvents.TouchUpInside)
    self.cardView.addSubview(goBackButton)
    
    
    
    
  }
  
  func startTabAction(completion: (result: String) -> Void) {
    self.tabService.startTab(Keychain.get("nomadAuthToken") as! String, locationId:  self.locationId, tipPercent: "10", completionHandler: { json in
      print("success")
      }, errorHandler: { error in
        // handle the error
        print(error);
    });


    UIView.animateWithDuration(0.5, animations: {() in
      self.startTabButton.backgroundColor = UIColor(red: (119/255.0), green: (190/255.0), blue: (119/255.0), alpha: 1)
      self.startTabButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
      self.startTabButton.center.y = self.cardView.layer.frame.height / 2
      self.view.bringSubviewToFront(self.startTabButton)

      }, completion:{(Bool) in
        
        UIView.animateWithDuration(0.5, animations: { () in
          self.goBackButton.alpha = 0.0
          self.view.backgroundColor =  UIColor(red: (255/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0)//UIColor.whiteColor()
          var frame: CGRect = self.startTabButton.frame
          frame.size.width = self.cardView.layer.frame.width + 30
          frame.size.height = self.cardView.layer.frame.height + 30
          self.startTabButton.frame = frame
          self.startTabButton.center.y = self.cardView.layer.frame.height / 2
          self.startTabButton.center.x = self.cardView.layer.frame.width / 2
          self.startTabButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
          self.startTabButton.setTitle("Started Tab!", forState: .Normal)

        }, completion:{(Bool) in
            
          let delay = 0.6 * Double(NSEC_PER_SEC)
          let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
          dispatch_after(time, dispatch_get_main_queue()) {
            self.dismissViewControllerAnimated(true, completion: nil)
          }
        })
    })
  }
  
  override func viewDidAppear(animated: Bool) {
    self.circleMenuOpen = false
    
  }
  /*
  func showCloseTabOptions() {
    if(self.circleMenuOpen == false) {
      UIView.animateWithDuration(0.5, animations: {
        self.closeTabButton.alpha = 0.25
        self.cancelCircle.center.x = self.view.frame.width * (3/4)
        self.cancelCircle.center.y = self.closeTabButton.center.y + 5 - self.closeTabButton.frame.height
        self.customTipCircle.center.x =  self.view.frame.width / 4
        self.customTipCircle.center.y =  self.closeTabButton.center.y + 5 - self.closeTabButton.frame.height
        self.defaultTipCircle.center.y = self.closeTabButton.center.y + 5 - self.closeTabButton.frame.height
      })
      self.circleMenuOpen = true
    } else {
      UIView.animateWithDuration(0.5, animations: {
        self.closeTabButton.alpha = 1.0
        self.cancelCircle.center.x = self.closeTabButton.center.x
        self.cancelCircle.center.y = self.closeTabButton.center.y
        self.customTipCircle.center.x =  self.closeTabButton.center.x
        self.customTipCircle.center.y =  self.closeTabButton.center.y
        self.defaultTipCircle.center.y = self.closeTabButton.center.y
      })
      self.circleMenuOpen = false
    }
    
  }
  */
  func dismissModal() {
    dismissViewControllerAnimated(false, completion: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  
}