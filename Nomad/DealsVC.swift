//
//  DealsVC.swift
//  Nomad
//
//  Created by Hayden Davis on 10/5/15.
//

import UIKit
import CoreLocation

class DealsVC: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
  let locationManager = CLLocationManager()
  var locationLabel = UILabel()
  var currentLocation = CLLocation()
  var tableView:UITableView!
  let locationService = LocaitonService()
  var tabService: TabService = TabService()
  var loader = UIActivityIndicatorView()

  
  var items = NSMutableArray()
  
  
  /////TAKE OUT AFTER API's ARE DONE
  
  var viewCurrentTab: UIBarButtonItem?
  var deal1: Deal = Deal()
  var deal2: Deal = Deal()
  var deal3: Deal = Deal()
  var deal4: Deal = Deal()

  ///////
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    findMyLocation()
    
    //*********** Take this out once the API Pulls live data ****************
    deal1.locationName = "Founders"
    deal1.avatarImage = UIImage(named: "tjProfPic")
    deal1.message = "10% of all nitro beers today!"
    deal1.redeemed = false
    deal1.avatarImage = imageCache["https://nomadtab.s3-us-west-2.amazonaws.com/company_id/rXr3DDqYJmmeNpAxu/avatar/founderslogo.jpg"]
  
    
    deal2.locationName = "Our Brewing Company"
    deal2.avatarImage = UIImage(named: "tjProfPic")
    deal2.message = "Free order of wings with any purchase of a domestic pitcher"
    deal2.redeemed = false
    deal2.avatarImage = imageCache["https://nomadtab.s3-us-west-2.amazonaws.com/company_id/oRsHLeuBuqw8cmimF/avatar/our_brewing03.png"]

    deal3.locationName = "McFadden's"
    deal3.avatarImage = UIImage(named: "tjProfPic")
    deal3.message = "Half off apps all night with a student ID!"
    deal3.redeemed = true
    deal3.avatarImage = imageCache["https://nomadtab.s3-us-west-2.amazonaws.com/company_id/oRsHLeuBuqw8cmimF/avatar/mcfaddens.jpg"]
    
    deal4.locationName = "HopCat"
    deal4.avatarImage = UIImage(named: "tjProfPic")
    deal4.message = "Buy one get one Bud light. Come on down for trivia night!"
    deal4.redeemed = false
    deal4.avatarImage = imageCache["https://nomadtab.s3-us-west-2.amazonaws.com/company_id/oRsHLeuBuqw8cmimF/avatar/hopcat.png"]

    self.items.addObject(deal1)
    self.items.addObject(deal2)
    self.items.addObject(deal3)
    self.items.addObject(deal4)
    // ************************************************************************

    NSNotificationCenter.defaultCenter().addObserver(self, selector: "removeLoader", name: "removeLoader", object: nil)
    navigationController?.navigationBar.barTintColor = UIColor(red: (179.0/255.0), green: (106/255.0), blue: (219/255.0), alpha: 1);
    self.view.layer.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1).CGColor
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    locationLabel.frame = CGRect(x: 0, y: (self.navigationController?.navigationBar.frame.height)! + 20, width: self.view.frame.width, height: 50)
    locationLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 22);
    locationLabel.textColor = UIColor.whiteColor()
    locationLabel.textAlignment = NSTextAlignment.Center
    locationLabel.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    //self.view.addSubview(locationLabel)
    
    //tableview
    //let frame:CGRect = CGRect(x: 10, y: 114, width: self.view.frame.width - 20, height: self.view.frame.height-160)
    let frame:CGRect = CGRect(x: 10, y: 64, width: self.view.frame.width - 20, height: self.view.frame.height-80)

    self.tableView = UITableView(frame: frame)
    self.tableView?.dataSource = self
    self.tableView?.delegate = self
    self.tableView.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(self.tableView!)
    let nib = UINib(nibName: "DealsNearMeCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "DealsNearMeCell")
    tableView.rowHeight = 74
    tableView.separatorStyle = .None
    
    tableView.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    let viewTabButton  = UIButton(type: .Custom)
    viewTabButton.setImage(UIImage(named: "showCurrentTab"), forState: UIControlState.Normal)
    viewTabButton.frame = CGRectMake(0, 0, 30, 30)
    
    
    let fixedSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
    fixedSpace.width = 20.0
    let bufferSpace:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
    bufferSpace.width = 10.0
    viewCurrentTab = UIBarButtonItem(customView: viewTabButton)
    viewCurrentTab?.action = "showCurrentTab"
    viewTabButton.addTarget(self, action: "showCurrentTab", forControlEvents: UIControlEvents.TouchUpInside)
    
    self.tabBarController!.navigationItem.rightBarButtonItem = viewCurrentTab
    let delay = 0.50 * Double(NSEC_PER_SEC)
    let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
    
    loader.frame = CGRectMake(0, 0, self.tableView.frame.width , self.tableView.frame.height)
    loader.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
    loader.startAnimating()
    

    self.tableView.reloadData()
   // self.tableView.addSubview(loader)
    /*
    dispatch_after(time, dispatch_get_main_queue()) {
      self.locationService.getLocations(currentLat, myLong: currentLong, completionHandler: self.locationsRetrieved, errorHandler: {(error) in
        print(error);
      })
    }
    if(currentLong != 0.0 && currentLong != 0.0) {
      self.locationService.check300(String(currentLat), long: String(currentLong), authToken: Keychain.get("nomadAuthToken") as! String, completionHandler: { json in
        print("success")
        }, errorHandler: { error in
          // handle the error
          print(error);
      });
    }
*/
    
  }
  
  
  func reloadTable(completion:() -> Void) {
    dispatch_async(dispatch_get_main_queue(),{
      self.tableView.reloadData()
    })
    completion()
  }
  
  func alert() {
    dispatch_async(dispatch_get_main_queue(),{
      self.loader.stopAnimating()
      
      self.loader.removeFromSuperview()
    })
  }
  
  
  func locationsRetrieved(theLocations: [Location]) {
    self.items.removeAllObjects()
    self.items.addObjectsFromArray(theLocations);
    reloadTable() { () in
      self.alert()
    }
  }
  
  
  override func viewDidAppear(animated: Bool) {
    
    self.navigationController?.navigationBar.topItem?.title = "Deals Near Me"
    self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "JosefinSans-SemiBold",  size: 24)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
   /* locationService.getLocations(currentLat, myLong: currentLong, completionHandler: locationsRetrieved, errorHandler: {(error) in
      print(error);
    })
*/
    
    self.tableView.reloadData()
    print(Keychain.get("nomadAuthToken"))
    if(currentLong != 0.0 && currentLong != 0.0) {
      self.locationService.check300(String(currentLat), long: String(currentLong), authToken: Keychain.get("nomadAuthToken") as! String, completionHandler: { json in
        print("success")
        }, errorHandler: { error in
          // handle the error
          print(error);
      });
    }
  }
  
  override func viewWillAppear(animated: Bool) {
    
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func findMyLocation() {
    currentLat = Float(currentLocation.coordinate.latitude)
    currentLong = Float(currentLocation.coordinate.longitude)
    CLGeocoder().reverseGeocodeLocation(currentLocation, completionHandler: {(placemarks, error) -> Void in
      
      if error != nil {
        print("Reverse geocoder failed with error" + error!.localizedDescription)
        return
      }
      
      if placemarks!.count > 0 {
        
        if let pm = placemarks?.first {
          if let address = pm.addressDictionary?["Name"] {
            self.locationLabel.text = address as? String
          }
        }
      }
      else {
        print("Problem with the data received from geocoder")
      }
    })
  }
  func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
    print("Error while updating location " + error.localizedDescription)
  }
  
  func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    currentLocation = locationManager.location!
    self.findMyLocation()
  }
  
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("DealsNearMeCell", forIndexPath: indexPath) as! DealsNearMeCell
    let theDeal: Deal = self.items[indexPath.row] as! Deal
    self.tableView.rowHeight = 150.0
    cell.locationName.text = theDeal.locationName
    cell.locationName.font = UIFont(name: "JosefinSans-SemiBold", size: 24.0)
    cell.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.avatar.clipsToBounds = true
    cell.avatar.layer.cornerRadius = 10
    cell.avatar.image = theDeal.avatarImage
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    
    let topSeperator: UIView = UIView()
    topSeperator.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 4.0, width: cell.contentView.frame.size.width, height: 4)
    topSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    //cell.contentView.addSubview(topSeperator)
    
    let bottomSeperator: UIView = UIView()
    bottomSeperator.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: 4)
    bottomSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
   // cell.contentView.addSubview(bottomSeperator)
    
    let backView: UIView = UIView()
    backView.frame = CGRectMake(0, 4, cell.contentView.frame.width + 4, 130)
    backView.layer.cornerRadius = 10
    backView.clipsToBounds = false
    backView.backgroundColor = UIColor.whiteColor()
    cell.contentView.addSubview(backView)
    cell.contentView.sendSubviewToBack(backView)
    
    cell.dealMessage.text = theDeal.message
    cell.dealMessage.font = UIFont(name: "JosefinSans-SemiBold", size: 20.0)
    
    if(theDeal.redeemed == true) {
      let redeemed: UIView = UIView()
      redeemed.frame = CGRectMake(0, 4, cell.contentView.frame.width + 4, 130)
      redeemed.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.8)
      redeemed.clipsToBounds = true
      redeemed.layer.cornerRadius = 10
      cell.contentView.addSubview(redeemed)
      let redeemedLabel: UILabel = UILabel()
      redeemedLabel.frame = CGRectMake(0, 0, cell.contentView.frame.width, 130)
      redeemedLabel.backgroundColor = UIColor(red: 0/255.0, green: 0/255.0, blue: 0/255.0, alpha: 0.0)
      redeemedLabel.font = UIFont(name: "JosefinSans-SemiBold", size: 36.0)
      redeemedLabel.textAlignment = NSTextAlignment.Center
      redeemedLabel.textColor = UIColor(red: (119/255.0), green: (190/255.0), blue: (119/255.0), alpha: 1)
      redeemedLabel.text = "REDEEMED!"
      redeemedLabel.transform = CGAffineTransformMakeRotation(CGFloat(-M_PI_2)*0.25)
      redeemed.addSubview(redeemedLabel)
    }
    
    
    return cell
  }
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.items.count
  }
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
  }
  
  func showCurrentTab() {
    let currentTabView = CurrentTabPopover()
    currentTabView.view.backgroundColor =  UIColor(red: (255.0/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.50)
    currentTabView.modalPresentationStyle = .OverFullScreen
    let popoverPresentationViewController = currentTabView.popoverPresentationController
    popoverPresentationViewController?.sourceView = self.view
    presentViewController(currentTabView, animated: true, completion: nil)
  }
  
  func showBarDetail(avatarImageString: String, locationName: String, avatarImage: UIImage, locationAddress: String, locationId: String) {
    let currentTabView = BarDetailVC()
    currentTabView.avatarString = avatarImageString
    currentTabView.avatarImage = avatarImage
    currentTabView.locationNameText = locationName
    currentTabView.locationAddress = locationAddress
    currentTabView.locationId = locationId
    currentTabView.view.backgroundColor =  UIColor(red: (255.0/255.0), green: (255/255.0), blue: (255/255.0), alpha: 0.70)
    currentTabView.modalPresentationStyle = .OverFullScreen
    let popoverPresentationViewController = currentTabView.popoverPresentationController
    popoverPresentationViewController?.sourceView = self.view
    dispatch_async(dispatch_get_main_queue(), {
      self.presentViewController(currentTabView, animated: false, completion: nil)
    })
    
  }
  
  
  
}

