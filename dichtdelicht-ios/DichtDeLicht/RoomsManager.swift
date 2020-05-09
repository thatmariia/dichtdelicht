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
    
    var user_home = "royal_house" // TODO:: pass this
    @ObservedObject var user : UserIdentifier
    
    
    
    @ObservedObject var home : HomeObserver
    @State var color = UIColor.red
    
    var body: some View {
        VStack{
            //Text(user.user.user_id)
            Text("Hi there, " + user.username)
            Text("Home: " + user_home)
            Text("Rooms: " + array_to_string(array: get_room_names()))
            
            Spacer()
            
            ColorPicker(color: $color, strokeWidth: 30)
                .frame(width: 300, height: 300, alignment: .center)
            Text("\(color.rgba.red), \(color.rgba.green), \(color.rgba.blue), \(color.rgba.alpha)")
        }
    }
    
    func get_room_names() -> [String]{
        var room_names : [String] = []
        
        for room in home.rooms {
            room_names.append(room.name)
        }
        return room_names
    }
}

struct RoomsManager_Previews: PreviewProvider {
    static var previews: some View {
        RoomsManager(user: UserIdentifier(), home: HomeObserver(home_name: "royal_house"))
    }
}


