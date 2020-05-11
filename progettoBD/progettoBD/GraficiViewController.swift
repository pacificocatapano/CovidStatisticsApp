//
//  GraficiViewController.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 08/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import Charts
import SQLite

class GraficiViewController: UIViewController {

    @IBAction func grafico1ZoomOut(_ sender: Any) {
        grafico1View.zoomOut()
    }
    @IBAction func grafico2ZoomOut(_ sender: Any) {
        grafico2View.zoomOut()
    }
    @IBAction func grafico3ZoomOut(_ sender: Any) {
        grafico3View.zoomOut()
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var grafico1Label: UILabel!
    @IBOutlet weak var grafico1View: LineChartView!
    @IBOutlet weak var grafico1Button: UIButton!
    
    @IBOutlet weak var grafico2Label: UILabel!
    @IBOutlet weak var grafico2View: LineChartView!
    @IBOutlet weak var grafico2Button: UIButton!
    
    @IBOutlet weak var grafico3Label: UILabel!
    @IBOutlet weak var grafico3View: LineChartView!
    @IBOutlet weak var grafico3Button: UIButton!
    
    let dbc = DBController.shared
    var arrayDataForGrafici : [(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)] = []
    
    var regioni : [Regioni] = []
    var contagio : [Contagio] = []
    var andamento : [Andamento] = []
    var province : [Province] = []
    var options: [Option]!
    var dateArray : [Date] = []
    var dateToShow = Date()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grafico1Label.text = "Andamento Epidemia"
        grafico2Label.text = "Variazione Dati"
        grafico3Label.text = "Rapporto Tamponi/Contagi"
        
        arrayDataForGrafici = dbc.getArrayAndamentoPerGrafico()
        
        
        
        regioni = dbc.getRegioni()
           contagio = dbc.getContagio()
           andamento = dbc.getAndamento()
           province = dbc.getProvincie()
           dateArray = dbc.getDataArray()
         
        dateToShow = dateArray.last!
        
        checkAllRegion(selectedDate: dateToShow)
        
           createGrafico1()
           grafico1View.doubleTapToZoomEnabled = true
           grafico1View.drawGridBackgroundEnabled = true
           grafico1View.pinchZoomEnabled = true
           
           createGrafico2()
           grafico2View.doubleTapToZoomEnabled = true
           grafico2View.drawGridBackgroundEnabled = true
           grafico2View.pinchZoomEnabled = true
        
        createGrafico3()
        grafico3View.doubleTapToZoomEnabled = true
        grafico3View.drawGridBackgroundEnabled = true
        grafico3View.pinchZoomEnabled = true
        
    }
    
    
   var exit = false
   var ricorsion = 1
    
    //MARK: - Controlla se nel giorno indicato sono presenti i dati di tutte le regioni, se non lo sono, combia giorno fin quando non trova quello con tutti i dati
    func checkAllRegion(selectedDate : Date) {
        if exit == true {
            return
        } else {
            var result = 0
            for and in andamento where and.data == selectedDate {
                result += 1
            }
            if result != 21 {
                ricorsion += 1
                checkAllRegion(selectedDate: dateArray[dateArray.count - ricorsion])
            } else {
                exit = true
                dateToShow = selectedDate
            }
        }
        
    }
    
    //MARK: -Grafico
    func createGrafico1() {
        //impostazioni grafico
        grafico1View.noDataText = "No data available"
        grafico1View.rightAxis.enabled = false
        grafico1View.backgroundColor = UIColor.white
        grafico1View.gridBackgroundColor = UIColor.white
        grafico1View.xAxis.labelPosition = .bottom
        grafico1View.xAxis.setLabelCount(5, force: false)
        grafico1View.animate(xAxisDuration: 3.0, easingOption: .linear)

        
        //aggiungere dati al grafico
        let dataGraph = LineChartData()
        
        dataGraph.addDataSet(lineCasiTotali())
        dataGraph.addDataSet(lineAttualmentePositivi())
        dataGraph.addDataSet(lineGuariti())
        dataGraph.addDataSet(lineDecessi())
        
        dataGraph.setDrawValues(false)
        grafico1View.data = dataGraph
        
    }
    
    func createGrafico2() {
        //impostazioni grafico
        grafico2View.noDataText = "No data available"
        grafico2View.rightAxis.enabled = false
        grafico2View.backgroundColor = UIColor.white
        grafico2View.gridBackgroundColor = UIColor.white
        grafico2View.xAxis.labelPosition = .bottom
        grafico2View.xAxis.setLabelCount(5, force: false)
        grafico2View.animate(xAxisDuration: 3.0, easingOption: .linear)
        
        //aggiungere dati al grafico
        let dataGraph = LineChartData()
        
        
        dataGraph.setDrawValues(false)
        grafico2View.data = dataGraph
        
    }
    
    func createGrafico3() {
        //impostazioni grafico
        grafico3View.noDataText = "No data available"
        grafico3View.rightAxis.enabled = false
        grafico3View.backgroundColor = UIColor.white
        //grafico3View.gridBackgroundColor = UIColor.white
        grafico3View.xAxis.labelPosition = .bottom
       //grafico3View.xAxis.setLabelCount(5, force: false)
        
        //aggiungere dati al grafico
        let dataGraph = BarChartData()
        
        dataGraph.addDataSet(barNuoviContagi())
        dataGraph.setDrawValues(false)
        grafico3View.data = dataGraph
        
    }
    
    
        func lineCasiTotali() -> LineChartDataSet{
           var dataEntries: [ChartDataEntry] = []
           var valuesY : [Int] = []
           for and in dbc.getArrayAndamentoPerGrafico() where and.0 <= dateToShow {
               valuesY.append(Int(and.1))
           }
           let valuesX : [Int] = Array(0...dateArray.count-ricorsion)
           for i in 0..<dateArray.count-ricorsion {
               let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
               dataEntries.append(dataEntry)
           }
           
           let CasiTotaliLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Casi Totali")
          CasiTotaliLineChartDataSet.colors = [ColorManager.mainRedColor]
          CasiTotaliLineChartDataSet.lineWidth = 3
          CasiTotaliLineChartDataSet.drawCirclesEnabled = false
          CasiTotaliLineChartDataSet.mode = .cubicBezier
           
           return CasiTotaliLineChartDataSet
       }
       
       func lineAttualmentePositivi() -> LineChartDataSet{
           var dataEntries: [ChartDataEntry] = []
           var valuesY : [Int] = []
           for and in dbc.getArrayAndamentoPerGrafico() where and.0 <= dateToShow {
               valuesY.append(Int(and.8))
           }
           let valuesX : [Int] = Array(0...dateArray.count-ricorsion)
            for i in 0..<dateArray.count-ricorsion {
                 let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
                 dataEntries.append(dataEntry)
             }
           
           let attualmentePositiviLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Attualmente Positivi")
          attualmentePositiviLineChartDataSet.colors = [ColorManager.lighterRed]
          attualmentePositiviLineChartDataSet.lineWidth = 3
          attualmentePositiviLineChartDataSet.drawCirclesEnabled = false
          attualmentePositiviLineChartDataSet.mode = .cubicBezier
           
           return attualmentePositiviLineChartDataSet
       }
       
       func lineGuariti() -> LineChartDataSet{
              var dataEntries: [ChartDataEntry] = []
              var valuesY : [Int] = []
              for and in dbc.getArrayAndamentoPerGrafico() where and.0 <= dateToShow {
                  valuesY.append(Int(and.3))
              }
              let valuesX : [Int] = Array(0...dateArray.count-ricorsion)
               for i in 0..<dateArray.count-ricorsion {
                    let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
                    dataEntries.append(dataEntry)
                }
              
              let guaritiLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Guariti")
             guaritiLineChartDataSet.colors = [ColorManager.green]
             guaritiLineChartDataSet.lineWidth = 3
             guaritiLineChartDataSet.drawCirclesEnabled = false
             guaritiLineChartDataSet.mode = .cubicBezier
           
              return guaritiLineChartDataSet
          }
       
       func lineDecessi() -> LineChartDataSet{
           var dataEntries: [ChartDataEntry] = []
           var valuesY : [Int] = []
         for and in dbc.getArrayAndamentoPerGrafico() where and.0 <= dateToShow {
               valuesY.append(Int(and.2))
           }
           let valuesX : [Int] = Array(0...dateArray.count-ricorsion)
            for i in 0..<dateArray.count-ricorsion {
                 let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
                 dataEntries.append(dataEntry)
             }
           
           let decessiLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Decessi")
          decessiLineChartDataSet.colors = [ColorManager.black]
          decessiLineChartDataSet.lineWidth = 3
          decessiLineChartDataSet.drawCirclesEnabled = false
          decessiLineChartDataSet.mode = .cubicBezier
        
           return decessiLineChartDataSet
       }
    
    func lineDeltaAttPos() -> LineChartDataSet{
        var dataEntries: [ChartDataEntry] = []
        var valuesY : [Int] = []
    //MANCANTE QUERY VARIAZIONE
      for and in dbc.getArrayAndamentoPerGrafico() where and.0 <= dateToShow {
            valuesY.append(Int(and.2))
        }
        let valuesX : [Int] = Array(0...dateArray.count-ricorsion)
         for i in 0..<dateArray.count-ricorsion {
              let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
              dataEntries.append(dataEntry)
          }
        
        let DeltaAttPosLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Decessi")
       DeltaAttPosLineChartDataSet.colors = [ColorManager.black]
       DeltaAttPosLineChartDataSet.lineWidth = 3
       DeltaAttPosLineChartDataSet.drawCirclesEnabled = false
       DeltaAttPosLineChartDataSet.mode = .cubicBezier
     
        return DeltaAttPosLineChartDataSet
    }
    
    func barNuoviContagi() -> BarChartDataSet{
        //NON FUNZIONA
        var dataEntries: [BarChartDataEntry] = []
        var valuesY : [Int] = []
        for and in dbc.getArrayAndamentoPerGrafico() where and.0 <= dateToShow {
            valuesY.append(Int(and.1))
        }
        let valuesX : [Int] = Array(0...dateArray.count-ricorsion)
         for i in 0..<dateArray.count-ricorsion {
              let dataEntry = BarChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
              dataEntries.append(dataEntry)
          }
        
        
        let nuoviContagiBarChartDataSet = BarChartDataSet(entries: dataEntries, label: "Nuovi Contagi")
       nuoviContagiBarChartDataSet.colors = [ColorManager.lighterRed]
        nuoviContagiBarChartDataSet.barBorderWidth = 0.2
        print(valuesX)
        return nuoviContagiBarChartDataSet
    }
    
}
