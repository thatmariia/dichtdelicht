//
//  HomeObserver.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import Firebase

// TODO:: add change listeners

/// takes a home name and fetches all the rooms of this home
class HomeObserver : ObservableObject {
    @Published var rooms = [Room]()
    @Published var home_id = ""
    
    var home_name: String = "royal_house"
    
    init(home_name: String) {
        self.home_name = home_name
        
        let homes = DB.collection("home")
        
        let home_query = homes.whereField("name", isEqualTo: home_name)
        
        /// listening to home
        home_query.addSnapshotListener { (home_snap, home_err) in
            if (home_err != nil) {
                print("Error home_err: \(home_err!.localizedDescription)")
                return
            }
            
            if (home_snap!.documents.count > 1){
                print("we have more than 1 home with the same name")
                return
            }

            /// go through home (should only be snap of len 1)
            for doc in home_snap!.documents {
                self.home_id = doc.documentID
                
                let rooms = homes.document(doc.documentID).collection("rooms")
                rooms.getDocuments { (rooms_snap, rooms_err) in
                    if (rooms_err != nil) {
                        print("Error rooms_err: \(rooms_err!.localizedDescription)")
                        return
                    }
                    
                    /// go though rooms in a home
                    self.rooms = []
                    for room in rooms_snap!.documents{
                        let room_name = room.get("name") as! String
                        let room_id = room.documentID
                        
                        let LEDs = rooms.document(room.documentID).collection("LED")
                        LEDs.getDocuments { (LEDs_snap, LEDs_err) in
                            if (LEDs_err != nil) {
                                print("Error LEDs_err: \(LEDs_err!.localizedDescription)")
                                return
                            }
                            
                            /// go through leds in a room
                            var room_LEDs : [LED] = []
                            
                            for led in LEDs_snap!.documents {
                                room_LEDs.append(get_LED(from: led))
                            }
                            
                            let new_room = Room(doc_id: room_id, name: room_name, LEDs: room_LEDs)
                            self.rooms.append(new_room)
                        }
                    }
                    
                    
                }
                
                
            }
            
            
            
            
            
        }
        
    }
}
