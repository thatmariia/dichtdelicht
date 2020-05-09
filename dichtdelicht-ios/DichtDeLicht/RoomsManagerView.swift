//
//  RoomsManager.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI
import ColorPicker

struct RoomsManagerView: View {
    
    var user_home = "royal_house" // TODO:: pass this
    @ObservedObject var user : UserIdentifier
    
    @ObservedObject var home : HomeObserver
    @State var curr_room : Room = Room(name: "", LEDs: [])
    
    @State var color = UIColor.red
    
    fileprivate func combine_all_rooms() -> Room {
        var all_LEDs : [LED] = []
        
        for room in home.rooms{
            for led in room.LEDs{
                all_LEDs.append(led)
            }
        }
        
        return Room(name: "All", LEDs: all_LEDs)
    }
    
    fileprivate func room_choose() -> some View{
        return HStack {
            
            /// letting choose each room of the home
            ForEach(home.rooms, id: \.self) { room in
                
                ZStack {
                    Button(action: {
                        self.curr_room = room
                    }) {
                        Text(room.name)
                    }
                }
            }
            /// letting choose all rooms
            ZStack {
                Button(action: {
                    self.curr_room = self.combine_all_rooms()
                }) {
                    Text("All")
                }
            }
        }
    }
    
    var body: some View {
        VStack{
            //Text(user.user.user_id)
            Text("Hi there, " + user.username)
            Text("Home: " + user_home)
            Text("Rooms: " + array_to_string(array: get_room_names()))
            
            Spacer()
            
            Text("Choose a room:")
            if (get_room_names().count == 0){
                Text("You have no rooms")
            } else {
                ScrollView(.horizontal, showsIndicators: false){
                    room_choose()
                }
            }
            
            Text("Choose a LED strip:")
            //TODO:: choose led
            
            Text("curr room = " + curr_room.name)
            Text("leds = " +  "\(curr_room.LEDs)")
            
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

struct RoomsManagerView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsManagerView(user: UserIdentifier(), home: HomeObserver(home_name: "royal_house"))
    }
}


