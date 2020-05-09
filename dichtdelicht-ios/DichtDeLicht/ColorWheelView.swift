//
//  ColorWheelView.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import SwiftUI
import ColorPicker
import Firebase

struct ColorWheelView: View {
    // TODO:: make initial value be a value from firebase
    @State var color = UIColor.red
    
    @ObservedObject var home : HomeObserver
    
    var user_home : String
    var curr_rooms : Room
    var curr_LEDs : [LED]
    
    var body: some View {
        VStack{
            ColorPicker(color: $color, strokeWidth: 30)
                .frame(width: 300, height: 300, alignment: .center)
            Text("\(color.rgba.red), \(color.rgba.green), \(color.rgba.blue), \(color.rgba.alpha)")
            
            Button(action: {
                self.update_color_firebase()
            }) {
                Text("Save")
            }
        }
    }
    
    fileprivate func update_color_firebase() {
        let home_path = Firestore.firestore().collection("home").document(home.home_id)
        
        /// get ids of all the rooms where changing
        let changing_room_ids = get_room_ids(home_path: home_path)
        print("*** changing room ids = \(changing_room_ids)")
        
        /// get ids of all the leds where changing
        var changing_LEDs_ids: [String] = []
        for led in curr_LEDs{
            changing_LEDs_ids.append(led.doc_id)
        }
        print("*** changing led ids = \(changing_LEDs_ids)")
        
        /// go through all the curr room(s) and change LEDs there if they're in the curr LEDs
        update_LEDs_firebase(home_path: home_path,
                             changing_room_ids: changing_room_ids,
                             changing_LEDs_ids: changing_LEDs_ids)

    }
    
    fileprivate func update_LEDs_firebase(home_path: DocumentReference,
                                          changing_room_ids: [String],
                                          changing_LEDs_ids: [String]){
        for room_id in changing_room_ids{
            let LEDs_path = home_path.collection("rooms").document(room_id).collection("LED")
            LEDs_path.getDocuments { (LED_snap, LED_error) in
                if (LED_error != nil) {
                    print("Error rooms_err: \(LED_error!.localizedDescription)")
                    return
                }
                for led in LED_snap!.documents{
                    if (changing_LEDs_ids.contains(led.documentID)){
                        let LED_path = LEDs_path.document(led.documentID)
                        LED_path.setData(["R": Int(self.color.rgba.red),
                                          "G": Int(self.color.rgba.green),
                                          "B": Int(self.color.rgba.blue)], merge: true) { (setLED_err) in
                            if (setLED_err != nil) {
                                print("Error setLED_err: \(setLED_err!.localizedDescription)")
                                return
                            }
                        }
                    }
                }
            }

        }
    }
    
    fileprivate func get_room_ids(home_path: DocumentReference) -> [String]{
        var changing_room_ids: [String] = []
        
        if (curr_rooms.name != ALL_ROOMS){
            changing_room_ids.append(curr_rooms.doc_id)
        } else {
            let rooms_collections = home_path.collection("rooms")
            rooms_collections.getDocuments { (rooms_snap, rooms_err) in
                if (rooms_err != nil) {
                    print("Error rooms_err: \(rooms_err!.localizedDescription)")
                    return
                }
                
                for room in rooms_snap!.documents{
                    changing_room_ids.append(room.documentID)
                }
            }
        }
        
        return changing_room_ids
    }
}

/*struct ColorWheelView_Previews: PreviewProvider {
    static var previews: some View {
        ColorWheelView()
    }
}*/
