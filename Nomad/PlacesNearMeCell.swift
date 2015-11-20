//
//  PlacesNearMeCell.swift
//  Nomad
//
//  Created by Hayden Davis on 10/7/15.
//

import Foundation
import UIKit

class PlacesNearMeCell: UITableViewCell {
  
  var backView: UIView = UIView()
  
  @IBOutlet var avatar: UIImageView!
  @IBOutlet var locationName: UILabel!
   var currentTabCount: UILabel = UILabel()
  @IBOutlet var rightBoxView: UILabel!

  @IBOutlet var rightBottomBoxView: UILabel!
  @IBOutlet var rightTopBoxView: UILabel!
  var line: UIView = UIView()

  
  override func awakeFromNib() {
    super.awakeFromNib()
    contentView.clipsToBounds = true
    contentView.addSubview(currentTabCount)
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
}