//
//  ProfileTabPopover.swift
//  Nomad
//
//  Created by Hayden Davis on 10/12/15.
//

import Foundation
import UIKit

class ProfileTabPopover: UIViewController {
  
  var changePhotoLabel: UILabel = UILabel()
  var fullNameLabel: UILabel = UILabel()
  var fullNameField: UITextField = UITextField()
  var phoneNumberLabel: UILabel = UILabel()
  var phoneNumberField: UITextField = UITextField()
  var profileTabView: UIView = UIView()
  var recieptsTabView: UIView = UIView()
  
  override func viewDidAppear(animated: Bool) {
    navigationController?.navigationBar.topItem?.title = "Profile"
    
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //Remove when real data is there
    
    
    
    
    
    self.view.backgroundColor = UIColor.whiteColor()
    
    phoneNumberLabel.text = "Phone Number"
    phoneNumberLabel.frame = CGRectMake(10, 250, self.view.frame.width - 20, 45)
    phoneNumberLabel.textColor = UIColor.whiteColor()
    // self.view.addSubview(phoneNumberLabel)
    
    
    fullNameLabel.text = "Full Name"
    fullNameLabel.frame = CGRectMake(10, 180, self.view.frame.width - 20, 45)
    fullNameLabel.textColor = UIColor.whiteColor()
    //self.view.addSubview(fullNameLabel)
    
    fullNameField.frame = CGRectMake(10, 220, self.view.frame.width - 20, 45)
    fullNameField.backgroundColor = UIColor.whiteColor()
    fullNameField.clipsToBounds = true
    fullNameField.layer.cornerRadius = 10
    //self.view.addSubview(fullNameField)
    
    phoneNumberLabel.text = "Phone Number"
    phoneNumberLabel.frame = CGRectMake(10, 260, self.view.frame.width - 20, 45)
    phoneNumberLabel.textColor = UIColor.whiteColor()
    //self.view.addSubview(phoneNumberLabel)
    
    phoneNumberField.frame = CGRectMake(10, 300, self.view.frame.width - 20, 45)
    phoneNumberField.backgroundColor = UIColor.whiteColor()
    phoneNumberField.keyboardType = UIKeyboardType.PhonePad
    phoneNumberField.clipsToBounds = true
    phoneNumberField.layer.cornerRadius = 10
    // self.view.addSubview(phoneNumberField)
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}
