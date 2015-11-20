//
//  ReceiptCellView.swift
//  Nomad
//
//  Created by Hayden Davis on 10/12/15.
//

import Foundation
import UIKit

class ReceiptCellView: UITableViewCell {
  
  var backView: UIView = UIView()

  @IBOutlet var avatar: UIImageView!
  @IBOutlet var locationName: UILabel!
  @IBOutlet var dateLabel: UILabel!

  
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    
    backView.layer.cornerRadius = 10
    backView.clipsToBounds = true
    backView.backgroundColor = UIColor.whiteColor()
    backView.frame = CGRectMake(0, 4, self.contentView.frame.width * 0.99, 65)
    self.contentView.addSubview(backView)
    self.contentView.sendSubviewToBack(backView)
  }
  
  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
}