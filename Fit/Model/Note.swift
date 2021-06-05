//
//  Note.swift
//  Fit
//
//  Created by Irakli Grigolia on 5/29/21.
//  Copyright © 2021 Beka Japaridze. All rights reserved.
//

import CoreData

@objc(Note)
class Note: NSManagedObject
{
    @NSManaged var id: NSNumber!
    @NSManaged var title: String!
    @NSManaged var desc: String!
    @NSManaged var deletedDate: Date?
}

