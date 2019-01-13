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
    
    init?(name: String, id: Int, sprite: String){
        self.name = name
        self.id = id
        self.sprite = sprite
    }
    
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let sprite = json["front_default"] as? String else {
                return nil
        }
        self.init(id: id, name: name, sprite: sprite)
    }
    
    init(id: Int, name: String, sprite: String) {
        self.id = id
        self.name = name
        self.sprite = sprite
    }
}
