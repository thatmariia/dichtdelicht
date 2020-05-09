//
//  LED.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation

struct LED : Hashable {
    var name: String
    var pattern_name: String = "static"
    
    var R: Int
    var G: Int
    var B: Int
}
