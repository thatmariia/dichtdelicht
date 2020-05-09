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

class UserIdentifier : ObservableObject  {
    
    @Published var user_id = ""
    @Published var username = ""
    @Published var is_first_login = false
    
    @Published var home_names = [String]()
    
    init() {
        
        let core_user = get_coredata_uuid()
        let is_existing_user = core_user.0
        let user_id = core_user.1
        
        if (!is_existing_user){
            add_user_firebase(with: user_id)
            self.is_first_login = true
        }
        
        listen_user_firebase(with: user_id)
    }
    
    /// listens to user in firebase
    func listen_user_firebase(with user_id: String){
        let collection = Firestore.firestore().collection("users")
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
            self.user_id    = data.get("user_id")    as! String
            self.username   = data.get("username")   as! String
            self.home_names = data.get("home_names") as! [String]
        }
    }
    
    /// adds a new user to firebase
    func add_user_firebase(with user_id: String){
        let collection = Firestore.firestore().collection("users")
        // add user to database
        collection.addDocument(data: ["user_id" :  user_id,
                                      "username" : "meow_username"]) { (err) in
                                        
                                        if (err != nil) {
                                            print("Error: \(err!.localizedDescription)")
                                            return
                                        }
        }
    }
    
    /// fetches a user_id if exists, generates one if doesnt
    func get_coredata_uuid() -> (Bool, String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "UserID", in: context)!
        
        // try to fetch user_id from coredata
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserID")
        request.returnsObjectsAsFaults = false
        
        var coredata = (false, "meow_new_id")
        
        do {
            var result = try context.fetch(request)
            
            if (result.count > 1){
                result = remove_additionals(result: result, context: context)
            }
            
            if (result.count == 1){
                let data = result[0] as! NSManagedObject
                let user_id = data.value(forKey: "user_id")
                coredata = (true, user_id as! String)
                
            } else if (result.count == 0){
                let new_user_id = add_new_user_id(entity: entity, context: context)
                coredata = (false, new_user_id)
            }

        } catch {
            print("coredata fetch failed")
        }
        return coredata
    }
    
    /// adds new user to coredata
    func add_new_user_id(entity: NSEntityDescription?, context: NSManagedObjectContext) -> String{
        let new_user = NSManagedObject(entity: entity!, insertInto: context)
        let new_user_id = UUID().uuidString
        new_user.setValue(new_user_id, forKey: "user_id")
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        return new_user_id
    }
    
    /// removes all users but 1 (first)
    func remove_additionals(result: [Any], context: NSManagedObjectContext) -> [Any]{
        print("more than 1 user in coredata")
        
        for i in 1..<result.count {
            let object = result[i] as! NSManagedObject
            print("--remove")
            context.delete(object)
        }
        do {
            try context.save()
        } catch {
            print("Failed saving")
        }
        
        return result
    }
    
    
    
    
}
