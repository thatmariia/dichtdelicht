//
//  LED.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation

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

func get_pattern(from pattern_firebase: [String: Any]) -> Pattern{
    let new_pattern = Pattern(type    : pattern_firebase["type"]      as! String,
                              rpm     : pattern_firebase["rpm"]       as! Float,
                              frquency: pattern_firebase["frequency"] as! Float)
    return new_pattern
}
