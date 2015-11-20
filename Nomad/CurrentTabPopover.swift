//
//  CurrentTabPopover.swift
//  Nomad
//
//  Created by Hayden Davis on 10/7/15.
//

import UIKit

class CurrentTabPopover:  UIViewController, UITableViewDataSource, UITableViewDelegate {
  var topBar: UIView = UIView()
  var tableView:UITableView!
  var currentTabObject: Tab = theCurrentTab
  ///////---------------------------------
  let quantityArray = ["1 X ", "2 X ", "1 X ", "3 X ", "1 X ", "", ""]
  let itemNames = ["Carbomb", "Beer Cheese Dip", "Bourbon Double", "Fireball", "Pizza Bites", "Tax", "Total"]
  let totalArray = ["4.00", "7.00", "6.50", "5.50", "9.00", "1.92", "$ 33.42"]
  //--------------------------------------
  var locationLabel: UILabel = UILabel()
  var titleLabel: UILabel = UILabel()
  var cancelCircle = UIButton()
  var defaultTipCircle = UIButton()
  var customTipCircle = UIButton()
  let closeTabButton = UIButton()
  var circleMenuOpen: Bool = false
  var paidCheckMark: UIButton = UIButton()
  var cardView: UIView = UIView()
  var tabService: TabService = TabService()
  var locationService: LocaitonService  = LocaitonService()
  var items: [Transaction] = []
  var nothingOpenView: UIView = UIView()
  var nothingOpenLabel: UILabel = UILabel()
  var loader = UIActivityIndicatorView()
  
  override func viewDidLoad() {
    super.viewDidLoad()


    let closeImage = UIImage(named: "close.png") as UIImage?
    let goBackButton: UIButton = UIButton()
    goBackButton.frame = CGRectMake(self.view.frame.width - 60, 40, 40, 60)
    goBackButton.setImage(closeImage, forState: .Normal)
    goBackButton.clipsToBounds = true
    goBackButton.layer.cornerRadius = 10
    goBackButton.addTarget(self, action: "dismissModal", forControlEvents: UIControlEvents.TouchUpInside)

    cardView.frame = CGRectMake(10 , self.view.frame.height * 0.05, self.view.frame.width - 20, self.view.frame.height * 0.92)
    cardView.backgroundColor = UIColor.whiteColor()
    cardView.clipsToBounds = true
    cardView.layer.cornerRadius = 10
    self.view.addSubview(cardView)
    
    nothingOpenView.frame = CGRectMake(10 , self.view.frame.height * 0.05, self.view.frame.width - 20, self.view.frame.height * 0.92)
    nothingOpenView.backgroundColor = UIColor.whiteColor()
    nothingOpenView.clipsToBounds = true
    nothingOpenView.layer.cornerRadius = 10
    
    nothingOpenLabel.frame = CGRect(x: 10, y: self.cardView.frame.height / 2, width: nothingOpenView.frame.width - 20, height: 50)
    nothingOpenLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    nothingOpenLabel.textColor = UIColor.blackColor()
    nothingOpenLabel.clipsToBounds = true
    nothingOpenLabel.textAlignment = NSTextAlignment.Center
    nothingOpenLabel.layer.cornerRadius = 10
    nothingOpenLabel.text = "You have not tabs open, get out there!"
    nothingOpenView.addSubview(nothingOpenLabel)
    nothingOpenView.addSubview(goBackButton)

    cancelCircle.frame = CGRectMake(self.view.frame.width / 2 - self.view.frame.width / 8 + 10 , self.view.frame.height - self.view.frame.width / 3 - 5, self.view.frame.width / 4 - 20, self.view.frame.width / 4 - 20)
    cancelCircle.titleLabel?.textColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
    cancelCircle.setTitle("Cancel", forState: UIControlState.Normal)
    cancelCircle.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 18);
    cancelCircle.layer.borderWidth = 2.0
    cancelCircle.layer.borderColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1).CGColor
    cancelCircle.setTitleColor(UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1), forState: .Normal)
    cancelCircle.clipsToBounds = true
    cancelCircle.layer.cornerRadius = cancelCircle.frame.size.width * 0.5
    cancelCircle.addTarget(self, action: "showCloseTabOptions", forControlEvents: UIControlEvents.TouchUpInside)

    self.view.addSubview(cancelCircle)
    
    defaultTipCircle.frame = CGRectMake(self.view.frame.width / 2 - self.view.frame.width / 8 + 10 , self.view.frame.height - self.view.frame.width / 3 - 5, self.view.frame.width / 4 - 20, self.view.frame.width / 4 - 20)
    defaultTipCircle.titleLabel?.textColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
    defaultTipCircle.setTitle("Tip 20%", forState: UIControlState.Normal)
    defaultTipCircle.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 18);
    defaultTipCircle.layer.borderWidth = 2.0
    defaultTipCircle.layer.borderColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1).CGColor
    defaultTipCircle.setTitleColor(UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1), forState: .Normal)
    defaultTipCircle.clipsToBounds = true
    defaultTipCircle.layer.cornerRadius = defaultTipCircle.frame.size.width * 0.5
    defaultTipCircle.addTarget(self, action: "payDefaultTip:", forControlEvents: UIControlEvents.TouchUpInside)

    self.view.addSubview(defaultTipCircle)

    customTipCircle.frame = CGRectMake(self.view.frame.width / 2 - self.view.frame.width / 8 + 10 , self.view.frame.height - self.view.frame.width / 3 - 5, self.view.frame.width / 4 - 20, self.view.frame.width / 4 - 20)
    customTipCircle.layer.borderWidth = 2.0
    customTipCircle.layer.borderColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1).CGColor
    customTipCircle.setTitleColor(UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1), forState: .Normal)
    customTipCircle.setTitle("Custom %", forState: UIControlState.Normal)
    customTipCircle.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 18);
    customTipCircle.clipsToBounds = true
    customTipCircle.layer.cornerRadius = customTipCircle.frame.size.width * 0.5
    //customTipCircle.addTarget(self, action: "", forControlEvents: UIControlEvents.TouchUpInside)

    self.view.addSubview(customTipCircle)

    self.view.backgroundColor = UIColor.whiteColor()
    titleLabel.frame = CGRect(x: self.view.frame.width / 2 - 100, y: 30.0, width: 200, height: 50)
    titleLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 16);
    titleLabel.textColor = UIColor.blackColor()
    titleLabel.clipsToBounds = true
    titleLabel.textAlignment = NSTextAlignment.Center
    titleLabel.layer.cornerRadius = 10
    titleLabel.text = "CURRENT TAB"
    self.view.addSubview(titleLabel)
    
    locationLabel.frame = CGRect(x: 20, y: 60.0, width: self.view.frame.width - 40, height: 50)
    locationLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
    locationLabel.textColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    locationLabel.clipsToBounds = true
    locationLabel.textAlignment = NSTextAlignment.Center
    locationLabel.layer.cornerRadius = 10
    
    self.view.addSubview(locationLabel)
    closeTabButton.frame = CGRectMake(self.view.frame.width / 2 - self.view.frame.width / 6 + 10 , self.view.frame.height - self.view.frame.width / 3 - 5, self.view.frame.width / 3 - 20, self.view.frame.width / 3 - 20)
    closeTabButton.backgroundColor = UIColor.whiteColor()
    closeTabButton.titleLabel?.textColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
    closeTabButton.setTitle("Close", forState: UIControlState.Normal)
    closeTabButton.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
    closeTabButton.layer.borderWidth = 2.0
    closeTabButton.layer.borderColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1).CGColor
    closeTabButton.setTitleColor(UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1), forState: .Normal)

    closeTabButton.clipsToBounds = true
    closeTabButton.layer.cornerRadius = closeTabButton.frame.size.width * 0.5
    closeTabButton.addTarget(self, action: "showCloseTabOptions", forControlEvents: UIControlEvents.TouchUpInside)

    self.view.addSubview(closeTabButton)
    self.view.addSubview(goBackButton)

    let frame:CGRect = CGRect(x: 10, y: 120, width: self.view.frame.width - 20, height: self.view.frame.height * (2/3) - 125)
    self.tableView = UITableView(frame: frame)
    self.tableView?.dataSource = self
    self.tableView?.delegate = self
    self.tableView?.separatorColor = UIColor.clearColor()
    self.view.addSubview(self.tableView!)
    
    let nib = UINib(nibName: "CurrentTabCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "CurrentTabCell")
    tableView.rowHeight = 50
    loader.frame = CGRectMake(0, 0, self.tableView.frame.width , self.tableView.frame.height)
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
    loader.startAnimating()
    self.tableView.addSubview(loader)
    
    self.tabService.getCurrentTab(Keychain.get("nomadAuthToken") as! String, completionHandler: { json in
      self.items = theCurrentTab.transactions

      dispatch_async(dispatch_get_main_queue(), {
        self.locationLabel.text = theCurrentTab.locName
        self.tableView.reloadData()
        self.loader.removeFromSuperview()
      })
      dispatch_async(dispatch_get_main_queue(), {

      let indexPath = NSIndexPath(forRow: self.items.count - 1, inSection: 0)
      self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Bottom, animated: true)
      })

      }, errorHandler: { error in
        print(error);
        if(self.items.count == 0) {
          dispatch_async(dispatch_get_main_queue(), {
          self.loader.stopAnimating()
          self.loader.removeFromSuperview()
          self.locationLabel.text = "No tabs open!"
          self.cancelCircle.removeFromSuperview()
          self.defaultTipCircle.removeFromSuperview()
          self.customTipCircle.removeFromSuperview()
          self.closeTabButton.removeFromSuperview()
          })
        }
    });
  }
  
  func payDefaultTip(completion: (result: String) -> Void) {
    self.tabService.closeTab(Keychain.get("nomadAuthToken") as! String, tipPercent: "20", completionHandler: { json in
      print("closed and tipped")
      }, errorHandler: { error in
        print(error);
    });
    self.customTipCircle.alpha = 0.25
    self.cancelCircle.alpha = 0.25
    UIView.animateWithDuration(0.5, animations: {() in
      self.defaultTipCircle.center.y = self.view.center.y
      self.view.bringSubviewToFront(self.defaultTipCircle)
      self.defaultTipCircle.setTitle("PAID", forState: .Normal)
    }, completion:{(Bool) in
        
      UIView.animateWithDuration(0.5, animations: { () in
        var frame: CGRect = self.defaultTipCircle.frame
        self.defaultTipCircle.backgroundColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
        self.defaultTipCircle.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        frame.size.width = self.view.frame.width + 30
        frame.size.height = self.view.frame.height + 30
        self.defaultTipCircle.frame = frame
        self.defaultTipCircle.center = self.view.center
        self.defaultTipCircle.titleLabel?.font = UIFont(name: "JosefinSans-SemiBold", size: 25);
        self.paidCheckMark.frame = CGRect(x: self.view.frame.width / 2, y: self.view.frame.height / 2, width: self.view.frame.width / 3 , height: self.view.frame.width / 3)
        self.paidCheckMark.center = self.view.center
        self.paidCheckMark.backgroundColor = UIColor(red: (230/255.0), green: (68/255.0), blue: (59/255.0), alpha: 1)
        self.paidCheckMark.setBackgroundImage(UIImage(named: "paymentCheckMark.png"), forState: .Normal)
        self.view.addSubview(self.paidCheckMark)
        
        }, completion:{(Bool) in
          let delay = 0.65 * Double(NSEC_PER_SEC)
          let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
          dispatch_after(time, dispatch_get_main_queue()) {
            self.dismissModal()
          }
      })
    })
  }

  override func viewDidAppear(animated: Bool) {
    self.circleMenuOpen = false
  }

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

  func dismissModal() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

  }
  
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if(self.items.count == 0) {
     //self.locationLabel.text = "No tabs open!"
      self.cancelCircle.removeFromSuperview()
      self.defaultTipCircle.removeFromSuperview()
      self.customTipCircle.removeFromSuperview()
      self.closeTabButton.removeFromSuperview()

      
    } else {
      nothingOpenView.removeFromSuperview()
      self.view.addSubview(cancelCircle)
      self.view.addSubview(defaultTipCircle)
      self.view.addSubview(customTipCircle)
      self.view.addSubview(closeTabButton)


    }
    return self.items.count
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("CurrentTabCell", forIndexPath: indexPath) as! CurrentTabCell
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    let theTransaction:Transaction = self.items[indexPath.row]
    cell.quantity.text =  theTransaction.quantity
    cell.itemName.text = theTransaction.name
    cell.total.text = theTransaction.total
    let topSeperator: UIView = UIView()
    topSeperator.frame = CGRect(x: 10, y: 0, width: cell.contentView.frame.size.width - 20, height: 2)
    topSeperator.backgroundColor =  UIColor.whiteColor()
    cell.total.font = UIFont(name: "JosefinSans", size: 22);
    cell.contentView.addSubview(topSeperator)
    
    if theTransaction.name == "Total" {
      let topSeperator: UIView = UIView()
      topSeperator.frame = CGRect(x: 10, y: 0, width: cell.contentView.frame.size.width - 20, height: 2)
      topSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
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