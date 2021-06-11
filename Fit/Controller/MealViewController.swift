//
//  MealViewController.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/10/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class MealViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  //MARK: Constant
  let MEAL_URL = "https://www.themealdb.com/api/json/v1/1/filter.php"
  let params: [String: String] = ["c": "Seafood"]
  
  var dataListMeal: JSON = []
  
    @IBOutlet weak var tableV : UITableView!
  //MARK: IBOutlet

    override func viewDidLoad() {
    super.viewDidLoad()
        tableV.tableFooterView = UIView()
        tableV.rowHeight = 200
  }
  
  override func viewWillAppear(_ animated: Bool) {
    getListMeal(url: MEAL_URL, parameters: params)
  }
  
  //MARK: Networking
  func getListMeal(url: String, parameters: [String: String]) {
    Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
      if response.result.isSuccess {
        let dataMeal: JSON = JSON(response.result.value!)
        self.updateDataMeal(json: dataMeal)
      } else {
        print("Error: \(response.error!)")
      }
    }
  }
  
  func updateDataMeal(json: JSON) {
    dataListMeal = json["meals"]
    print(dataListMeal,"aeee")
    tableV.reloadData()
  }
  
  //MARK: TableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataListMeal.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell1", for: indexPath) as! MealTableViewCell
    let listMeal = dataListMeal[indexPath.row]
    print("sukkaaaa")
  
    cell.setupCell(meal: listMeal)
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let destinationVC = storyBoard.instantiateViewController(withIdentifier: "MEAL_DETAIL") as! MealDetailViewController
    let dataMeal = dataListMeal[indexPath.row]
    
    destinationVC.idMeal = dataMeal["idMeal"].stringValue
    destinationVC.strMealThumb = dataMeal["strMealThumb"].stringValue
    destinationVC.strMeal = dataMeal["strMeal"].stringValue
    
    navigateToMealDetail(destination: destinationVC)
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return UIView()
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Food Recipe Today"
  }
  
  //MARK: Navigate to MealDetail
  func navigateToMealDetail(destination: MealDetailViewController) {
    navigationController?.show(destination, sender: nil)
  }
}

