//
//  GraficiViewController.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 08/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import Charts

class GraficiViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var grafico1Label: UILabel!
    @IBOutlet weak var grefico1View: LineChartView!
    @IBOutlet weak var grafico1Button: UIButton!
    
    @IBOutlet weak var grafico2Label: UILabel!
    @IBOutlet weak var grafico2View: LineChartView!
    @IBOutlet weak var grafico2Button: UIButton!
    
    @IBOutlet weak var grafico3Label: UILabel!
    @IBOutlet weak var grefico3View: LineChartView!
    @IBOutlet weak var grafico3Button: UIButton!
    
    let dbc = DBController.shared
    var arrayDataForGrafici : [(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayDataForGrafici = dbc.getArrayAndamentoPerGrafico()
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
