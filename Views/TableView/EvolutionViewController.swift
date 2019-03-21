//
//  EvolutionViewController.swift
//  pokedexAPI
//
//  Created by Nassim Morouche on 21/02/2019.
//  Copyright © 2019 Tvn. All rights reserved.
//

import UIKit
import AVFoundation

class EvolutionViewController: UIViewController {
    
    var pokemons: [Pokemon]!
    var player : AVAudioPlayer = AVAudioPlayer()
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTitle()
        setBackground()
    }
    
    class func newInstance(pokemon: [Pokemon]) ->
        EvolutionViewController {
            let evc = EvolutionViewController()
            evc.pokemons = pokemon
            return evc
    }
    
    func setupTitle() {
        self.navigationItem.title = "Évolution"
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "EvolutionTableViewCell", bundle: nil), forCellReuseIdentifier: EvolutionViewController.evolutionCellID)
        tableView.numberOfRows(inSection: 3)
    }
    
    public func setBackground(){
        self.tableView.backgroundColor = UIColor.clear
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "background")
        backgroundImage.contentMode =  UIView.ContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
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
}

extension EvolutionViewController: UITableViewDelegate {
    
}

extension EvolutionViewController: UITableViewDataSource {
    
    public static let evolutionCellID = "EVOLUTION_CELL_IDENTIFIER"
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EvolutionViewController.evolutionCellID, for: indexPath) as! EvolutionTableViewCell
        cell.cellLabel.text = "#\(pokemons[indexPath.row].id) \(pokemons[indexPath.row].name)"
        let imageURL = URL(string: pokemons[indexPath.row].sprite)
        let imageData = try! Data(contentsOf: imageURL!)
        cell.cellImage.image = UIImage(data: imageData)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goToDetails(indexPath: indexPath)
    }
    
    func goToDetails(indexPath: IndexPath) {
        let idChoosen = self.pokemons[indexPath.row].id
        let nameChoose = self.pokemons[indexPath.row].name
        let imageChoosen = self.pokemons[indexPath.row].sprite
        let typesChoosen = self.pokemons[indexPath.row].types
        selectSound()
        let next = PokeDetailViewController.newInstance(pokemon: Pokemon(id: idChoosen, name: nameChoose, sprite: imageChoosen, types: typesChoosen), evolution: 1)
        self.navigationController?.pushViewController(next, animated: true)
    }
}
