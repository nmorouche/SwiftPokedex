//
//  FavorisViewController.swift
//  pokedexAPI
//
//  Created by Vithursan Sivakumaran on 10/02/2019.
//  Copyright © 2019 Tvn. All rights reserved.
//

import UIKit

class FavorisViewController: UIViewController {
    var pokemons: [Pokemon]!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        self.navigationItem.title = "Favoris"
        self.FavCollectionView.delegate = self
        self.FavCollectionView.dataSource = self
        self.FavCollectionView.register(UINib(nibName: "FavCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: FavorisViewController.pokemonCellId)
        //print(pokemons!)
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 2.0
        FavCollectionView.addGestureRecognizer(lpgr)
        // Do any additional setup after loading the view.
    }
    
    class func newInstance(pokemon: [Pokemon]) ->
        FavorisViewController {
        let pdvc = FavorisViewController()
        pdvc.pokemons = pokemon
        return pdvc
    }
    
    @IBOutlet var FavCollectionView: UICollectionView!
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if (gesture.state != .ended) {
            return
        }
        let p = gesture.location(in: self.FavCollectionView)
        
        if let indexPath = self.FavCollectionView.indexPathForItem(at: p) {
            //PokemonServices.default.delete(id: self.pokemons[indexPath.row].id)
            let alert = UIAlertController(title: "Supprimé \(self.pokemons[indexPath.row].name) ?", message: "Voulez-vous supprimer \(self.pokemons[indexPath.row].name) de vos favoris ?", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Oui", style: .default, handler: { (action) -> Void in
                PokemonServices.default.delete(id: self.pokemons[indexPath.row].id)
                self.pokemons.remove(at: indexPath.row)
                self.FavCollectionView.reloadData()
            })
            let cancel = UIAlertAction(title: "Non", style: .default, handler: { (action) -> Void in
                
            })
            alert.addAction(ok)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        } else {
            print("no index path")
        }
    }
}



extension FavorisViewController: UICollectionViewDelegate {
    
}

extension FavorisViewController: UICollectionViewDataSource {
    public static let pokemonCellId = "toz"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavorisViewController.pokemonCellId, for: indexPath) as! FavCollectionViewCell
        let imageURL = URL(string: self.pokemons[indexPath.row].sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        cell.image.image = UIImage(data: imageData)
        cell.name.text = "\(self.pokemons[indexPath.row].name)"
        cell.id.text = "#\(self.pokemons[indexPath.row].id)"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let idChoosen = self.pokemons[indexPath.row].id
        let nameChoose = self.pokemons[indexPath.row].name
        let imageChoosen = self.pokemons[indexPath.row].sprite
        let typesChoosen = self.pokemons[indexPath.row].types
        //var type: [String] = []
        
        let next = PokeDetailViewController.newInstance(pokemon: Pokemon(id: idChoosen, name: nameChoose, sprite: imageChoosen, types: typesChoosen))
        self.navigationController?.pushViewController(next, animated: true)
        
    }
}

