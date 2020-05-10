//
//  LED.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import Firebase

struct LED : Hashable {
    var doc_id: String
    
    var name: String
    
    var R: Int
    var G: Int
    var B: Int
    
    var pattern: Pattern
}

struct Pattern : Hashable {
    var type: String
    var rpm: Float
    var frquency: Float
}

func get_LED(from led: QueryDocumentSnapshot) -> LED {
    let pattern_dict = get_pattern(from: led.get("pattern") as! [String : Any])
    let new_LED = LED(doc_id: led.documentID,
                      name: led.get("name") as! String,
                      R: led.get("R") as! Int,
                      G: led.get("G") as! Int,
                      B: led.get("B") as! Int,
                      pattern: pattern_dict)
    return new_LED
    
}

func get_pattern(from pattern_firebase: [String: Any]) -> Pattern{
    let new_pattern = Pattern(type    : pattern_firebase["type"]      as! String,
                              rpm     : pattern_firebase["rpm"]       as! Float,
                              frquency: pattern_firebase["frequency"] as! Float)
    return new_pattern
}
