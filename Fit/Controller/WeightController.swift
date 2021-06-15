//
//  WeightController.swift
//  Fit
//
//  Created by Irakli Grigolia on 6/14/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit

class WeightController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    var weights : [Weight] = []
    



    override func viewDidLoad() {
        super.viewDidLoad()

            
               tableView.delegate = self
               tableView.dataSource = self
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "addweight") as! AddWeightViewController
        self.navigationController?.pushViewController(secondViewController, animated: false)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // get data from core data
        getData()
        
        // reload tableview
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        print(weights.count, "amdeniaaa?")
        
        return weights.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //showing latest first
        let weight = weights[weights.count - (indexPath.row+1)]
        
        let weightTrue = String(round(Double((weight.currentweight!))! * 10)/10)
        cell.textweight.text = weightTrue + " Kg"
        cell.textdate.text = weight.datestamp
        cell.textemoji.text = allocateEmoji(DayTime: weight.daytime!)
        

        
        return cell
        
    }
    
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            weights = try context.fetch(Weight.fetchRequest())
        }
        catch{
            print ("Fetching Error")
        }
    }
    
    func allocateEmoji(DayTime day:String) -> String {
        
        if day == "Morning" { return "☀️"}
        else if day == "Noon" { return "🌤"}
        else { return "🌙"}
        
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        if editingStyle == .delete {
            let weight = weights[weights.count - (indexPath.row+1)]
            context.delete(weight)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            do {
                weights = try context.fetch(Weight.fetchRequest())
            }
            catch{
                print("Fetching error")
            }
            
            tableView.reloadData()
            
        }
    }

    
    
}


