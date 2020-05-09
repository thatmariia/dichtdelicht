//
//  DeviceIdentifier.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreData

class UserIdentifier : ObservableObject {
    
    @Published var user = User()
    
    init() {
        
        let collection = Firestore.firestore().collection("users")
        
        let core_user = get_coredata_uuid()
        let is_existing_user = core_user.0
        let user_id = core_user.1
        
        if (!is_existing_user){
            // add user to database
            collection.addDocument(data: ["user_id" :  user_id,
                                          "username" : "meow_username"]) { (err) in
                                            
                                            if (err != nil) {
                                                print("Error: \(err!.localizedDescription)")
                                                return
                                            }
            }
        }
        
        let user = collection.whereField("user_id", isEqualTo: user_id)
        
        user.addSnapshotListener { (snap, err) in
            if (err != nil) {
                print("Error: \(err!.localizedDescription)")
                return
            }
            if (snap!.count > 1){
                print("more than 1 user with the same uuid")
                return
            }
            let data = snap!.documents[0]
            self.user = User(user_id  : data.get("user_id")  as! String,
                             username : data.get("username") as! String)
            
        }
        
        
    }
    
    func get_coredata_uuid() -> (Bool, String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        let new_user = NSManagedObject(entity: entity!, insertInto: context)
        
        // try to fetch user_id from coredata
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for res in result as! [NSManagedObject] {
                if (result.count > 1){
                    print("more than 1 user in coredata")
                } else {
                    let user_id = res.value(forKey: "user_id") as! String
                    return (true, user_id)
                }
            }
        } catch {
            // add new user to coredata
            let new_user_id = UUID().uuidString
            new_user.setValue(new_user_id, forKey: "user_id")
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
            return (false, new_user_id)
        }
        print("ended do-catch")
        return (false, "meow_uuid")
    }
    
    
}
