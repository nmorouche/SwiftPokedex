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
    @IBOutlet var shinyButton: UIButton!
    var pokemon: Pokemon!
    var imageShiny: String!
    
    class func newInstance(pokemon: Pokemon) -> PokeDetailViewController {
        let mlvc = PokeDetailViewController()
        mlvc.pokemon = pokemon
        return mlvc
    }
    
    override func viewDidLoad() {
        shinyButton.isEnabled = false
        shinyButton.isHidden = true
        PokemonServices.default.getShiny(id: pokemon.id) { (res) in
            self.shinyButton.isEnabled = true
            self.shinyButton.isHidden = false
            self.imageShiny = res
        }
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
        if(self.changeImageText.currentTitle == "Shiny") {
            self.changeImageText.setTitle("Normal", for: .normal)
            let imageURL = URL(string: self.imageShiny)
            let imageData = try! Data(contentsOf: imageURL!)
            self.image.image = UIImage(data: imageData)
        } else {
            self.changeImageText.setTitle("Shiny", for: .normal)
            let imageURL = URL(string: self.pokemon.sprite)
            let imageData = try! Data(contentsOf: imageURL!)
            self.image.image = UIImage(data: imageData)
        }
    }
}
