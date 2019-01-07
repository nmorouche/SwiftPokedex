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
    var imageURL:String
    
    init?(json: [String: Any]) {
        guard let id = json["id"] as? Int,
            let name = json["name"] as? String,
            let imageURL = json["front_default"] as? String else {
                return nil
        }
        self.init(id: id, name: name, imageURL: imageURL)
    }
    
    init(id: Int, name: String, imageURL: String) {
        self.id = id
        self.name = name
        self.imageURL = imageURL
    }
}
