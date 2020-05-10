//
//  UserHomesObserver.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 10/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import Firebase

// TODO:: add change listeners

/// takes a username and fetches all the home names of this user
class UserHomesObserver : ObservableObject {
    @Published var home_names = [String]()
    var user_id = ""
    
    init(user_id: String) {
        self.user_id = user_id
        
        let user_query = DB.collection("users").whereField("user_id", isEqualTo: self.user_id)
        user_query.addSnapshotListener { (snap, err) in
            if (err != nil) {
                print("Error err: \(err!.localizedDescription)")
                return
            }
            
            if (snap!.documents.count > 1){
                print("we've got more than 1 user with user id \(self.user_id)")
            }
            
            /// should be len 1
            for doc in snap!.documents{
                self.home_names = doc.get("home_names") as! [String]
            }
        }
    }
}
