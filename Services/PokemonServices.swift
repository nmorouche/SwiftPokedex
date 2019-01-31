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
    
    public func getPokemon(completed: @escaping (Int) -> Void) {
        Alamofire.request("https://pokeapi-215911.firebaseapp.com/api/v2/pokemon").responseJSON { (res) in
            guard let dimension = res.value as? [String:Any],
                let limit = dimension["count"] as? Int else {return}
            completed(limit)
        }
    }
    public func getPokemonList(limit: Int,completed: @escaping ([[String:Any]]) -> Void) {
        Alamofire.request("https://pokeapi-215911.firebaseapp.com/api/v2/pokemon?offset=0&limit=\(limit)").responseJSON { (res) in
            guard let result = res.value as? [String:Any],
                let tabPoke = result["results"] as? [[String:Any]] else {return}
            completed(tabPoke)
        }
    }
    public func getSoloPokemon(url: String, completed: @escaping (Int,String,String) -> Void) {
        Alamofire.request(url).responseJSON { (res) in
            guard let jsonPokemon = res.value as? [String:Any],
                let id = jsonPokemon["id"] as? Int,
                let imageJson = jsonPokemon["sprites"] as? [String:Any],
                let image = imageJson["front_default"] as? String,
                let species = jsonPokemon["species"] as? [String:Any],
                let urlSpecies = species["url"] as? String else {return}
            completed(id,image,urlSpecies)
        }
    }
    public func getSoloPokemonDetails(urlFR: String, completed: @escaping (String) -> Void){
        Alamofire.request(urlFR).responseJSON { (res) in
            guard let pokemonDetail = res.value as? [String:Any],
                let names = pokemonDetail["names"] as? [[String:Any]],
                let nameFR = names[6]["name"] as? String else {return}
            completed(nameFR)
        }
    }
    
}
