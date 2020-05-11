//
//  InfoRegioniProvinceViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
class InfoRegioniProvinceViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource {

    let dbc = DBController.shared
    var andamentoArray: [Andamento] = []
    var regioniArray :[Regioni] = []
    var provinceArray : [Province] = []
    var dateArray : [Date] = []
    var regioniPiùColpite : [RegioniEAndamento] = []
    var filteredDataRegioni : [Any] = []
    var filteredDataProvincie : [Any] = []
    
    @IBOutlet weak var newData: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var addDataButton: UIButton!
    
    let searchResultTableView = UITableView()
    var tableViewWidth : CGFloat = 0
    var tableViewHeight : CGFloat = 0
    
    var dataToPass : (Bool, Any) = (true, 0)
    
    var dateToShow : Date = Date()
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        addDataButton.backgroundColor = ColorManager.mainRedColor
        
        andamentoArray = dbc.getAndamento()
        regioniArray = dbc.getRegioni()
        for prov in dbc.getProvincie() where prov.denominazioneProvincia != "In fase di definizione/aggiornamento" {
            provinceArray.append(prov)
        }
        dateArray = dbc.getDataArray()
        
         dateToShow = dateArray.last!
        
        chekAllRegione(selectedDate: dateToShow)
        
        
        for and in andamentoArray where and.data == dateToShow {
            regioniPiùColpite.append(RegioniEAndamento(regione: and.regione, contagiTotali: and.contagi))
        }
        
        //MARK: Ordinamento tramite QUERY
        regioniPiùColpite = regioniPiùColpite.sorted(by: { (img0: RegioniEAndamento, img1: RegioniEAndamento) -> Bool in
            return img0.contagiTotali > img1.contagiTotali //MARK: Ordinamneto decrescente, se si vuole il crescente basta mettere <
        })
        
        newData.layer.cornerRadius = 10
        
        searchResultTableView.delegate = self
        searchResultTableView.dataSource = self
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView() //Rimuove le celle vuote della tableView
        tableView.isScrollEnabled = true
        setupSearchBar()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        navigationController?.navigationItem.title = ""
    }
    
    var exit = false
    var ricorsion = 1
    
    func chekAllRegione(selectedDate : Date) {
    if exit == true {
        return
    } else {
        var result = 0
        for and in andamentoArray where and.data == selectedDate {
            result += 1
        }
        if result != 21 {
            ricorsion += 1
            chekAllRegione(selectedDate: dateArray[dateArray.count - ricorsion])
        } else {
            exit = true
            dateToShow = selectedDate
        }
    }
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
        newData.isHidden = false
        label.text = "Le 5 Regioni con più contagi"
        label.adjustsFontSizeToFitWidth = true
        tableView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupSearchBar(){
        searchController.searchBar.delegate = self
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.keyboardAppearance = .light
        searchController.searchBar.tintColor = ColorManager.mainRedColor
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.dimsBackgroundDuringPresentation = false
        self.searchController.obscuresBackgroundDuringPresentation = false
        searchController.definesPresentationContext = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        label.text = "Risultati ricerca"
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
            if regioniPiùColpite.count < 5 {
                return regioniPiùColpite.count
            }
            return 5
        } else {
            return (filteredDataRegioni.count + filteredDataProvincie.count)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "regioniCell") as! RegioniPiu_ColpiteTableViewCell
        if searchActive == false {
            cell.titleLabel.text = regioniPiùColpite[indexPath.row].regione
        } else {
            if indexPath.row < filteredDataRegioni.count {
            cell.titleLabel.text = (filteredDataRegioni[indexPath.row] as! Regioni).denominazioneRegione
            } else {
                if (filteredDataProvincie[indexPath.row - filteredDataRegioni.count] as! Province).denominazioneProvincia.lowercased() != "in fase di definizione/aggiornamento"{
                cell.titleLabel.text = (filteredDataProvincie[indexPath.row - filteredDataRegioni.count] as! Province).denominazioneProvincia
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if searchActive == false {
            let selectedItem = regioniPiùColpite[indexPath.row]
            dataToPass = (true, getRegioneData(regioneName: selectedItem.regione))
            self.performSegue(withIdentifier: "ShowInfoRegione", sender: self)
            tableView.deselectRow(at: indexPath, animated: true)
        } else {
            if indexPath.row < filteredDataRegioni.count {
                let selectedItem = (filteredDataRegioni[indexPath.row] as! Regioni)
                dataToPass = (true, selectedItem)
                self.performSegue(withIdentifier: "ShowInfoRegione", sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
            } else {
                let selectedItem = (filteredDataProvincie[indexPath.row - filteredDataRegioni.count] as! Province)
                dataToPass = (false, selectedItem)
                self.performSegue(withIdentifier: "ShowInfoProvincia", sender: self)
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowInfoRegione" {
            let controller = segue.destination as! DettagliRegioneProviciaViewController
            //controller.editButton.isEnabled = false
            controller.dataToSet = dataToPass
            controller.regioniArray = regioniArray
            controller.andamentoArray = andamentoArray
            controller.navBar.title = (dataToPass.1 as! Regioni).denominazioneRegione
        } else if segue.identifier == "AddData" {
            let controller = segue.destination as! AggiungiDatiViewController
            controller.regioniArray = regioniArray
            controller.provinceArray = provinceArray
        } else if segue.identifier == "ShowInfoProvincia" {
            let controller = segue.destination as! ShowDatiProvinciaViewController
            controller.provinciaSelezionata = dataToPass.1 as! Province
        }
    }
    
    func getRegioneData (regioneName: String) -> Regioni {
        for reg in regioniArray where reg.denominazioneRegione == regioneName {
            return reg
        }
        return Regioni()
    }

    //MARK: - Non serve più, fatta da query
    func getRegioniPiùColpite() -> [RegioniEAndamento] {
        var result : [RegioniEAndamento] = []
        
        for reg in regioniArray {
            var sum = 0
            for and in andamentoArray where and.regione == reg.denominazioneRegione {
                sum += and.contagi
            }
            result.append(RegioniEAndamento(regione: reg.denominazioneRegione, contagiTotali: sum))
        }
        
        return result
    }
}

