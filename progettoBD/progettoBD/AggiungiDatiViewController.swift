//
//  AggiungiDatiViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit


class AggiungiDatiViewController: UIViewController {
var ok = false
/*
    @IBAction func confirmButton(_ sender: Any) {
        performSegue(withIdentifier: "", sender: nil)
    }
 */
    
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

//******START TEXT FIELDS ******
    @IBOutlet weak var decessiTextField: UITextField!
    @IBOutlet weak var guaritiTextField: UITextField!
    @IBOutlet weak var selezionaRegioneTextField: UITextField!
    @IBOutlet weak var dataTextField: UITextField!
    @IBOutlet weak var attualmentePositiviTextField: UITextField!
    @IBOutlet weak var casiTotaliTextField: UITextField!
//****END TEXT FIELDS ****
 
/*
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier = "" {
            
        }
    }
 */
    override func viewDidLoad() {
        super.viewDidLoad()
        //dismissVc()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
/*
    func dismissVc (){
        if ok == true {
            self.dismiss(animated: true, completion: nil)
        }
    }
 */
    
}
