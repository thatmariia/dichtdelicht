//
//  HomeObserver.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import Firebase

class HomeObserver : ObservableObject {
    @Published var rooms = [Room]()
    var home_name: String = "royal_house"
    
    init(home_name: String) {
        self.home_name = home_name
        
        let homes = Firestore.firestore().collection("home")
        
        let home_query = homes.whereField("name", isEqualTo: home_name)
        home_query.addSnapshotListener { (home_snap, home_err) in
            if (home_err != nil) {
                print("Error home_err: \(home_err!.localizedDescription)")
                return
            }
            
            self.rooms = []

            /// go through home (should only be snap of len 1)
            for doc in home_snap!.documents {
                
                let rooms = homes.document(doc.documentID).collection("rooms")
                rooms.getDocuments { (rooms_snap, rooms_err) in
                    if (rooms_err != nil) {
                        print("Error rooms_err: \(rooms_err!.localizedDescription)")
                        return
                    }
                    
                    /// go though rooms in a home
                    for room in rooms_snap!.documents{
                        let room_name = room.get("name") as! String
                        var room_LEDs : [LED] = []
                        
                        let LEDs = rooms.document(room.documentID).collection("LED")
                        LEDs.getDocuments { (LEDs_snap, LEDs_err) in
                            if (LEDs_err != nil) {
                                print("Error LEDs_err: \(LEDs_err!.localizedDescription)")
                                return
                            }
                            
                            /// go through leds in a room
                            for led in LEDs_snap!.documents {
                                let new_LED = LED(name        : led.get("name")         as! String,
                                                  pattern_name: led.get("pattern_name") as! String,
                                                  R: led.get("R") as! Int,
                                                  G: led.get("G") as! Int,
                                                  B: led.get("B") as! Int)
                                room_LEDs.append(new_LED)
                            }
                        }
                        
                        let new_room = Room(name: room_name, LEDs: room_LEDs)
                        self.rooms.append(new_room)
                    }
                    
                    
                }
                
                
            }
            
            
            
            
            
        }
        
    }
}
