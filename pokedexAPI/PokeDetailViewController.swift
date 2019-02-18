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

    @IBOutlet var shinyLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var switchShiny: UISwitch!
    @IBOutlet var typeslogo1: UIImageView!
    @IBOutlet var typeslogo2: UIImageView!
    @IBOutlet var typeslogo3: UIImageView!
    
    var pokemon: Pokemon!
    var imageShiny: String!
    
    class func newInstance(pokemon: Pokemon) -> PokeDetailViewController {
        let pdvc = PokeDetailViewController()
        pdvc.pokemon = pokemon
        return pdvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shinyLabel.isHidden = true
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        switchShiny.isEnabled = false
        switchShiny.isHidden = true
        PokemonServices.default.getShiny(id: pokemon.id) { (res) in
            self.switchShiny.isEnabled = true
            self.switchShiny.isHidden = false
            self.shinyLabel.isHidden = false
            self.shinyLabel.text = "Normal"
            self.shinyLabel.backgroundColor = UIColor.red
            self.imageShiny = res
        }
        let imageURL = URL(string: pokemon.sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        var stringtext = "\(pokemon.name) "
        for type in pokemon.types {
            stringtext += "\(type) "
        }
        switch(pokemon.types.count){
            case 2: self.typeslogo1.image = UIImage(named: self.pokemon.types[1])
                    self.typeslogo3.image = UIImage(named: self.pokemon.types[0])
                break
            default: self.typeslogo2.image = UIImage(named: self.pokemon.types[0])
        }
        image.image = UIImage(data: imageData)
        name.text = stringtext
        print(stringtext)
        // Do any additional setup after loading the view.
        switchShiny.isOn = false
    }

    @IBAction func switchPressure(_ sender: Any) {
        if(switchShiny.isOn) {
            self.shinyLabel.text = "Shiny"
            let imageURL = URL(string: self.imageShiny)
            let imageData = try! Data(contentsOf: imageURL!)
            self.image.image = UIImage(data: imageData)
        }
        else {
            self.shinyLabel.text = "Normal"
            let imageURL = URL(string: self.pokemon.sprite)
            let imageData = try! Data(contentsOf: imageURL!)
            self.image.image = UIImage(data: imageData)
        }
    }
}
