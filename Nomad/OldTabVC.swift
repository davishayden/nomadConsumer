//
//  OldTabVC.swift
//  Nomad
//
//  Created by Hayden Davis on 10/12/15.
//

import UIKit

class OldTabVC:  UIViewController, UITableViewDataSource, UITableViewDelegate {
  var topBar: UIView = UIView()
  var tableView:UITableView!
  let quantityArray = ["1 X ", "2 X ", "1 X ", "3 X ", "1 X ", "", ""]
  let itemNames = ["Carbomb", "Beer Cheese Dip", "Bourbon Double", "Fireball", "Pizza Bites", "Tax", "Total"]
  let totalArray = ["4.00", "7.00", "6.50", "5.50", "9.00", "1.92", "$ 33.42"]
  var locationLabel: UILabel = UILabel()
  var dateLabel: UILabel = UILabel()
  let sendEmailReceipt = UIButton()
  var circleMenuOpen: Bool = false
  var paidCheckMark: UIButton = UIButton()
  var cardView: UIView = UIView()
  var oldTabObject: Receipt = Receipt()
  var receiptService: ReceiptService = ReceiptService()
  var items: [Transaction] = []
  var loader = UIActivityIndicatorView()

  
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    cardView.frame = CGRectMake(10 , self.view.frame.height * 0.05, self.view.frame.width - 20, self.view.frame.height * 0.92)
    cardView.backgroundColor = UIColor.whiteColor()
    cardView.clipsToBounds = true
    cardView.layer.cornerRadius = 10
    self.view.addSubview(cardView)
    
    self.view.backgroundColor = UIColor.whiteColor()
    dateLabel.frame = CGRect(x: self.view.frame.width / 2 - 100, y: 30.0, width: 200, height: 50)
    dateLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    dateLabel.textColor = UIColor.blackColor()
    dateLabel.clipsToBounds = true
    dateLabel.textAlignment = NSTextAlignment.Center
    dateLabel.layer.cornerRadius = 10
    dateLabel.text = theCurrentReceipt.closedAt
    self.view.addSubview(dateLabel)
    
    locationLabel.frame = CGRect(x: 20, y: 60.0, width: self.view.frame.width - 40, height: 50)
    locationLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
    locationLabel.textColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    locationLabel.clipsToBounds = true
    locationLabel.textAlignment = NSTextAlignment.Center
    locationLabel.layer.cornerRadius = 10
    locationLabel.text = theCurrentReceipt.locName
    self.view.addSubview(locationLabel)
    
    sendEmailReceipt.frame = CGRectMake(self.view.frame.width / 2 - self.view.frame.width / 6 + 10 , self.view.frame.height - self.view.frame.width / 3 - 5, self.view.frame.width / 3 - 22, self.view.frame.width / 3 - 20)
    sendEmailReceipt.backgroundColor = UIColor.whiteColor()
    sendEmailReceipt.titleLabel?.textColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
    sendEmailReceipt.setTitle("Email Receipt", forState: UIControlState.Normal)
    sendEmailReceipt.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 20);
    sendEmailReceipt.layer.borderWidth = 2.0
    sendEmailReceipt.layer.borderColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1).CGColor
    sendEmailReceipt.setTitleColor(UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1), forState: .Normal)
    sendEmailReceipt.clipsToBounds = true
    sendEmailReceipt.layer.cornerRadius = sendEmailReceipt.frame.size.width * 0.5
    sendEmailReceipt.addTarget(self, action: "sendEmailAlert", forControlEvents: UIControlEvents.TouchUpInside)
    sendEmailReceipt.titleLabel!.numberOfLines = 1;
    sendEmailReceipt.titleLabel!.adjustsFontSizeToFitWidth = true;
    sendEmailReceipt.titleLabel!.lineBreakMode = NSLineBreakMode.ByClipping;
    sendEmailReceipt.titleLabel?.textAlignment = NSTextAlignment.Center
    self.view.addSubview(sendEmailReceipt)
    
    let closeImage = UIImage(named: "close.png") as UIImage?
    let goBackButton: UIButton = UIButton()
    goBackButton.frame = CGRectMake(self.view.frame.width - 60, 40, 40, 60)
    goBackButton.setImage(closeImage, forState: .Normal)
    goBackButton.clipsToBounds = true
    goBackButton.layer.cornerRadius = 10
    goBackButton.addTarget(self, action: "dismissModal", forControlEvents: UIControlEvents.TouchUpInside)
    self.view.addSubview(goBackButton)
    
    let frame:CGRect = CGRect(x: 10, y: 120, width: self.view.frame.width - 20, height: self.view.frame.height * (5/8))
    self.tableView = UITableView(frame: frame)
    self.tableView?.dataSource = self
    self.tableView?.delegate = self
    self.tableView?.separatorColor = UIColor.clearColor()
    self.view.addSubview(self.tableView!)
    
    var nib = UINib(nibName: "CurrentTabCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "CurrentTabCell")
    tableView.rowHeight = 50
    loader.frame = CGRectMake(0, 0, self.tableView.frame.width , self.tableView.frame.height)
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    loader.startAnimating()
    self.tableView.addSubview(loader)

    
    
    
    self.receiptService.getReceipt(Keychain.get("nomadAuthToken") as! String, tabId: theCurrentReceipt.id!, completionHandler: { json in
      self.items = theCurrentReceiptTrans.transactions
      
    
      dispatch_async(dispatch_get_main_queue(), {
        self.tableView.reloadData()
      })
      dispatch_async(dispatch_get_main_queue(), {
        self.loader.removeFromSuperview()
      })
      
      }, errorHandler: { error in
        print(error);
        dispatch_async(dispatch_get_main_queue(), {
          self.loader.removeFromSuperview()
        })
    });

    
  }
  
  
  override func viewDidAppear(animated: Bool) {
    self.circleMenuOpen = false
    
  }
  
  func sendEmailAlert() {
    
  }
  
  func dismissModal() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count;
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = tableView.dequeueReusableCellWithIdentifier("CurrentTabCell", forIndexPath: indexPath) as! CurrentTabCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    cell.quantity.text = self.items[indexPath.row].quantity//quantityArray[indexPath.row]
    cell.itemName.text = self.items[indexPath.row].name//itemNames[indexPath.row]
    cell.total.text = self.items[indexPath.row].total//totalArray[indexPath.row]
    let topSeperator: UIView = UIView()
    topSeperator.frame = CGRect(x: 10, y: 0, width: cell.contentView.frame.size.width - 20, height: 2)
    topSeperator.backgroundColor =  UIColor.whiteColor()
    cell.total.font = UIFont(name: "JosefinSans", size: 22);
    cell.contentView.addSubview(topSeperator)
    if indexPath.row == self.items.count - 1 {
      print("TOTAL")
      let topSeperator: UIView = UIView()
      topSeperator.frame = CGRect(x: 10, y: 0, width: cell.contentView.frame.size.width - 20, height: 2)
      
      topSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
     // cell.contentView.addSubview(topSeperator)
     // cell.itemName.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
      cell.total.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
        cell.contentView.addSubview(topSeperator)
    }
    return cell
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  
}