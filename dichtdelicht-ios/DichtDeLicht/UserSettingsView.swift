//
//  UserSettingsView.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 10/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI
import Firebase

struct UserSettingsView: View {
    
    @ObservedObject var user : UserIdentifier
    
    @State var new_username = UsernameValidator(username: "")
    
    var body: some View {
        let username_placeholder = (user.is_first_login) ? "username" : user.username
        return VStack{
            Text("Please enter new username")
            
            TextField(username_placeholder, text: $new_username.username, onEditingChanged: { (changed) in
            }) {
                print(self.new_username.username)
                self.new_username.is_attempted = true
                self.new_username.user_doc_id = self.user.doc_id
                
                self.new_username.validate()
                self.new_username.check_usage()
                
                /*if (self.new_username.is_valid && self.new_username.is_unused) {
                    self.new_username.set_username_firebase()
                }*/
            }
            
            if (new_username.is_attempted && !new_username.is_valid){
                Text("The username is invalid")
            }
            if (new_username.is_attempted && !new_username.is_unused){
                Text("The username is already in use")
            }
            
            Spacer()
        }
    }
    
    
}

/*struct UserSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingsView()
    }
}*/
