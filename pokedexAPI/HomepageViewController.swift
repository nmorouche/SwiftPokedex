//
//  HomepageViewController.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 28/12/2018.
//  Copyright © 2018 Tvn. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class HomepageViewController: UIViewController {
    
    public var pokemons: [Pokemon] = []
    var player : AVAudioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundSound()
        self.navigationItem.title = "Chargement ..."
        loadingBackground()
        PokemonServices.default.getPokemon(completed: { (res1) in
            PokemonServices.default.getPokemonList(limit: res1, completed: { (res2) in
                res2.forEach { res3 in
                    guard let resForEach = res3["url"] as? String else {return}
                    PokemonServices.default.getSoloPokemon(url: resForEach, completed: { (id, image, urlFR, types) in
                        PokemonServices.default.getSoloPokemonDetails(urlFR: urlFR, completed: { (pokemonname) in
                            let newPokemon = Pokemon(id: id, name: pokemonname, sprite: image, types: types)
                            self.pokemons.append(newPokemon)
                            self.nextPage(pokemontab: self.pokemons)
                        })
                    })
                }
            })
        })
    }
    
    public func loadingBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "loadingbackground")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
    }
    
    public func nextPage(pokemontab: [Pokemon]){
        if pokemontab.count == 850 {
            self.pokemons.sort {
                $0.id < $1.id
            }
            let next = PokeCollectViewController.newInstance(pokemons: self.pokemons)
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func backgroundSound() {
        do{
            let audioPath = Bundle.main.path(forResource: "song", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!) as URL)
        }
        catch {
            
        }
        player.volume = 0.3
        player.play()
    }
}
