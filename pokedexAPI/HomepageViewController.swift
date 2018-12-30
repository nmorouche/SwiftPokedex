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

        // Do any additional setup after loading the view.
    }
    

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
            let pokemon = Pokemon(id: id, name: name)
            self.test2.text = "Nom : \(pokemon.name) #\(pokemon.id)"
            print(pokemon)
        }
    }
}
