//
//  DatiAppenaAggiuntiViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 05/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class DatiAppenaAggiuntiViewController: UIViewController {

    @IBAction func okButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "aggiungiDati") as! AggiungiDatiViewController
        self.dismiss(animated: true, completion: {
            vc.ok = true
            //vc.dismissVc()
            vc.viewDidLoad()
        })
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
