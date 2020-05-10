//
//  HomeSelectionView.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 10/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI
import Firebase


/// View where a user selects it's home
struct HomeSelectionView: View {
    
    @ObservedObject var user : UserIdentifier
    @ObservedObject var user_homes : UserHomesObserver
    
    @State var curr_home_name = ""
    
    @State var home_search_result = HomeSearchResult(is_attempted: false, is_found: false, name: "", is_in_list: false)
    
    var body: some View {
        NavigationView{
            VStack{
                
                find_home()
                
                if (home_search_result.is_in_list) {
                    Text("You already have this home")
                }
                if (home_search_result.is_attempted) {
                    Text("Searching for \(home_search_result.name)")
                    if (home_search_result.is_found) {
                        Text("\(home_search_result.name) has been added to your homes")
                    } else {
                        Text("\(home_search_result.name) is not found")
                    }
                }
                
                Spacer()
                
                home_choose()
                
                Spacer()
                
            }.padding()
        }
    } 
    
    fileprivate func find_home() -> some View {
        return VStack {
            Text("Find a home:")
            TextField("home finder", text: $home_search_result.name, onEditingChanged: { (changed) in
            }) {
                print("Searching for \(self.home_search_result.name)")
                if (self.user_homes.home_names.contains(self.home_search_result.name)) {
                    print("home already in list")
                    self.home_search_result.is_in_list = true
                    return
                }
                if (self.home_search_result.name != ""){
                    self.process_home()
                }
            }
        }
    }
    
    fileprivate func assign_home() {
        if (user.doc_id == ""){ return }
        let user_path = DB.collection("users").document(user.doc_id)
        user_path.updateData([
            "home_names" : FieldValue.arrayUnion([home_search_result.name])
        ])
    }
    
    fileprivate func process_home() {
        let home_query = DB.collection("home").whereField("name", isEqualTo: self.home_search_result.name)
        home_query.addSnapshotListener { (home_snap, home_err) in
            if (home_err != nil) {
                print("Error err: \(home_err!.localizedDescription)")
                return
            }
            if (home_snap!.documents.count > 1){
                print("we've got more than 1 home with name \(self.home_search_result.name)")
                return
            }
            self.home_search_result.is_attempted = true
            print("inside snap home finder")
            
            if (home_snap!.documents.count == 0){
                self.home_search_result.is_found = false
                return
            }
            /// should be len 1
            for _ in home_snap!.documents {
                self.home_search_result.is_found = true
                self.assign_home()
                
            }
        }
    }
    
    fileprivate func home_choose() -> some View {
        print("in home scroll with \(user_homes.home_names.count) homes")
        return VStack {
            Text("Choose a home:")
            if (user.home_names.count == 0){
                Text("You have no homes")
            } else {
                ScrollView(.horizontal, showsIndicators: false){
                    HStack {
                        ForEach(user_homes.home_names, id: \.self) { home_name in
                            ZStack {
                                Button(action: {
                                    self.curr_home_name = home_name
                                }) {
                                    Text(home_name)
                                }
                            }
                        }
                    }
                }
                
                if (curr_home_name != ""){
                    
                    NavigationLink(destination: RoomsManagerView(user_home: self.curr_home_name,
                                                                 user: UserIdentifier(),
                                                                 home: HomeObserver(home_name: self.curr_home_name)).navigationBarTitle("")) {
                           Text("Select")
                    }
                }
            }
        }
    }
}

/*struct HomeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSelectionView(user: UserIdentifier())
    }
}*/
