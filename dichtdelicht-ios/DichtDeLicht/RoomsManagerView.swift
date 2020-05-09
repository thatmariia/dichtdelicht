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
    @State var curr_LEDs : [LED] = []
    
    @State var color = UIColor.red
    
    fileprivate func combine_all_rooms() -> Room {
        var all_LEDs : [LED] = []
        
        for room in home.rooms{
            for led in room.LEDs{
                all_LEDs.append(led)
            }
        }
        
        return Room(name: "All rooms", LEDs: all_LEDs)
    }
    
    fileprivate func rooms_stack() -> some View {
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
                    Text("All rooms")
                }
            }
        }
    }
    
    fileprivate func room_choose() -> some View {
        return VStack{
            Text("Choose a room:")
            if (home.rooms.count == 0){
                Text("You have no rooms")
            } else {
                ScrollView(.horizontal, showsIndicators: false){
                    rooms_stack()
                }
            }
        }
    }

    
    fileprivate func combine_all_LEDs() -> [LED] {
        var all_LEDs : [LED] = []
        
        for led in curr_room.LEDs {
            all_LEDs.append(led)
        }
        
        return all_LEDs
    }
    
    fileprivate func LED_stack() -> some View{
        return HStack{
            
            /// letting choose each LED in a selected room
            ForEach(curr_room.LEDs, id: \.self) { led in
                
                ZStack {
                    Button(action: {
                        self.curr_LEDs = [led]
                    }) {
                        Text(led.name)
                    }
                }
                
            }
            
            /// letting choose all LEDs
            ZStack {
                Button(action: {
                    self.curr_LEDs = self.combine_all_LEDs()
                }) {
                    Text("All LEDs")
                }
            }
        }
    }
    
    fileprivate func LED_choose() -> some View {
        return VStack{
            Text("Choose a LED strip:")
            if(curr_room.LEDs.count == 0){
                Text("You have no LED strips in \(curr_room.name)")
            } else {
                ScrollView(.horizontal, showsIndicators: false){
                    LED_stack()
                }
            }
        }
    }
    
    var body: some View {
        VStack{

            Text("Hi there, " + user.username)
            Text("Home: " + user_home)
            
            Spacer()
            
            // TODO:: assign some initial values to a room and LED
            room_choose()
            
            if (curr_room.name != ""){
                LED_choose()
            }

            Text("curr room = " + curr_room.name)
            Text("leds = " +  "\(curr_LEDs)")
            
            VStack{
                ColorPicker(color: $color, strokeWidth: 30)
                    .frame(width: 300, height: 300, alignment: .center)
                Text("\(color.rgba.red), \(color.rgba.green), \(color.rgba.blue), \(color.rgba.alpha)")
            }
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


