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
    
    @State var home_search_result = HomeSearchResult(is_found: false, name: "", is_in_list: false)
    
    var body: some View {
        NavigationView{
        VStack{
            
            // TODO:: add an option to add more homes
            find_home()
            
            // TODO:: figure out why it doesnt always display homes
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
                if (self.user_homes.home_names.contains(self.home_search_result.name)) {
                    print("home already in list")
                    self.home_search_result.is_in_list = true
                    return
                }
                if (self.home_search_result.name != ""){
                    
                    let homes_collection = Firestore.firestore().collection("home")
                    let home_query = homes_collection.whereField("name", isEqualTo: self.home_search_result.name)
                    home_query.addSnapshotListener { (home_snap, home_err) in
                        if (home_err != nil) {
                            print("Error err: \(home_err!.localizedDescription)")
                            return
                        }
                        if (home_snap!.documents.count > 1){
                            print("we've got more than 1 home with name \(self.home_search_result.name)")
                            return
                        }
                        /// should be len 1
                        for _ in home_snap!.documents {
                            self.home_search_result.is_found = true
                            // TODO:: add the found home to user
                            
                        }
                    }
                    // search for home
                    // add home
                }
            }
        }
        
    }
    
    fileprivate func home_choose() -> some View {
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
