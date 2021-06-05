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

class NoteTableView: UITableViewController
{
    var firstLoad = true
    
    func nonDeletedNotes() -> [Note]
    {
        var noDeleteNoteList = [Note]()
        for note in noteList
        {
            if(note.deletedDate == nil && noDeleteNoteList.contains(note) == false)
            {
                
                noDeleteNoteList.append(note)
            }
        }
        return noDeleteNoteList
    }
    
    override func viewDidLoad()
    {
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
                    noteList.append(note)
             
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
//        tableView.reloadData()
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

