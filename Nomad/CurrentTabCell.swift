//
//  CurrentTabCell.swift
//  Nomad
//
//  Created by Hayden Davis on 10/7/15.
//

import Foundation
import UIKit

class CurrentTabCell: UITableViewCell {
  
  
  @IBOutlet var quantity: UILabel!
  @IBOutlet var itemName: UILabel!
  @IBOutlet var total: UILabel!
  let topSeperator: UIView = UIView()

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code

   // topSeperator.frame = CGRect(x: 10, y: 0, width: contentView.frame.size.width, height: 2)
    //topSeperator.backgroundColor =  UIColor(red: (40.0/255.0), green: (48/255.0), blue: (57/255.0), alpha: 1)
    //contentView.addSubview(topSeperator)
    
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}