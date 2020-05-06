//
//  InfoRegioniProvinceViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class InfoRegioniProvinceViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    
    
    var andamentoArray: [Andamento] = []
    let dbc = DBController.shared
    var regioniArray :[Regioni] = []
    var provinceArray : [Province] = []
    var filteredDataRegioni : [Any] = []
    var filteredDataProvincie : [Any] = []
    
    @IBOutlet weak var newData: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    let searchResultTableView = UITableView()
    var tableViewWidth : CGFloat = 0
    var tableViewHeight : CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        andamentoArray = dbc.getRegioniPiùColpite()
        regioniArray = dbc.getRegioni()
        provinceArray = dbc.getProvincie()
        
        newData.layer.cornerRadius = 10
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setupSearchBar()
        
    }
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    //MARK: - SEARCHBAR
    
    var searchActive : Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    let searchController = UISearchController(searchResultsController: nil)
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
        searchBar.text = ""
        self.dismiss(animated: true, completion: nil)
        tableView.reloadData()
    }
    
    private func setupSearchBar(){
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.keyboardAppearance = .light
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        //        searchBar.barTintColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty == true{
            label.text = "Risultati ricerca"
            newData.isHidden = true
            tableViewWidth = tableView.frame.width
            tableViewHeight = tableView.frame.height
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: view.frame.width - tableView.frame.origin.x, height: view.frame.height - tableView.frame.origin.y)
            
            view.addSubview(searchResultTableView)
            searchResultTableView.tag = 100
            searchResultTableView.isScrollEnabled = true
        }
        filteredDataRegioni = searchText.isEmpty ? regioniArray : regioniArray.filter { (item) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.denominazioneRegione.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
        }
        filteredDataProvincie = searchText.isEmpty ? provinceArray : provinceArray.filter { (item) -> Bool in
            // If dataItem matches the searchText, return true to include it
            return item.denominazioneProvincia.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
            
        }
        tableView.reloadData()
    }

    
    //MARK: -TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive == false {
            return 5
        } else {
            return (filteredDataRegioni.count + filteredDataProvincie.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regioniCell") as! RegioniPiu_ColpiteTableViewCell
        if searchActive == false {
            cell.titleLabel.text = andamentoArray[indexPath.row].regione
        } else {
            if indexPath.row < filteredDataRegioni.count {
            cell.titleLabel.text = (filteredDataRegioni[indexPath.row] as! Regioni).denominazioneRegione
            } else {
                cell.titleLabel.text = (filteredDataProvincie[indexPath.row - filteredDataRegioni.count] as! Province).denominazioneProvincia
            }
        }
        return cell
    }
}

