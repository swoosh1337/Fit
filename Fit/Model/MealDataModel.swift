//
//  MealDataModel.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/10/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class MealDataModel {
  var idMeal: String
  var strMeal: String
  var strMealThumb: String
  
  init(idMeal: String, strMeal: String, strMealThumb: String) {
    self.idMeal = idMeal
    self.strMeal = strMeal
    self.strMealThumb = strMealThumb
  }
}

