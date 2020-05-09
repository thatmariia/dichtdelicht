//
//  Room.swift
//  DichtDeLicht
//
//  Created by Mariia Turchina on 09/05/2020.
//  Copyright © 2020 Mariia Turchina. All rights reserved.
//

import Foundation
import SwiftUI

struct Room : Hashable {
    var doc_id: String
    
    var name: String
    var LEDs: [LED]
}
