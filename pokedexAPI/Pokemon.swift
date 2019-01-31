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
    var types: [String]?
    
    
    init(id: Int, name: String, sprite: String, types: [String]? = nil) {
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
        
        self.id = id
        self.name = name
        self.sprite = sprite
        self.types = types
    }
    
}
    /*init?(name: String, id: Int, sprite: String, type1: String?, type2: String?){
        self.name = name
        self.id = id
        self.sprite = sprite
        self.type1 = type1
        self.type2 = type2
    }
    
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let sprite = json["front_default"] as? String,
            let type1 = json["type1"] as? String,
            let type2 = json["type2"] as? String else {
                return nil
        }
        self.init(id: id, name: name, sprite: sprite, type1: type1, type2: type2)
    }*/
    

