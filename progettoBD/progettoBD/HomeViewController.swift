//
//  HomeViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 30/04/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import SQLite

class HomeViewController: UIViewController {

    
    @IBOutlet weak var HomeScrollView: UIScrollView!
    
    let dbc = DBController.shared
    var regioni : [Regioni] = []
    var contagio : [Contagio] = []
    var andamento : [Andamento] = []
    var province : [Province] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regioni = dbc.getRegioni()
        contagio = dbc.getContagio()
        andamento = dbc.getAndamento()
        province = dbc.getProvincie()
        
        let result = attualmentePositivi()
        
        print(result)
    }
    
    func attualmentePositivi() -> Int {
        var result = 0
        let lastDate = dbc.getUltimaData()
        
        print(lastDate)
        
        for and in andamento where and.data == lastDate {
            result += and.totalePositivi
        }
        return result
    }
    
}
