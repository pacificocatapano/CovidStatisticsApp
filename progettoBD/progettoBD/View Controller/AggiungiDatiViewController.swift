//
//  AggiungiDatiViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class AggiungiDatiViewController: UIViewController {


    @IBAction func segmentedAction(_ sender: Any) {
        let getIndex = segmentedControl.selectedSegmentIndex
        print ("index segmented control ")
        print (getIndex)
        switch getIndex {
        case 0:
            selectRegionProvince.text = "Seleziona regioni"
        case 1:
            selectRegionProvince.text = "Seleziona province"
        default:
            print("Error segmented control")
        }
    }
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var selectRegionProvince: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
        
}
