//
//  LocationDetailVC.swift
//  Nomad
//
//  Created by Hayden Davis on 10/7/15.
//

import Foundation
import UIKit

class LocationDetailVC: UIViewController {

var avatarImage = UIImage()
var avatarView = UIImageView()
var changePhotoLabel: UILabel = UILabel()
var fullNameLabel: UILabel = UILabel()
var fullNameField: UITextField = UITextField()
var phoneNumberLabel: UILabel = UILabel()
var phoneNumberField: UITextField = UITextField()

override func viewDidAppear(animated: Bool) {
  navigationController?.navigationBar.topItem?.title = "Profile"
  
}

override func viewDidLoad() {
  super.viewDidLoad()

  self.view.backgroundColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
  
  avatarView = UIImageView(frame: CGRectMake(self.view.frame.width/2 - 35, 80, 70, 70))
  avatarView.backgroundColor = UIColor.whiteColor()
  avatarView.clipsToBounds = true
  avatarView.layer.cornerRadius = 10
  self.view.addSubview(avatarView)
  
  changePhotoLabel.text = "Change Photo"
  changePhotoLabel.frame = CGRectMake(self.view.frame.width / 2 - 55, 160, 110, 35)
  changePhotoLabel.textColor = UIColor.whiteColor()
  changePhotoLabel.font = UIFont(name: "Noteworthy-Bold", size: 16);
  changePhotoLabel.backgroundColor = UIColor.blackColor()
  changePhotoLabel.textAlignment = NSTextAlignment.Center
  changePhotoLabel.clipsToBounds = true
  changePhotoLabel.layer.cornerRadius = 10
  changePhotoLabel.layer.borderColor = UIColor.whiteColor().CGColor
  changePhotoLabel.layer.borderWidth = 2.0
  self.view.addSubview(changePhotoLabel)
  
  phoneNumberLabel.text = "Phone Number"
  phoneNumberLabel.frame = CGRectMake(10, 250, self.view.frame.width - 20, 45)
  phoneNumberLabel.textColor = UIColor.whiteColor()
  self.view.addSubview(phoneNumberLabel)
  
  
  fullNameLabel.text = "Full Name"
  fullNameLabel.frame = CGRectMake(10, 180, self.view.frame.width - 20, 45)
  fullNameLabel.textColor = UIColor.whiteColor()
  self.view.addSubview(fullNameLabel)
  
  fullNameField.frame = CGRectMake(10, 220, self.view.frame.width - 20, 45)
  fullNameField.backgroundColor = UIColor.whiteColor()
  fullNameField.clipsToBounds = true
  fullNameField.layer.cornerRadius = 10
  self.view.addSubview(fullNameField)
  
  phoneNumberLabel.text = "Phone Number"
  phoneNumberLabel.frame = CGRectMake(10, 260, self.view.frame.width - 20, 45)
  phoneNumberLabel.textColor = UIColor.whiteColor()
  self.view.addSubview(phoneNumberLabel)
  
  phoneNumberField.frame = CGRectMake(10, 300, self.view.frame.width - 20, 45)
  phoneNumberField.backgroundColor = UIColor.whiteColor()
  phoneNumberField.keyboardType = UIKeyboardType.PhonePad
  phoneNumberField.clipsToBounds = true
  phoneNumberField.layer.cornerRadius = 10
  self.view.addSubview(phoneNumberField)
}
}
