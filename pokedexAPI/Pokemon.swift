//
//  Pokemon.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 29/12/2018.
//  Copyright © 2018 Tvn. All rights reserved.
//

import Foundation

struct Pokemon {
    
    var name: String
    var id: Int
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String else {
                return nil
        }
        self.init(id: id, name: name)
    }
    
    init(id: Int,name: String) {
        self.id = id
        self.name = name
    }
}
