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
    public func getSoloPokemon(url: String, completed: @escaping (Int,String,String,[String]) -> Void) {
        Alamofire.request(url).responseJSON { (res) in
            var types : [String] = []
            guard let jsonPokemon = res.value as? [String:Any],
                let id = jsonPokemon["id"] as? Int,
                let imageJson = jsonPokemon["sprites"] as? [String:Any],
                let image = imageJson["front_default"] as? String,
                let species = jsonPokemon["species"] as? [String:Any],
                let urlSpecies = species["url"] as? String,
                let jsonUrl = jsonPokemon["types"] as? [[String: Any]] else {
                    return
            }
            var i = 0
            jsonUrl.forEach{ x in
                
                //types = x["name"] as! [String]
                guard let typ = jsonUrl[i]["type"] as? [String : Any],
                    let type = typ["name"] as? String else {
                        return
                }
                i = i + 1
                types.append(type)
            }
            completed(id,image,urlSpecies,types)
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
    
    public func getShiny(id: Int, completed: @escaping (String) -> Void) {
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/\(id)/").responseJSON { (res) in
            guard let jsonPokemon = res.value as? [String:Any],
                let imageJson = jsonPokemon["sprites"] as? [String:Any],
                let image = imageJson["front_shiny"] as? String else {
                    return
                }
            completed(image)
        }
    }
    
    public func findAll(completed: @escaping ([Pokemon]) -> Void) {
        
        Alamofire.request("https://pacific-sierra-64951.herokuapp.com/show/all").responseJSON { (res) in
            guard let m = res.value as? [[String: Any]] else {
                return
            }
            let pokemons = m.compactMap({ (elem) -> Pokemon? in
                return Pokemon(json: elem)
            })
            completed(pokemons)
        }
    }
    public func delete(id: Int) {
        Alamofire.request("https://pacific-sierra-64951.herokuapp.com/delete/\(id)", method: .delete).response { (res) in
            //completion(res.response?.statusCode == 201)
        }
    }
    public func add(pokemon: Pokemon) {
        
        let params = [
            "id": pokemon.id,
            "name": pokemon.name,
            "sprite": pokemon.sprite,
            "types": pokemon.types,
            ] as [String : Any]
        
        Alamofire.request("https://pacific-sierra-64951.herokuapp.com/create", method: .post, parameters: params, encoding: JSONEncoding.default).responseString { (res) in
            print(res)
            //completion(res.response?.statusCode == 201)
        }
    }
    public func update(pokemon: Pokemon) {
        
        let params = [
            "id": pokemon.id,
            "name": pokemon.name,
            "sprite": pokemon.sprite,
            "types": pokemon.types,
            ] as [String : Any]
        
        Alamofire.request("https://pacific-sierra-64951.herokuapp.com/update/\(pokemon.id)", method: .put, parameters: params, encoding: JSONEncoding.default).responseString { (res) in
            print(res)
            //completion(res.response?.statusCode == 201)
        }
    }
    public func getTypePokemon(type: String, completed: @escaping ([String], [String]) -> Void) {
        Alamofire.request("https://pokeapi.co/api/v2/type/\(type)").responseJSON { (res) in
            var typesWeak : [String] = []
            var typesStrong : [String] = []
            guard let jsonPokemon = res.value as? [String:Any],
                let damageType = jsonPokemon["damage_relations"] as? [String : Any],
                let doubleDamageTo = damageType["double_damage_to"] as? [[String : Any]],
                let doubleDamageFrom = damageType["double_damage_from"] as? [[String : Any]] else {
                    return
            }
            doubleDamageTo.forEach{ doubledamageto in
                
                //types = x["name"] as! [String]
                guard let type = doubledamageto["name"] as? String else {
                    return
                }
                typesStrong.append(type)
            }
            doubleDamageFrom.forEach{ doubledamagefrom in
                
                //types = x["name"] as! [String]
                guard let type = doubledamagefrom["name"] as? String else {
                    return
                }
                typesWeak.append(type)
            }
            
            completed(typesStrong, typesWeak)
        }
    }
    
}
