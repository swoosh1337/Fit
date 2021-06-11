//
//  MealTableViewCell.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/10/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class MealTableViewCell: UITableViewCell {
    @IBOutlet weak var imageV: UIImageView!


    @IBOutlet weak var labelV: UILabel!
 
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.labelStyles()
    self.imageStyles()
  }

  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  func setupCell(meal: JSON) {
    labelV.text = meal["strMeal"].stringValue
    imageV.sd_setImage(with: URL(string: meal["strMealThumb"].stringValue))
  }
  
  func imageStyles() {
    imageV.layer.cornerRadius = 10
    imageV.layer.masksToBounds = true
    imageV.contentMode = .scaleAspectFill
  }

  func labelStyles() {
    labelV.numberOfLines = 2
  }
}




