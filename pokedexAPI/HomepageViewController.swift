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
    public var json: [[String:Any]] = []
    let shapeLayer = CAShapeLayer()
    
    override func viewDidLoad() {
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
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
                res2.forEach { res3 in
                    guard let resForEach = res3["url"] as? String else {return}
                    PokemonServices.default.getSoloPokemon(url: resForEach, completed: { (id, image, urlFR, types) in
                        PokemonServices.default.getSoloPokemonDetails(urlFR: urlFR, completed: { (pokemonname) in
                            let newPokemon = Pokemon(id: id, name: pokemonname, sprite: image, types: types)
                            self.pokemons.append(newPokemon)
                            print(newPokemon)
                            print(self.pokemons.count)
                            if self.pokemons.count == 892 {
                                self.pokemons.sort {
                                    $0.id < $1.id
                                }
                                print(self.pokemons.last)
                            }
                        })
                    })
                }
            })
        })
        // FIN TEST CIRCLE BOUTON
        
        /*DispatchQueue.main.asyncAfter(deadline: .now() + 20) {
            self.pokemons.sort {
                $0.id < $1.id
            }
            print(self.pokemons)
        }*/
    }
    @objc private func handleTap() {
        print("test waw")
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = 3
        basicAnimation.fillMode = kCAFillModeForwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    
    @IBOutlet var test: UITextField!
    
    @IBAction func changePage(_ sender: UIButton) {
        self.pokemons.sort {
            $0.id < $1.id
        }
        let next = PokeCollectViewController.newInstance(pokemons: pokemons)
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    /*func fetchPokemons(limit: Int, completed: @escaping ([Pokemon]) -> Void) {
        Alamofire.request("https://pokeapi-215911.firebaseapp.com/api/v2/pokemon/?offset=0&limit=\(limit)").responseJSON(completionHandler: { (res) in
            guard let json = res.result.value as? [String:Any],
                let jsonUrl = json["results"] as? [[String: Any]] else {
                    return
            }
            var pokemonss: [Pokemon] = []
            jsonUrl.forEach { x in
                guard let url = x["url"] as? String else { return }
                Alamofire.request(url).responseJSON(completionHandler: { (res2) in
                    guard let jsonPoke = res2.result.value as? [String:Any],
                        let id = jsonPoke["id"] as? Int,
                        let imageJson = jsonPoke["sprites"] as? [String:Any],
                        let image = imageJson["front_default"] as? String,
                        let spicies = jsonPoke["species"] as? [String:Any],
                        let urlFr = spicies["url"] as? String else {
                            return
                    }
                    Alamofire.request(urlFr).responseJSON(completionHandler: { (res3) in
                        guard let poke = res3.result.value as? [String:Any],
                            let names = poke["names"] as? [[String:Any]],
                            let name = names[6]["name"] as? String else {
                                return
                        }
                        let localpokemon = Pokemon(id: id, name: name, sprite: image)
                        pokemonss.append(localpokemon)
                        if pokemonss.count == limit - 1 {
                            completed(pokemonss)
                        }
                    })
                })
            }
        })
    }*/
}
