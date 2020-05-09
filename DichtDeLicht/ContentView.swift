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
            //Text(user.user.user_id)
            Text("Hi there, " + user.user.username)
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: UserIdentifier())
    }
}
