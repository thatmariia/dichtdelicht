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
                UserSettingsView(user: UserIdentifier())
            } else {
                HomeSelectionView(user: user,
                                  user_homes: UserHomesObserver(user_id: user.user_id))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: UserIdentifier())
    }
}
