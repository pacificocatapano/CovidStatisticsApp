//
//  InfoRegioniProvinceViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class InfoRegioniProvinceViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    

    @IBOutlet weak var searchBarInfoRegioniProvince: UISearchBar!
    @IBOutlet weak var newData: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newData.layer.cornerRadius = 10
        searchBarInfoRegioniProvince.delegate = self
        
        searchBarInfoRegioniProvince.addDoneButton(title: "Close", target: self, selector: #selector(tapDone(sender:)))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc func tapDone(sender: Any) {
        searchBarInfoRegioniProvince.text = ""
        self.view.endEditing(true)
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        searchBarInfoRegioniProvince.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Do some search stuff
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    
}

