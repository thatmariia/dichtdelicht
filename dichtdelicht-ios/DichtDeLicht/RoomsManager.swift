//
//  RoomsManager.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI
import ColorPicker

struct RoomsManager: View {
    
    var user_home = "royal_house"
    @ObservedObject var user : UserIdentifier
    @State var color = UIColor.red
    
    var body: some View {
        VStack{
            //Text(user.user.user_id)
            Text("Hi there, " + user.username)
            
            Spacer()
            
            ColorPicker(color: $color, strokeWidth: 30)
                .frame(width: 300, height: 300, alignment: .center)
            Text("\(color.rgba.red), \(color.rgba.green), \(color.rgba.blue), \(color.rgba.alpha)")
        }
    }
}

struct RoomsManager_Previews: PreviewProvider {
    static var previews: some View {
        RoomsManager(user: UserIdentifier())
    }
}
