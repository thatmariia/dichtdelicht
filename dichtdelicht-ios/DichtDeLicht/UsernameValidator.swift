//
//  UsernameValidator.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 10/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import Firebase

class UsernameValidator {
    
    var username : String
    
    var user_doc_id : String = ""
    
    @Published var is_attempted = false
    
    @Published var is_valid = false
    @Published var is_unused = false
    
    var is_set = false
    
    init(username: String) {
        self.username = username
    }
    
    func validate(){
        if (self.username.count < 1){
            self.is_valid = false
        }
        for char in self.username {
            if (!ALLOWED_CHARS.contains(char)){
                self.is_valid = false
            }
        }
        self.is_valid = true
    }
    
    func check_usage() {
        let users_query = DB.collection("users").whereField("username", isEqualTo: self.username)
        users_query.addSnapshotListener { (snap, err) in
            if (self.is_set){ return }
            if (err != nil) {
                print("Error err: \(err!.localizedDescription)")
                return
            }
            if (snap!.documents.count > 0){
                print(snap!.documents[0].data())
                self.is_unused = false
            } else {
                self.is_unused = true
                self.set_username_firebase()
                print("SET TRUE")
                self.is_set = true
            }
        }
    }
    
    func set_username_firebase() {
        let user_path = DB.collection("users").document(self.user_doc_id)
        user_path.setData(["username" : self.username], merge: true) { (err) in
            if (err != nil) {
                print("Error err: \(err!.localizedDescription)")
                return
            }
        }
    }
    
    
    
}


