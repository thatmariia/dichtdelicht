//
//  HomeSelectionView.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 10/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI


/// View where a user selects it's home
struct HomeSelectionView: View {
    
    @ObservedObject var user : UserIdentifier
    @ObservedObject var user_homes : UserHomesObserver
    
    @State var curr_home_name = ""
    
    var body: some View {
        NavigationView{
        VStack{
            
            // TODO:: figure out why it doesnt always display homes
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
            
            // TODO:: add an option to add more homes
        }.padding()
        }
    }
}

/*struct HomeSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        HomeSelectionView(user: UserIdentifier())
    }
}*/
