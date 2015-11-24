//
//  SettingsVC.swift
//  Nomad
//
//  Created by Hayden Davis on 10/5/15.
//

import Foundation
import UIKit

class SettingsVC: UIViewController, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
  
  var avatarImage = UIImage()
  var avatarView = UIImageView()
  var userNameLabel: UILabel = UILabel()
  var profileButton: UIButton = UIButton()
  var recieptsButton: UIButton = UIButton()
  var dot: UILabel = UILabel()
  var profileTabView: UIView = UIView()
  var recieptsTabView: UIView = UIView()
  
  var fullNameLabel: UILabel = UILabel()
  var fullNameField: UITextField = UITextField()
  
  var phoneNumberLabel: UILabel = UILabel()
  var phoneNumberField: UITextField = UITextField()
  
  var emailLabel: UILabel = UILabel()
  var emailField: UITextField = UITextField()
  
  var defaultTipLabel: UILabel = UILabel()
  var defaultTipField: UITextField = UITextField()
  
  var localDealLabel: UILabel = UILabel()
  var localDealsSwitch: UISwitch = UISwitch()
  
  var changePhotoButton: UIButton = UIButton()
  var changePaymentButton: UIButton = UIButton()
  
  var updateProfileButton: UIButton = UIButton()
  var logoutButton: UIButton = UIButton()

  var touched = UITapGestureRecognizer()

  
  var receiptService: ReceiptService = ReceiptService()

  var tableView: UITableView!
  
  var items: [Receipt] = []

  
  /////TAKE OUT AFTER API's ARE DONE
  let fakePlaces = ["New Holland Brewery", "Tin Can", "Stella's", "Pyramid Scheme", "McFaddens", "Mojo's", "The BOB", "Founders", "HopCat", "Our Brewing Company"]
  
  let fakeTabsOpen = ["June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015", "June 16th, 2015"]
  
  let imageArray = ["BAR_LOGOS_1.gif", "bar-logos-23.jpg", "images-1.jpg", "images-2.jpg", "images-3.jpg", "images-4.jpg", "images.jpg", "imgres.jpg", "The-Bar-logo.jpg", "images-5.jpg"]
  
  var viewCurrentTab: UIBarButtonItem?
  
  ///////
  
  override func viewDidAppear(animated: Bool) {
    navigationController?.navigationBar.topItem?.title = "Profile"
    if let theUserId = Keychain.get("nomadUserId") as? String {
      self.receiptService.getReceipts(theUserId, completionHandler: self.receiptsRetreived, errorHandler: {(error) in
        print(error);
      })
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    avatarImage = UIImage(named: "tjProfPic.jpg")!
    //Remove when real data is there

    self.view.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    avatarView = UIImageView(frame: CGRectMake(self.view.frame.width/2 - 35, 80, 70, 70))
    avatarView.backgroundColor = UIColor.whiteColor()
    avatarView.clipsToBounds = true
    avatarView.layer.cornerRadius = 10
    avatarView.image = avatarImage
    self.view.addSubview(avatarView)
    
    userNameLabel.text = Keychain.get("nomadFullName") as? String
    userNameLabel.frame = CGRectMake(0, 160, self.view.frame.width, 30)
    userNameLabel.textColor = UIColor.whiteColor()
    userNameLabel.textAlignment = NSTextAlignment.Center
    userNameLabel.font =  UIFont(name: "JosefinSans-SemiBold", size: 25);
    self.view.addSubview(userNameLabel)
    
    profileButton.frame = CGRectMake(self.view.frame.width * 0.75 - 20, 200, 40, 40)
    profileButton.setBackgroundImage(UIImage(named: "gear"), forState: UIControlState.Normal)
    profileButton.addTarget(self, action: "showProfileTab", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(profileButton)
    
    recieptsButton.frame = CGRectMake(self.view.frame.width * 0.25 - 20, 200, 40, 40)
    recieptsButton.setBackgroundImage(UIImage(named: "pastBills"), forState: UIControlState.Normal)
    recieptsButton.addTarget(self, action: "showRecieptsTab", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(recieptsButton)
    
    dot.frame = CGRectMake(self.view.frame.width * 0.25 - 4, 245, 8, 8)
    dot.backgroundColor = UIColor.whiteColor()
    dot.clipsToBounds = true
    dot.layer.cornerRadius = dot.frame.size.width * 0.5
    self.view.addSubview(dot)
    
    
    
    //Receipts View Setup ----------------------------------------
    recieptsTabView.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    recieptsTabView.frame = CGRectMake(0, self.view.frame.height * 0.38, self.view.frame.width, self.view.frame.height * 0.65)
    // reciepts tableview
    let frame:CGRect = CGRect(x: recieptsTabView.frame.width * 0.05, y: 0, width: recieptsTabView.frame.width * 0.90, height: recieptsTabView.frame.height * 0.90)
    self.tableView = UITableView(frame: frame)
    self.tableView?.dataSource = self
    self.tableView?.delegate = self
    self.tableView.backgroundColor = UIColor.whiteColor()
    self.recieptsTabView.addSubview(self.tableView!)
    var nib = UINib(nibName: "ReceiptCellView", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "ReceiptCellView")
    tableView.rowHeight = 74
    tableView.separatorStyle = .None
    tableView.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    recieptsTabView.addSubview(tableView)
    showRecieptsTab()
    //------------------------------------------------------------
    
    
    
    //Profile View Setup -----------------------------------------
    profileTabView.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    profileTabView.frame = CGRectMake(0, self.view.frame.height * 0.38, self.view.frame.width, self.view.frame.height * 0.65)
    
    fullNameLabel.text = "Full Name"
    fullNameLabel.textColor = UIColor.whiteColor()
    fullNameLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    fullNameLabel.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.01, profileTabView.frame.width * 0.90, 20)
    fullNameLabel.textAlignment = NSTextAlignment.Left
    profileTabView.addSubview(fullNameLabel)
    
    fullNameField.backgroundColor = UIColor.whiteColor()
    fullNameField.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.055, profileTabView.frame.width * 0.90, 25)
    fullNameField.placeholder = "Enter your name"
    profileTabView.addSubview(fullNameField)
    
    /*
    phoneNumberLabel.text = "Phone Number"
    phoneNumberLabel.textColor = UIColor.whiteColor()
    phoneNumberLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    phoneNumberLabel.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.115, profileTabView.frame.width * 0.45, 20)
    profileTabView.addSubview(phoneNumberLabel)
    
    phoneNumberField.backgroundColor = UIColor.whiteColor()
    phoneNumberField.placeholder = "xxx-xxx-xxxx"
    phoneNumberField.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.16, profileTabView.frame.width * 0.45, 25)
    profileTabView.addSubview(phoneNumberField)
    */
    
    emailLabel.text = "Email"
    emailLabel.textColor = UIColor.whiteColor()
    emailLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    emailLabel.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.115, profileTabView.frame.width * 0.45, 20) //CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.22, profileTabView.frame.width * 0.45, 20)
    profileTabView.addSubview(emailLabel)
    
    emailField.backgroundColor = UIColor.whiteColor()
    emailField.placeholder = "example@mail.com"
    emailField.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.16, profileTabView.frame.width * 0.45, 25) //CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.265, profileTabView.frame.width * 0.45, 25)
    profileTabView.addSubview(emailField)
    
    defaultTipLabel.text = "Default Tip %"
    defaultTipLabel.textColor = UIColor.whiteColor()
    defaultTipLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    defaultTipLabel.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.22, profileTabView.frame.width * 0.45, 20)
//CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.325, profileTabView.frame.width * 0.45, 20)
    profileTabView.addSubview(defaultTipLabel)
    
    defaultTipField.backgroundColor = UIColor.whiteColor()
    defaultTipField.placeholder = "Enter in % of total bill"
    defaultTipField.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.265, profileTabView.frame.width * 0.45, 25)
//CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.37, profileTabView.frame.width * 0.45, 25)
    profileTabView.addSubview(defaultTipField)
    
    localDealLabel.text = "Nearby Deal Notifications?"
    localDealLabel.textColor = UIColor.whiteColor()
    localDealLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    localDealLabel.frame = CGRectMake(profileTabView.frame.width * 0.53, profileTabView.frame.height * 0.115, profileTabView.frame.width * 0.45, 20)
    profileTabView.addSubview(localDealLabel)
    
    localDealsSwitch.frame = CGRectMake(profileTabView.frame.width * 0.53, profileTabView.frame.height * 0.16, profileTabView.frame.width * 0.45, 25)
    profileTabView.addSubview(localDealsSwitch)
    
    changePhotoButton.frame = CGRectMake(profileTabView.frame.width * 0.52, profileTabView.frame.height * 0.265, profileTabView.frame.width * 0.45, 25)
    changePhotoButton.setTitle("Change Photo", forState: UIControlState.Normal)
    changePhotoButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    changePhotoButton.clipsToBounds = true
    changePhotoButton.layer.cornerRadius = 10.0
    changePhotoButton.backgroundColor =  UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    profileTabView.addSubview(changePhotoButton)
    
    //changePaymentButton.frame = CGRectMake(profileTabView.frame.width * 0.52, profileTabView.frame.height * 0.370, profileTabView.frame.width * 0.45, 25)
    changePaymentButton.frame = CGRectMake(profileTabView.frame.width * 0.05, profileTabView.frame.height * 0.370, profileTabView.frame.width * 0.90, 25)
    changePaymentButton.setTitle("Change Payment", forState: UIControlState.Normal)
    changePaymentButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    changePaymentButton.clipsToBounds = true
    changePaymentButton.layer.cornerRadius = 10.0
    changePaymentButton.backgroundColor =  UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    changePaymentButton.addTarget(self, action: "openPaymentOptionVC", forControlEvents: UIControlEvents.TouchUpInside)
    profileTabView.addSubview(changePaymentButton)
    
    updateProfileButton.frame = CGRectMake(self.view.frame.width * (2/3), -20, self.view.frame.width / 4, 40)
    updateProfileButton.setTitle("Update Profile", forState: UIControlState.Normal)
    updateProfileButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    updateProfileButton.clipsToBounds = true
    updateProfileButton.layer.cornerRadius = 10.0
    updateProfileButton.backgroundColor =  UIColor(red: (119/255.0), green: (190/255.0), blue: (119/255.0), alpha: 1)
    
    logoutButton.frame = CGRectMake(self.view.frame.width * (1/3) - self.view.frame.width / 4, -20, self.view.frame.width / 4, 40)
    logoutButton.setTitle("Logout :(", forState: UIControlState.Normal)
    logoutButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    logoutButton.clipsToBounds = true
    logoutButton.layer.cornerRadius = 10.0
    logoutButton.backgroundColor =  UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
    logoutButton.addTarget(self, action: "logout", forControlEvents: UIControlEvents.TouchUpInside)

    self.touched = UITapGestureRecognizer(target: self, action: "resign")
    self.view.addGestureRecognizer(touched)
    touched.enabled = false

  
  }
  
  func openPaymentOptionVC() {
    let paymentVC = PaymentVC()
    self.presentViewController(paymentVC, animated: true, completion: nil)
  }
  
  func receiptsRetreived(theReceipts:  [Receipt] ){
    self.items = theReceipts
    dispatch_async(dispatch_get_main_queue(), {
      self.tableView.reloadData()
    })
  }
  
  func logout() {
    Keychain.set("validUser", value: "false")
    Keychain.delete("nomadFullName")
    Keychain.delete("nomadUserId")
    Keychain.delete("nomadAuthToken")


   /* Keychain.set("nomadUserId", value: "" as String)
    Keychain.set("nomadAuthToken", value: "" as String)
    Keychain.set("nomadSecret", value: "" as String)
    Keychain.set("nomadPhoneNumber", value: "" as String)
*/
    self.performSegueWithIdentifier("pushLogin", sender: self)

  }
  
  func resign() {
    defaultTipField.resignFirstResponder()
    emailField.resignFirstResponder()
    fullNameField.resignFirstResponder()
    phoneNumberField.resignFirstResponder()

  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let rec: Receipt = self.items[indexPath.row]
    theCurrentReceipt = rec
    showTabDetail(rec)
  }
  
  func showTabDetail(theReceipt: Receipt) {
    let oldTab = OldTabVC()
    oldTab.view.backgroundColor =  UIColor(red: (255.0/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.50)
    oldTab.modalPresentationStyle = .OverFullScreen
    let popoverPresentationViewController = oldTab.popoverPresentationController
    popoverPresentationViewController?.sourceView = self.view
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(oldTab, animated: true, completion: nil)
    })

  }
  
  func showCurrentTab() {
    let currentTabView = CurrentTabPopover()
    currentTabView.view.backgroundColor =  UIColor(red: (255.0/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.50)
    currentTabView.modalPresentationStyle = .OverFullScreen
    let popoverPresentationViewController = currentTabView.popoverPresentationController
    popoverPresentationViewController?.sourceView = self.view
    presentViewController(currentTabView, animated: true, completion: nil)
    
  }
  
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("ReceiptCellView", forIndexPath: indexPath) as! ReceiptCellView
    let theReceipt = self.items[indexPath.row]
    cell.userInteractionEnabled = true
    cell.selectionStyle = .None
    cell.locationName.text = theReceipt.locName
    cell.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.dateLabel.text = theReceipt.closedAt
    cell.avatar.clipsToBounds = true
    cell.avatar.layer.cornerRadius = 10
    cell.avatar.image = theReceipt.avatarImage
    let topSeperator: UIView = UIView()
    topSeperator.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 4.0, width: cell.contentView.frame.size.width, height: 4)
    topSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.contentView.addSubview(topSeperator)
    let bottomSeperator: UIView = UIView()
    bottomSeperator.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: 4)
    bottomSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.contentView.addSubview(bottomSeperator)
    cell.backView.frame = CGRectMake(0, 4, cell.contentView.frame.width * 0.99, 65)
    return cell
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
  }

  func showProfileTab() {
    touched.enabled = true
   // recieptsTabView.removeFromSuperview()
    self.view.addSubview(updateProfileButton)
    self.view.addSubview(logoutButton)

    UIView.animateWithDuration(0.5, animations: {
      self.updateProfileButton.center.y = 120
      self.logoutButton.center.y = 120
    })
    resign()

    let spinAnimation = CABasicAnimation()
    // starts from 0
    spinAnimation.fromValue = 0
    // goes to 360 ( 2 * π )
    spinAnimation.toValue = M_PI
    // define how long it will take to complete a 360
    spinAnimation.duration = 0.5
    // make it spin infinitely
    spinAnimation.repeatCount = 1.0 
    // do not remove when completed
    spinAnimation.removedOnCompletion = true
    // specify the fill mode
    spinAnimation.fillMode = kCAFillModeForwards
    // and the animation acceleration
    spinAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    // add the animation to the button layer
    profileButton.layer.addAnimation(spinAnimation, forKey: "transform.rotation.z")
    self.view.addSubview(self.profileTabView)
    UIView.animateWithDuration(0.5, animations: {
      self.dot.center.x = self.view.frame.width * 0.75
    })

  }
  
  func showRecieptsTab() {
    touched.enabled = false
   // updateProfileButton.removeFromSuperview()
    UIView.animateWithDuration(0.5, animations: {
      self.updateProfileButton.center.y = -20
      self.logoutButton.center.y = -20
    })
    resign()
    profileTabView.removeFromSuperview()
    let flipAnimation = CABasicAnimation()
    // starts from 0
    flipAnimation.fromValue = 0
    // goes to 360 ( 2 * π )
    flipAnimation.toValue = M_PI * 2
    // define how long it will take to complete a 360
    flipAnimation.duration = 0.5
    // make it spin infinitely
    flipAnimation.repeatCount = 1.0 //Float.infinity
    // do not remove when completed
    flipAnimation.removedOnCompletion = true
    // specify the fill mode
    flipAnimation.fillMode = kCAFillModeForwards
    // and the animation acceleration
    flipAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
    // add the animation to the button layer
    self.recieptsButton.layer.addAnimation(flipAnimation, forKey: "transform.rotation.y")

    self.view.addSubview(recieptsTabView)
    UIView.animateWithDuration(0.5, animations: {
      self.dot.center.x = self.view.frame.width * 0.25 - 0
    })

  }

}

