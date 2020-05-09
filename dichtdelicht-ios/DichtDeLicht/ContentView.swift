//
//  ContentView.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var user : UserIdentifier
    
    var body: some View {
        VStack{
            
            if (user.is_first_login){
                // if user logged in for the first time
                // TODO:: go setup the username, and add or search for home & rooms
            } else {
                // TODO:: choose home (view with home choosing if more than 1? or make a default?)
                RoomsManager(user: UserIdentifier())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: UserIdentifier())
    }
}
