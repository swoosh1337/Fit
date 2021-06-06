//
//  NoteTableView.swift
//  Fit
//
//  Created by Irakli Grigolia on 5/29/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import UIKit
import CoreData

var noteList = [Note]()
var Legs = [Note]()
var Biceps = [Note]()
var Triceps = [Note]()
var Shoulders = [Note]()
var Back = [Note]()
var Chest = [Note]()



class NoteTableView: UITableViewController

{
    var name = ""

    
    
    var firstLoad = true
    
    func nonDeletedNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        var noDeleteBackList = [Note]()
        var noDeleteBicepsList = [Note]()
        var noDeleteTricepsList = [Note]()
        var noDeleteChestList = [Note]()
        var noDeleteShouldersList = [Note]()
        var noDeleteLegsList = [Note]()
        for note in Legs
        {
//            if(note.deletedDate == nil && noDeleteNoteList.contains(note) == false)
//            {
//                noDeleteNoteList.append(note)}
                
                if (note.deletedDate == nil && name == "Legs" && noDeleteLegsList.contains(note) == false){
                    noDeleteLegsList.append(note)
                 
                
                }
        }
        
        for note in Biceps{
                if (note.deletedDate == nil && name == "Biceps" && noDeleteBicepsList.contains(note) == false){
                    print("biceepss")
                    noDeleteBicepsList.append(note)
                    
                } }
            
        for note in Triceps {

                if (note.deletedDate == nil && name == "Triceps" && noDeleteTricepsList.contains(note) == false){
                    noDeleteTricepsList.append(note)
                   
                } }
        
        for note in Back {
            
                
                if (note.deletedDate == nil && name == "Back" && noDeleteBackList.contains(note)) == false{
                    noDeleteBackList.append(note)
                } }
        for note in Shoulders {
            
                
                if (note.deletedDate == nil && name == "Shoulders" && noDeleteShouldersList.contains(note) == false){
                    noDeleteShouldersList.append(note)
                   
                }
        }
                
        for note in Chest {
            
                if (note.deletedDate == nil && name == "Chest" && noDeleteChestList.contains(note) == false) {
                    noDeleteChestList.append(note)
                }
                }
                
            
        
        
        
        
        if (name == "Legs" ){
         
            return noDeleteLegsList
        
        }
        if (name == "Biceps"){

           
            return noDeleteBicepsList
        }
        
        if (name == "Triceps"){
            
            return noDeleteTricepsList
        }
        
        if name == "Back" {
         
            return noDeleteBackList
        }
        
        if (name == "Shoulders"){
         
            return noDeleteShouldersList
        }
        
        if (name == "Chest") {
           
            return noDeleteChestList
        }
        else{
            print("aqa varr")
            return noDeleteNoteList
        }
       
        
    }
    
    override func viewDidLoad()
    

    {
        print(name,"eee")
        
        if(firstLoad)
        {
            firstLoad = false
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context: NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
            do {
                let results:NSArray = try context.fetch(request) as NSArray
                for result in results
                {
                    let note = result as! Note

                   

                    if note.title.lowercased().contains("leg"){
                      
                        Legs.append(note)
                    }
                    
                    if note.title.lowercased().contains("biceps"){
                        Biceps.append(note)
                    }
                    
                    if note.title.lowercased().contains("triceps") {
                        Triceps.append(note)
                    }
                    if note.title.lowercased().contains("chest") {
                        Chest.append(note)
                    }
                    if note.title.lowercased().contains("shoulder") {
                        Shoulders.append(note)
                    }
                    if note.title.lowercased().contains("back") {
                        Back.append(note)
                    }
             
                }
            }
            catch
            {
                print("Fetch Failed")
            }
        }
    }
    
    
    
   
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let noteCell = tableView.dequeueReusableCell(withIdentifier: "NoteCellID", for: indexPath) as! NoteCell
        
        let thisNote: Note!
        
        
        thisNote = nonDeletedNotes()[indexPath.row]
        
        noteCell.titleLabel.text = thisNote.title
        noteCell.descLabel.text = thisNote.desc
   
        return noteCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return nonDeletedNotes().count
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
       
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "editNote", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        
        if segue.destination is NoteDetailVC {
            let vc = segue.destination as! NoteDetailVC
            vc.name1 = name
        }
        if(segue.identifier == "editNote")
        {
            let indexPath = tableView.indexPathForSelectedRow!
            
            let noteDetail = segue.destination as? NoteDetailVC
            
            let selectedNote : Note!
            selectedNote = nonDeletedNotes()[indexPath.row]
            noteDetail!.selectedNote = selectedNote
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    
    
    
}

