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
    
    @IBOutlet var weak1: UIImageView!
    @IBOutlet var weak2: UIImageView!
    @IBOutlet var weak3: UIImageView!
    @IBOutlet var weak4: UIImageView!
    
    
    var pokemon: Pokemon!
    var imageShiny: String!
    
    class func newInstance(pokemon: Pokemon) -> PokeDetailViewController {
        let pdvc = PokeDetailViewController()
        pdvc.pokemon = pokemon
        return pdvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        setupButtonsAtStart()
        PokemonServices.default.getShiny(id: pokemon.id) { (res) in
            self.setupButtonAfterRequest()
            self.imageShiny = res
        }
        setupView()
    }

    @IBAction func switchPressure(_ sender: Any) {
        if(switchShiny.isOn) {
            toShiny()
        }
        else {
            toNormal()
        }
    }
    
    func setBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func setupButtonsAtStart() {
        shinyLabel.isHidden = true
        switchShiny.isEnabled = false
        switchShiny.isHidden = true
        switchShiny.isOn = false
    }
    
    func setupButtonAfterRequest() {
        self.switchShiny.isEnabled = true
        self.switchShiny.isHidden = false
        self.shinyLabel.isHidden = false
        self.shinyLabel.text = "Normal"
        self.shinyLabel.backgroundColor = UIColor.red
    }
    
    func setupView() {
        let imageURL = URL(string: pokemon.sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        image.image = UIImage(data: imageData)
        name.textColor = UIColor.white
        name.text = "\(pokemon.name)\n#\(pokemon.id)"
        switch(pokemon.types.count){
        case 2: self.typeslogo1.image = UIImage(named: self.pokemon.types[1])
                self.typeslogo3.image = UIImage(named: self.pokemon.types[0])
            break
        default: self.typeslogo2.image = UIImage(named: self.pokemon.types[0])
            break
        }
    }
    
    func toShiny() {
        self.shinyLabel.text = "Shiny"
        let imageURL = URL(string: self.imageShiny)
        let imageData = try! Data(contentsOf: imageURL!)
        self.image.image = UIImage(data: imageData)
    }
    
    func toNormal() {
        self.shinyLabel.text = "Normal"
        let imageURL = URL(string: self.pokemon.sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        self.image.image = UIImage(data: imageData)
    }
}
