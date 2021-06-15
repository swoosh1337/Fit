//
//  ViewControllerTableViewCell.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/14/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    @IBOutlet weak var textweight: UILabel!
    @IBOutlet weak var textdate: UILabel!
    @IBOutlet weak var textemoji: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

