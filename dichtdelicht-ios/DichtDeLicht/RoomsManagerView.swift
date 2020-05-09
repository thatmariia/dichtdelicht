//
//  RoomsManager.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI

struct RoomsManagerView: View {
    
    var user_home = "royal_house" // TODO:: pass this
    @ObservedObject var user : UserIdentifier
    
    @ObservedObject var home : HomeObserver
    @State var curr_room : Room = Room(doc_id: "", name: "", LEDs: [])
    @State var curr_LEDs : [LED] = []
    
    var body: some View {
        NavigationView{
            VStack{
                
                Text("Hi there, " + user.username)
                Text("Home: " + user_home)
                
                // TODO:: assign some initial values to a room and LED
                room_choose()
                if (curr_room.name != ""){
                    LED_choose()
                    
                    if (curr_LEDs.count == 0){
                        Text("Please select a LED strip")
                    } else { goto_ColorWheel() }
                    
                }
                Spacer()
            }.padding()
        }
    }
    
    fileprivate func goto_ColorWheel() -> some View {
        return ZStack{
            NavigationLink(destination: ColorWheelView(home: HomeObserver(home_name: user_home),
                                                       user_home: user_home,
                                                       curr_room: curr_room,
                                                       curr_LEDs: curr_LEDs).navigationBarTitle("")) {
                Text("Color Wheel")}
        }
    }
    
    
    fileprivate func combine_all_rooms() -> Room {
        var all_LEDs : [LED] = []
        
        for room in home.rooms{
            for led in room.LEDs{
                all_LEDs.append(led)
            }
        }
        
        return Room(doc_id: "", name: ALL_ROOMS, LEDs: all_LEDs)
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
                    Text(ALL_ROOMS)
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
                    Text(ALL_LEDS)
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
}


struct RoomsManagerView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsManagerView(user: UserIdentifier(), home: HomeObserver(home_name: "royal_house"))
    }
}


