//
//  SearchViewController.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/10/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension UITableView {
  
  func setEmptyView(title: String, message: String) {
    let emptyView = UIView(frame: CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height))
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    messageLabel.translatesAutoresizingMaskIntoConstraints = false
    
    titleLabel.textColor = UIColor.black
    messageLabel.textColor = UIColor.green
    
    emptyView.addSubview(titleLabel)
    emptyView.addSubview(messageLabel)
    
    titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    
    messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
    messageLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
    
    
    titleLabel.text = title
    messageLabel.text = message
    
    self.backgroundView = emptyView
    self.separatorStyle = .none
  }
  
  func restore() {
    self.backgroundView = nil
    self.separatorStyle = .singleLine
  }
}

class SearchController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
  
    //MARK: Constant
  let MEAL_SEARCH_URL = "https://www.themealdb.com/api/json/v1/1/search.php"
  let params: [String: String] = ["s": "Dessert"]
  
  var dataSearchMeal: JSON = []
    
    override func viewDidLoad() {
    super.viewDidLoad()
    
    searchBar.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
               
               // (optional) include this line if you want to remove the extra empty cell divider lines
               // self.tableView.tableFooterView = UIView()

               // This view controller itself will provide the delegate methods and row data for the table view.
               tableView.delegate = self
               tableView.dataSource = self
  }
  
  //MARK: Networking
  func searchMeal(url: String, parameters: [String: String]) {
    Alamofire.request(url, method: .get, parameters: parameters).responseJSON { (response) in
      if response.result.isSuccess {
        let dataMeal: JSON = JSON(response.result.value!)
        
        self.dataSearchMeal = dataMeal["meals"]
      } else {
        print("Error: \(response.error!)")
      }
    }
  }
   
    
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    self.searchMeal(url: MEAL_SEARCH_URL, parameters: ["s": searchText])
    
    tableView.reloadData()
  }
  
  //MARK: TableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if dataSearchMeal.count == 0 {
      tableView.setEmptyView(title: "Not Found", message: "Data Not found")
    } else {
      tableView.restore()
    }
    
    return dataSearchMeal.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell2", for: indexPath) as UITableViewCell
    
    cell.textLabel?.text = dataSearchMeal[indexPath.row]["strMeal"].stringValue
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    let destinationVC = storyBoard.instantiateViewController(withIdentifier: "MEAL_DETAIL") as! MealDetailViewController
    let dataMeal = dataSearchMeal[indexPath.row]
    
    destinationVC.idMeal = dataMeal["idMeal"].stringValue
    destinationVC.strMealThumb = dataMeal["strMealThumb"].stringValue
    destinationVC.strMeal = dataMeal["strMeal"].stringValue
    
    navigateToMealDetail(destination: destinationVC)
  }
  
  //MARK: Navigate to MealDetail
  func navigateToMealDetail(destination: MealDetailViewController) {
    navigationController?.show(destination, sender: nil)
  }
}
