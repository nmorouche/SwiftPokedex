//
//  PokeDetailViewController.swift
//  pokedexAPI
//
//  Created by Vithursan Sivakumaran on 13/01/2019.
//  Copyright © 2019 Tvn. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class PokeDetailViewController: UIViewController {

    var player : AVAudioPlayer = AVAudioPlayer()
    @IBOutlet var shinyLabel: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet var switchShiny: UISwitch!
    @IBOutlet var weaknessLabel: UILabel!
    @IBOutlet var strongLabel: UILabel!
    
    @IBOutlet var typeslogo1: UIImageView!
    @IBOutlet var typeslogo2: UIImageView!
    @IBOutlet var typeslogo3: UIImageView!
    
    @IBOutlet var weak1: UIImageView!
    @IBOutlet var weak2: UIImageView!
    @IBOutlet var weak3: UIImageView!
    @IBOutlet var weak4: UIImageView!
    
    @IBOutlet var strong1: UIImageView!
    @IBOutlet var strong2: UIImageView!
    @IBOutlet var strong3: UIImageView!
    @IBOutlet var strong4: UIImageView!
    
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
        displayStrongWeakness()
        clickImage()
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
        self.shinyLabel.textColor = UIColor.white
    }
    
    func setupView() {
        weaknessLabel.textColor = UIColor.white
        strongLabel.textColor = UIColor.white
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
        selectSound()
    }
    
    func toNormal() {
        self.shinyLabel.text = "Normal"
        let imageURL = URL(string: self.pokemon.sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        self.image.image = UIImage(data: imageData)
        selectSound()
    }
    
    func displayStrongWeakness() {
        var typeChoice: String!
        if(self.pokemon.types.count <= 1){
            typeChoice = self.pokemon.types[0]
        } else {
            typeChoice = self.pokemon.types[1]
        }
        
        PokemonServices.default.getTypePokemon(type: typeChoice, completed: { (strong, weak) in
            switch(strong.count){
            case 1 : self.strong1.image = UIImage(named : strong[0])
                break
            case 2 : self.strong1.image = UIImage(named : strong[0])
            self.strong2.image = UIImage(named : strong[1])
                break
            case 3 : self.strong1.image = UIImage(named : strong[0])
            self.strong2.image = UIImage(named : strong[1])
            self.strong3.image = UIImage(named : strong[2])
                break
            case 4 : self.strong1.image = UIImage(named : strong[0])
            self.strong2.image = UIImage(named : strong[1])
            self.strong3.image = UIImage(named : strong[2])
            self.strong4.image = UIImage(named : strong[3])
                break
            default : self.strong1.image = UIImage(named : strong[0])
            self.strong2.image = UIImage(named : strong[1])
            self.strong3.image = UIImage(named : strong[2])
            self.strong4.image = UIImage(named : strong[3])
                break
            }
            
            switch(weak.count){
            case 1 : self.weak1.image = UIImage(named : weak[0])
                break
            case 2 : self.weak1.image = UIImage(named : weak[0])
            self.weak2.image = UIImage(named : weak[1])
                break
            case 3 : self.weak1.image = UIImage(named : weak[0])
            self.weak2.image = UIImage(named : weak[1])
            self.weak3.image = UIImage(named : weak[2])
                break
            case 4 : self.weak1.image = UIImage(named : weak[0])
            self.weak2.image = UIImage(named : weak[1])
            self.weak3.image = UIImage(named : weak[2])
            self.weak4.image = UIImage(named : weak[3])
                break
            default : self.weak1.image = UIImage(named : weak[0])
            self.weak2.image = UIImage(named : weak[1])
            self.weak3.image = UIImage(named : weak[2])
            self.weak4.image = UIImage(named : weak[3])
                break
            }
        })
    }
    
    func selectSound() {
        do{
            let audioPath = Bundle.main.path(forResource: "selectsound", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
            
        }
        player.volume = 0.7
        player.play()
    }
    
    func selectPokemonSound() {
        do{
            let audioPath = Bundle.main.path(forResource: "\(pokemon.id)", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
            
        }
        player.volume = 0.7
        player.play()
    }

    func selectSoundDefault() {
        do{
            let audioPath = Bundle.main.path(forResource: "default", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
            
        }
        player.volume = 0.7
        player.play()
    }
    
    func clickImage() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        image.addGestureRecognizer(tapGesture)
        image.isUserInteractionEnabled = true
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        // if the tapped view is a UIImageView then set it to imageview
        if (gesture.view as? UIImageView) != nil {
            if pokemon.id <= 9 {
                selectPokemonSound()
            }
            else {
                selectSoundDefault()
            }
            //Here you can initiate your new ViewController
            
        }
    }
}
