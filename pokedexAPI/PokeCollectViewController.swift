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
    var pokemonSearch : [Pokemon]!
    
    class func newInstance(pokemons: [Pokemon]) -> PokeCollectViewController {
        let pcvc = PokeCollectViewController()
        pcvc.pokemons = pokemons
        return pcvc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBackground()
        searchBarSetup()
        setupBarButton()
        collectionViewSetup()
        longPressureSetup()
    }
    
    public func setBackground(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
    }
    
    func searchBarSetup() {
        searchbar.delegate = self
        let searchBarBackgroundImage = UIImage()
        searchbar.setBackgroundImage(searchBarBackgroundImage, for: .any, barMetrics: .default)
        searchbar.scopeBarBackgroundImage = searchBarBackgroundImage
        pokemonSearch = pokemons
    }
    
    func setupBarButton() {
        self.navigationItem.title = "Pokédex"
        let backButton = UIBarButtonItem(title: "", style: .plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favoris", style: .plain, target: self, action: #selector(Favoris))
    }
    
    func collectionViewSetup() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "PokemonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: PokeCollectViewController.pokemonCellId)
    }
    
    func longPressureSetup(){
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(gesture:)))
        lpgr.minimumPressDuration = 1.0
        collectionView.addGestureRecognizer(lpgr)
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        if (gesture.state != .ended) {
            return
        }
        let p = gesture.location(in: self.collectionView)
        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let pokeAdd = Pokemon(id: self.pokemonSearch[indexPath.row].id, name: self.pokemonSearch[indexPath.row].name, sprite: self.pokemonSearch[indexPath.row].sprite, types: self.pokemonSearch[indexPath.row].types)
            PokemonServices.default.add(pokemon: pokeAdd)
            let alert = UIAlertController(title: "\(self.pokemonSearch[indexPath.row].name) ajouté !", message: "\(self.pokemonSearch[indexPath.row].name) a été ajouté dans vos favoris", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            } else {
            print("no index path")
        }
    }
    
    @objc private func Favoris() {
        PokemonServices.default.findAll { (pokemons) in
            let favPage = FavorisViewController.newInstance(pokemon: pokemons)
            self.navigationController?.pushViewController(favPage, animated: true)
        }
    }
    
}

extension PokeCollectViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        guard !searchText.isEmpty else {
            pokemonSearch = pokemons
            collectionView.reloadData()
            return
        }
        pokemonSearch = pokemons.filter({ pokemon -> Bool in
            return pokemon.name.contains(searchText)
        })
        collectionView.reloadData()
    }
}

extension PokeCollectViewController: UICollectionViewDelegate {
    
}

extension PokeCollectViewController: UICollectionViewDataSource {
    
    public static let pokemonCellId = "POKEMON_CELL_ID"
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokemonSearch.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokeCollectViewController.pokemonCellId, for: indexPath) as! PokemonCollectionViewCell
        setupCell(indexPath: indexPath, cell: cell)
        return cell
    }
    func setupCell(indexPath: IndexPath, cell: PokemonCollectionViewCell) {
        let imageURL = URL(string: self.pokemonSearch[indexPath.row].sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        cell.image.image = UIImage(data: imageData)
        cell.title.text = "\(self.pokemonSearch[indexPath.row].name)"
        cell.id.text = "#\(self.pokemonSearch[indexPath.row].id)"
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goToDetails(indexPath: indexPath)
    }
    func goToDetails(indexPath: IndexPath) {
        let idChoosen = self.pokemonSearch[indexPath.row].id
        let nameChoose = self.pokemonSearch[indexPath.row].name
        let imageChoosen = self.pokemonSearch[indexPath.row].sprite
        let typesChoosen = self.pokemonSearch[indexPath.row].types
        let next = PokeDetailViewController.newInstance(pokemon: Pokemon(id: idChoosen, name: nameChoose, sprite: imageChoosen, types: typesChoosen))
        self.navigationController?.pushViewController(next, animated: true)
    }
    
}
