//
//  RoomsManager.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI


/// View where a user selects the following:
/// - room(s) to change LEDs in
/// - LEDs to change in selected rooms
/// - method to change the LEDs
struct RoomsManagerView: View {
    
    var user_home : String
    @ObservedObject var user : UserIdentifier
    
    @ObservedObject var home : HomeObserver
    @State var curr_rooms : Room = Room(doc_id: "", name: "", LEDs: [])
    @State var curr_LEDs : [LED] = []
    
    var body: some View {
        NavigationView{
            VStack{
                
                Text("Hi there, " + user.username)
                
                NavigationLink(destination: UserSettingsView(user: user)) {
                    Text("User settings")
                }
                
                Text("Home: " + user_home)
                
                // TODO:: assign some initial values to a room and LED
                // TODO:: make it possible to select multiple rooms and LEDs
                room_choose()
                // TODO:: add an option to add more rooms
                if (curr_rooms.name != ""){
                    LED_choose()
                    // TODO:: add an option to add more LEDs
                    
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
                                                       curr_rooms: curr_rooms,
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
                        self.curr_rooms = room
                    }) {
                        Text(room.name)
                    }
                }
            }
            /// letting choose all rooms
            ZStack {
                Button(action: {
                    self.curr_rooms = self.combine_all_rooms()
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
        
        for led in curr_rooms.LEDs {
            all_LEDs.append(led)
        }
        
        return all_LEDs
    }
    
    fileprivate func LED_stack() -> some View{
        return HStack{
            
            /// letting choose each LED in a selected room
            ForEach(curr_rooms.LEDs, id: \.self) { led in
                
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
            if(curr_rooms.LEDs.count == 0){
                Text("You have no LED strips in \(curr_rooms.name)")
            } else {
                ScrollView(.horizontal, showsIndicators: false){
                    LED_stack()
                }
            }
        }
    }
}


/*struct RoomsManagerView_Previews: PreviewProvider {
    static var previews: some View {
        RoomsManagerView(user_home: <#String#>, user: UserIdentifier(), home: HomeObserver(home_name: "royal_house"))
    }
}*/


