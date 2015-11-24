//
//  PlacesNearMeVC.swift
//  Nomad
//
//  Created by Hayden Davis on 10/5/15.
//

import UIKit
import CoreLocation

class PlacesNearMeVC: UIViewController, CLLocationManagerDelegate, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate {
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
  
  ///////
  var refreshControl = UIRefreshControl()

  
  override func viewDidLoad() {
    super.viewDidLoad()
    findMyLocation()
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
    self.view.addSubview(locationLabel)
    
    //tableview
    let frame:CGRect = CGRect(x: 10, y: 114, width: self.view.frame.width - 20, height: self.view.frame.height-160)
    self.tableView = UITableView(frame: frame)
    self.tableView?.dataSource = self
    self.tableView?.delegate = self
    self.tableView.backgroundColor = UIColor.whiteColor()
    self.view.addSubview(self.tableView!)
    let nib = UINib(nibName: "PlacesNearMeCell", bundle: nil)
    tableView.registerNib(nib, forCellReuseIdentifier: "PlacesNearMeCell")
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
    self.tableView.addSubview(loader)
    
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
    
    
    refreshControl.addTarget(self, action: "pulledRefresh", forControlEvents: UIControlEvents.ValueChanged)
    self.refreshControl.attributedTitle = NSAttributedString(string: "Finding more places...", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont(name: "JosefinSans-SemiBold",  size: 20)!])
    let tableViewController = UITableViewController()
    tableViewController.tableView = self.tableView
    tableViewController.refreshControl = self.refreshControl
  }
  
  func pulledRefresh() {
    print("Pulled Refresh")
    self.locationService.getLocations(currentLat, myLong: currentLong, completionHandler: self.locationsRetrieved, errorHandler: {(error) in
      print(error);
    })
    if(currentLong != 0.0 && currentLong != 0.0) {
      self.locationService.check300(String(currentLat), long: String(currentLong), authToken: Keychain.get("nomadAuthToken") as! String, completionHandler: { json in
        print("success")
        }, errorHandler: { error in
          // handle the error
          print(error);
      });
    }
    self.refreshControl.endRefreshing()

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

    self.navigationController?.navigationBar.topItem?.title = "Places Near Me"
    self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "JosefinSans-SemiBold",  size: 24)!,  NSForegroundColorAttributeName: UIColor.whiteColor()]
    locationService.getLocations(currentLat, myLong: currentLong, completionHandler: locationsRetrieved, errorHandler: {(error) in
      print(error);
    })

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
    var cell: PlacesNearMeCell = tableView.cellForRowAtIndexPath(indexPath) as! PlacesNearMeCell
    var theLocation: Location = items[indexPath.row] as! Location
    var imageString = theLocation.avatarUrl
    var locationNameString = theLocation.name//items[indexPath.row]//fakePlaces[indexPath.row]
    var locationId = theLocation.locationId
    showBarDetail(imageString!, locationName: locationNameString!, avatarImage: theLocation.avatarImage!, locationAddress: theLocation.address!, locationId: theLocation.locationId!)
   
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("PlacesNearMeCell", forIndexPath: indexPath) as! PlacesNearMeCell
    let theLocation: Location = items[indexPath.row] as! Location
    cell.locationName.text = theLocation.name
    cell.backgroundColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.avatar.clipsToBounds = true
    cell.avatar.layer.cornerRadius = 10
    cell.avatar.image = theLocation.avatarImage
    cell.rightBoxView.backgroundColor = UIColor.whiteColor()
    cell.selectionStyle = UITableViewCellSelectionStyle.None
    let rightBox: UIView = UIView()
    rightBox.layer.borderColor = UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1).CGColor
    rightBox.layer.borderWidth = 2.0
    rightBox.clipsToBounds = true
    rightBox.layer.cornerRadius = 10
    rightBox.frame = CGRectMake(cell.contentView.frame.width * (5/6), 8, 55 , 55)
    rightBox.backgroundColor = UIColor.whiteColor()
    cell.contentView.addSubview(rightBox)
    let topSeperator: UIView = UIView()
    topSeperator.frame = CGRect(x: 0, y: cell.contentView.frame.size.height - 4.0, width: cell.contentView.frame.size.width, height: 4)
    topSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.contentView.addSubview(topSeperator)
    let bottomSeperator: UIView = UIView()
    bottomSeperator.frame = CGRect(x: 0, y: 0, width: cell.contentView.frame.size.width, height: 4)
    bottomSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    cell.contentView.addSubview(bottomSeperator)
    
    let backView: UIView = UIView()
    backView.frame = CGRectMake(0, 4, cell.contentView.frame.width, 65)
    backView.layer.cornerRadius = 10
    backView.clipsToBounds = false
    backView.backgroundColor = UIColor.whiteColor()
    let line: UIView = UIView()
    line.frame = CGRectMake(cell.contentView.frame.width * 0.895, 0, 2, cell.contentView.frame.height)
    line.center.x = rightBox.center.x
    line.backgroundColor = UIColor.blackColor()
    cell.contentView.addSubview(line)
    cell.contentView.sendSubviewToBack(line)
    cell.contentView.addSubview(backView)
    cell.contentView.sendSubviewToBack(backView)
    let tabsOpenTitle: UILabel = UILabel()
    tabsOpenTitle.frame = CGRectMake(cell.contentView.frame.width * (5/6) + 3, 15, 55, 20)
    tabsOpenTitle.text = "Tabs Open"
    tabsOpenTitle.font = UIFont(name: "JosefinSans-SemiBold", size: 11.0)
    cell.addSubview(tabsOpenTitle)
    
    cell.currentTabCount.frame = CGRectMake(self.tableView.frame.width * (5/6), 35, 55, 20)
    cell.currentTabCount.text = String(Int(theLocation.tabCount))
    cell.currentTabCount.textAlignment = NSTextAlignment.Center
    cell.currentTabCount.font = UIFont(name: "JosefinSans-SemiBold", size: 22.0)
    cell.contentView.bringSubviewToFront(cell.currentTabCount)
    
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