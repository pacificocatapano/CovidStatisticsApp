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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newData.layer.cornerRadius = 10
        searchBarInfoRegioniProvince.delegate = self
        
        searchBarInfoRegioniProvince.addDoneButton(title: "Close", target: self, selector: #selector(tapDone(sender:)))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
        self.view.addGestureRecognizer(tapGesture)
        
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

    
}

