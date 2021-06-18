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
    var avg : [Avg] = []
    var sum: Float = 0.0
    var average: Float = 0.0
    



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

  
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
        
        //showing latest first
        let weight = weights[weights.count - (indexPath.row+1)]
        print(avg.count," <==== avg ")
        if avg.count > 0{
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

            
            let aver = avg[avg.count - (indexPath.row+1)].avg
            for e in 1...7{
                
              
                    let a = avg[0]
                    context.delete(a)
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
              
            }
             
            cell.textweight.text = String(describing: aver) + " Kg"
            cell.textdate.text = weight.datestamp
            print("return avg cell")
          
            return cell
        }
        
        let weightTrue = String(round(Double((weight.currentweight!))! * 10)/10)
        cell.textweight.text = weightTrue + " Kg"
        cell.textdate.text = weight.datestamp

        
        print("return weight cell")
        
        return cell
        
    }
    
    
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            weights = try context.fetch(Weight.fetchRequest())
            avg = try context.fetch(Avg.fetchRequest())
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(weights.count,"<===weights")
    
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if(weights.count == 7){
            
            
            for i in 0...(weights.count-1){
                
          
                self.sum += Float(weights[i].currentweight!)!

            }
            
            for i in 0...(weights.count-1){
                let weight = weights[i]
                context.delete(weight)
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                
            }
            
//            for e in 1...7{
                
    
                if self.sum != 0.0 {
                average = sum/Float(weights.count)
               
                let a = Avg(context: context)
                
                a.avg = average
                self.sum = 0
                
                // Save to core data
                (UIApplication.shared.delegate as! AppDelegate).saveContext()
                 

                do {
                    weights = try context.fetch(Weight.fetchRequest())
                    avg = try context.fetch(Avg.fetchRequest())
                }
                catch{
                    print("Fetching error")
                }
                    
                   
                tableView.reloadData()

                }
//            }
        }
        
        
        return weights.count
        
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


extension Float {
    
    func afficherUnFloat() -> String {
        let text : NSNumber = self as NSNumber
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .current
        numberFormatter.groupingSeparator = ""
        numberFormatter.maximumFractionDigits = 2 // your choice
        numberFormatter.maximumIntegerDigits = 6 // your choice

        let result = numberFormatter.string(from: text) ?? ""
            return result
    }
    
}
