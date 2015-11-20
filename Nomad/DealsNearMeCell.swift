//
//  DealsNearMeCell.swift
//  Nomad
//
//  Created by Hayden Davis on 11/3/15.
//  Copyright © 2015 Tether. All rights reserved.
//


import Foundation
import UIKit

class DealsNearMeCell: UITableViewCell {
  
  var backView: UIView = UIView()
  
  @IBOutlet var avatar: UIImageView!
  @IBOutlet var locationName: UILabel!
  @IBOutlet var dealMessage: UITextView!
 //  var avatar: UIImageView!
 //  var locationName: UILabel!
  var line: UIView = UIView()
  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.clipsToBounds = true
  
   
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}