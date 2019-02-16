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
    
    public var pokemons: [Pokemon] = []
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        self.navigationItem.title = "Chargement ..."
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "loadingbackground")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        test.isSecureTextEntry = true
        changePageOutlet.isHidden = false
        changePageOutlet.isEnabled = false
        super.viewDidLoad()
        // TEST CIRCLE BOUTON
        
        //Track layer
        let tracklayer = CAShapeLayer()
        let circularPath = UIBezierPath(arcCenter: view.center, radius: 100, startAngle: -CGFloat.pi/2, endAngle: 2 * CGFloat.pi, clockwise: true)
        tracklayer.path = circularPath.cgPath
        tracklayer.fillColor = UIColor.clear.cgColor
        tracklayer.strokeColor = UIColor.black.cgColor
        tracklayer.lineWidth = 10
        tracklayer.lineCap = kCALineCapRound
        //tracklayer.position = self.view.center
        //tracklayer.anchorPoint = CGPoint(x:0.5, y:0.5)
        view.layer.addSublayer(tracklayer)

        shapeLayer.path = circularPath.cgPath
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 10
        shapeLayer.strokeEnd = 0
        shapeLayer.lineCap = kCALineCapRound
        view.layer.addSublayer(shapeLayer)
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        PokemonServices.default.getPokemon(completed: { (res1) in
            PokemonServices.default.getPokemonList(limit: res1, completed: { (res2) in
                print(res2.count)
                var i = 0
                res2.forEach { res3 in
                    
                    guard let resForEach = res3["url"] as? String else {return}
                    PokemonServices.default.getSoloPokemon(url: resForEach, completed: { (id, image, urlFR, types) in
                        PokemonServices.default.getSoloPokemonDetails(urlFR: urlFR, completed: { (pokemonname) in
                            let newPokemon = Pokemon(id: id, name: pokemonname, sprite: image, types: types)
                            self.pokemons.append(newPokemon)
                            if i == 891 {
                                self.pokemons.sort {
                                    $0.id < $1.id
                                }
                                let next = PokeCollectViewController.newInstance(pokemons: self.pokemons)
                                self.navigationController?.pushViewController(next, animated: true)
                            }
                            i += 1
                        })
                    })
                }
            })
        })
        // FIN TEST CIRCLE BOUTON
    }
    @objc private func handleTap() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    @IBOutlet var test: UITextField!
    
    @IBOutlet var changePageOutlet: UIButton!
    @IBAction func changePage(_ sender: UIButton) {
        let next = PokeCollectViewController.newInstance(pokemons: pokemons)
        self.navigationController?.pushViewController(next, animated: true)
    }
}
