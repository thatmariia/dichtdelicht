//
//  UserHomesObserver.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 10/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import Firebase

class UserHomesObserver : ObservableObject {
    @Published var home_names = [String]()
    var username = ""
    
    init(username: String) {
        self.username = username
        
        let user_query = Firestore.firestore().collection("users").whereField("username", isEqualTo: self.username)
        user_query.addSnapshotListener { (snap, err) in
            if (err != nil) {
                print("Error err: \(err!.localizedDescription)")
                return
            }
            
            if (snap!.documents.count > 1){
                print("we've got more than 1 user with the same username")
            }
            
            /// should be len 1
            for doc in snap!.documents{
                self.home_names = doc.get("home_names") as! [String]
            }
        }
    }
}
