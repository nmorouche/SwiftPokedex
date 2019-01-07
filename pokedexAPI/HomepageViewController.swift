//
//  HomepageViewController.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 28/12/2018.
//  Copyright © 2018 Tvn. All rights reserved.
//

import UIKit
import Alamofire

class HomepageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/").responseJSON { (res) in
            guard let json = res.result.value as? [String:Any],
                let jsonUrl = json["results"] as? [[String: Any]] else {
                return
            }
            
            jsonUrl.forEach { word in
                guard let url = word["url"] as? String else {
                    return
                }
                Alamofire.request(url).responseJSON { (res) in
                    guard let jsonPoke = res.result.value as? [String:Any],
                        let id = jsonPoke["id"] as? Int,
                        let imageJson = jsonPoke["sprites"] as? [String:Any],
                        let image = imageJson["front_default"] as? String,
                        let spicies = jsonPoke["species"] as? [String:Any],
                        let urlFr = spicies["url"] as? String else {
                        return
                    }
                    Alamofire.request(urlFr).responseJSON{ (res) in
                        guard let jsonFr = res.result.value as? [String: Any],
                            let namesFr = jsonFr["names"] as? [[String:Any]],
                            let name = namesFr[6]["name"] as? String else {
                            return
                        }
                        print("ID : \(id), Nom : \(name), ImageURL : \(image)")
                    }
                }
            }
            /*let imageURL = URL(string: image)
            let imageData = try! Data(contentsOf: imageURL!)
            self.imageTest.image = UIImage(data: imageData)*/
        }
    }
    
    @IBOutlet weak var imageTest: UIImageView!
    
    @IBOutlet var test2: UILabel!
    @IBOutlet var test: UITextField!
    @IBAction func connectPokeAPI(_ sender: UIButton) {
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/1/").responseJSON { (res) in
            guard let json = res.result.value as? [String: Any] else {
                return
            }
            guard let name = json["name"] as? String else {
                print("Could not get pokemon's name from JSON")
                return
            }
            guard let id = json["id"] as? Int else {
                print("Could not get pokemon's id from JSON")
                return
            }
            guard let imageJson = json["sprites"] as? [String:Any] else {
                return
            }
            guard let image = imageJson["front_default"] as? String else {
                return
            }
            let pokemon = Pokemon(id: id, name: name, imageURL: name)
            self.test2.text = "Nom : \(pokemon.name) #\(pokemon.id)"
            
            let imageURL = URL(string: image)
            let imageData = try! Data(contentsOf: imageURL!)
            self.imageTest.image = UIImage(data: imageData)
            print(pokemon)
            print(image)
        }
    }
    
    @IBAction func pokefr(_ sender: UIButton) {
        Alamofire.request("https://pokeapi.co/api/v2/pokemon-species/1/").responseJSON { (res) in
            guard let json = res.result.value as? [String: Any] else {
                return
            }
            guard let names = json["names"] as? [[String:Any]] else {
                return
            }
            guard let fr = names[6]["name"] as? String else {
                return
            }
            self.test.text = fr
            print(fr)
            /*
            guard let name3 = json["name"] as? String else {
                print("Could not get pokemon's gloglo from JSON")
                return
            }
            let id = 3
            let pokemon2 = Pokemon(id: id, name: name3)
            self.test.text = pokemon2.name
            print(pokemon2.name)*/
        }
    }
}
