//
//  InfoRegioniProvinceViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class InfoRegioniProvinceViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var searchBarInfoRegioniProvince: UISearchBar!
    @IBOutlet weak var newData: UIButton!
    
    let dbc = DBController.shared
    var regioni : [Regioni] = []
    var contagio : [Contagio] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newData.layer.cornerRadius = 10
        searchBarInfoRegioniProvince.delegate = self
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Do some search stuff
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarInfoRegioniProvince.text = ""
        searchBarInfoRegioniProvince.endEditing(true)
    }
    
}

