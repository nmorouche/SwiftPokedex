//
//  PokeCollectViewController.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 14/01/2019.
//  Copyright © 2019 Tvn. All rights reserved.
//

import UIKit
import Alamofire

class PokeCollectViewController: UIViewController {
    
    @IBOutlet var searchbar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var pokemons : [Pokemon]!
    
    class func newInstance(pokemons: [Pokemon]) -> PokeCollectViewController {
        let mlvc = PokeCollectViewController()
        mlvc.pokemons = pokemons
        return mlvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchbar.delegate = self as? UISearchBarDelegate
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PokeCollectViewController.pokemonCellId)
        // Do any additional setup after loading the view.
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 2.0
        collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if (gesture.state != .ended) {
            return
        }
        let p = gesture.location(in: self.collectionView)
        
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let alert = UIAlertController(title: "\(self.pokemons[indexPath.row].name) ajouté !", message: "\(self.pokemons[indexPath.row].name) a été ajouté dans vos favoris", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            } else {
            print("no index path")
        }
    }
}

extension PokeCollectViewController: UICollectionViewDelegate {
    
}

extension PokeCollectViewController: UICollectionViewDataSource {
    
    public static let pokemonCellId = "POKEMON_CELL_ID"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectViewController.pokemonCellId, for: indexPath) as! PokemonCollectionViewCell
        
        let imageURL = URL(string: self.pokemons[indexPath.row].sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        cell.image.image = UIImage(data: imageData)
        cell.title.text = "\(self.pokemons[indexPath.row].name)"
        cell.id.text = "#\(self.pokemons[indexPath.row].id)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idChoosen = self.pokemons[indexPath.row].id
        let nameChoose = self.pokemons[indexPath.row].name
        let imageChoosen = self.pokemons[indexPath.row].sprite
        //var type: [String] = []
        
        
        Alamofire.request("https://pokeapi.co/api/v2/pokemon/\(String(idChoosen))/").responseJSON { (res) in
            var types : [String] = []
            
            guard let json = res.result.value as? [String:Any],
                let jsonUrl = json["types"] as? [[String: Any]] else {
                    return
            }
            var i = 0
            jsonUrl.forEach{ x in
                
                //types = x["name"] as! [String]
                guard let typ = jsonUrl[i]["type"] as? [String : Any],
                    let type = typ["name"] as? String else {
                        return
                }
                i = i + 1
                
                types.append(type)
            }
            let next = PokeDetailViewController.newInstance(pokemon: Pokemon(id: idChoosen, name: nameChoose, sprite: imageChoosen, types: types))
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
}
