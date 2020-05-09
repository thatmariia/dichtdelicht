//
//  ContentView.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI
import ColorKit

struct ContentView: View {
    
    @ObservedObject var user : UserIdentifier
    
    var body: some View {
        VStack{
            //Text(user.user.user_id)
            Text("Hi there, " + user.user.username)
            
            Spacer()
            
            ColorWheel(color: .constant(ColorToken(hue: 0.3, saturation: 1, brightness: 0.6)))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(user: UserIdentifier())
    }
}
