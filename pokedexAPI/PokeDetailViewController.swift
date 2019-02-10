//
//  PokeDetailViewController.swift
//  pokedexAPI
//
//  Created by Vithursan Sivakumaran on 13/01/2019.
//  Copyright © 2019 Tvn. All rights reserved.
//

import UIKit
import Alamofire

class PokeDetailViewController: UIViewController {

    @IBOutlet weak var changeImageText: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    var pokemon: Pokemon!
    
    class func newInstance(pokemon: Pokemon) -> PokeDetailViewController {
        let mlvc = PokeDetailViewController()
        mlvc.pokemon = pokemon
        return mlvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageURL = URL(string: pokemon.sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        var stringtext = "\(pokemon.name) "
        for type in pokemon.types {
            stringtext += "\(type) "
        }
        image.image = UIImage(data: imageData)
        name.text = stringtext
        changeImageText.setTitle("Shiny", for: .normal)
        // Do any additional setup after loading the view.
    }

    @IBAction func changeImageShiny(_ sender: UIButton) {
        if(changeImageText.currentTitle == "Shiny") {
            changeImageText.setTitle("Normal", for: .normal)
            let imageURL = URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/\(pokemon.id).png")
            let imageData = try! Data(contentsOf: imageURL!)
            image.image = UIImage(data: imageData)
        } else {
            changeImageText.setTitle("Shiny", for: .normal)
            let imageURL = URL(string: pokemon.sprite)
            let imageData = try! Data(contentsOf: imageURL!)
            image.image = UIImage(data: imageData)
        }
    }
}
