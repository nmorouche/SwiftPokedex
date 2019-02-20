//
//  Pokemon.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 29/12/2018.
//  Copyright © 2018 Tvn. All rights reserved.
//

import Foundation

public struct Pokemon {
    
    var name: String
    var id: Int
    var sprite: String
    var types: [String]
    
    
    init(id: Int, name: String, sprite: String, types: [String]) {
        self.id = id
        self.name = name
        self.sprite = sprite
        self.types = types
    }
    
    init?(json: [String: Any]) {
        
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let sprite = json["sprite"] as? String,
            let types = json["types"] as? [String]
            else {
                return nil
        }
        self.init(id: id, name: name, sprite: sprite, types: types)
    }
}
