//
//  PokemonServices.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 13/01/2019.
//  Copyright © 2019 Tvn. All rights reserved.
//

import Foundation
import Alamofire

public class PokemonServices {
    public static let `default` = PokemonServices()
    
    private init(){
        
    }
    
    public func getPokemons(completion: @escaping ([[String:Any]]) -> Void) {
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/").responseJSON { (res) in
            guard let json = res.result.value as? [String:Any],
                let jsonUrl = json["results"] as? [[String: Any]] else {
                    return
            }
            completion(jsonUrl)
        }
    }
    
    public func getInfosPokemon(url: String, completion: @escaping (Pokemon) -> Void) {
        var pokemon: Pokemon!
        Alamofire.request(url).responseJSON { (res) in
            guard let jsonPoke = res.result.value as? [String:Any],
                let id = jsonPoke["id"] as? Int,
                let name = jsonPoke["name"] as? String,
                let imageJson = jsonPoke["sprites"] as? [String:Any],
                let image = imageJson["front_default"] as? String else {
                    return
            }
            pokemon = Pokemon(name: name, id: id, sprite: image)
                completion(pokemon)
        }
    }
    
}
