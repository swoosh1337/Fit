//
//  RoundButton.swift
//  AudioJournalApp
//
//  Created by David Robie on 7/16/20.
//  Copyright © 2020 AJOMQP. All rights reserved.
//

import UIKit

@IBDesignable
class RoundButton: UIButton {

    //Variable to assign a URL to the button
    //Used when a view controller needs to load data from an API endpoint after a segue
    var url: URL?

    //Overrides the intrinsic content size of the button to fit the size of the text it contains
    //This is automatically applied when a button is created
    override var intrinsicContentSize: CGSize {
        //Computes the size of a box that fits the text in the title label with a fixed width and variable height
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width - titleEdgeInsets.left - titleEdgeInsets.right, height: .greatestFiniteMagnitude)) ?? .zero
              //Computes the desired height of the button based on the labelSize, insets, corner radius, and minHeight.
              var desiredHeight = labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom + self.layer.cornerRadius/2
                  if(desiredHeight < minHeight)
                  {
                    desiredHeight = minHeight
                  }
              //Final size of the button
              let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: desiredHeight)
             return desiredButtonSize

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.preferredMaxLayoutWidth = self.titleLabel!.frame.size.width
    }
    
    //Attribute that sets the radius of the rounded corners of the button
    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }
    
    //Attribute that sets the width of the border surrounding the button
    @IBInspectable var borderWidth: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }
    
    //Attribute for the minimum height of the button
    //Default value is 50 to conform to accessibility guidelines.
    @IBInspectable var minHeight: CGFloat = 50 {
          didSet{
              
          }
      }

    //Attribute that sets the color of the button's border
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor
            
        }
    }
    
   
}
