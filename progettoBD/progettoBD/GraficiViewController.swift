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
    var datiVariazione:[(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        grafico1Label.text = "Andamento Pandemia"
        grafico2Label.text = "Variazione Giornaliera"
        grafico3Label.text = "Rapporto Tamponi/Contagi"
        
        arrayDataForGrafici = dbc.getArrayAndamentoPerGrafico()
        
        
        
        regioni = dbc.getRegioni()
           contagio = dbc.getContagio()
           andamento = dbc.getAndamento()
           province = dbc.getProvincie()
           dateArray = dbc.getDataArray()
         
        dateToShow = dateArray.last!
        checkAllRegion(selectedDate: dateToShow)
        datiVariazione = variazione()

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
        
        grafico1Button.tintColor = ColorManager.mainRedColor
        grafico2Button.tintColor = ColorManager.mainRedColor
        grafico3Button.tintColor = ColorManager.mainRedColor
        
        grafico1Button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50).cgColor
        grafico1Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        grafico1Button.layer.shadowOpacity = 6.0
        grafico1Button.layer.shadowRadius = 10.0
        grafico1Button.layer.masksToBounds = false
        
        grafico2Button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50).cgColor
        grafico2Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        grafico2Button.layer.shadowOpacity = 6.0
        grafico2Button.layer.shadowRadius = 10.0
        grafico2Button.layer.masksToBounds = false

        grafico3Button.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.50).cgColor
        grafico3Button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        grafico3Button.layer.shadowOpacity = 6.0
        grafico3Button.layer.shadowRadius = 10.0
        grafico3Button.layer.masksToBounds = false

        
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
        grafico1View.animate(xAxisDuration: 2.0, easingOption: .linear)

        
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
        grafico2View.animate(xAxisDuration: 2.0, easingOption: .linear)
        
        //aggiungere dati al grafico
        let dataGraph = LineChartData()
        dataGraph.addDataSet(lineDeltaAttPos())
        dataGraph.addDataSet(lineDeltaCasiTotali())
        dataGraph.addDataSet(lineDeltaGuariti())
        dataGraph.addDataSet(lineDeltaDecessi())
        
        dataGraph.setDrawValues(false)
        grafico2View.data = dataGraph
        
    }
    
    func createGrafico3() {
        //impostazioni grafico
        grafico3View.noDataText = "No data available"
        grafico3View.rightAxis.enabled = false
        grafico3View.backgroundColor = UIColor.white
        grafico3View.gridBackgroundColor = UIColor.white
        grafico3View.xAxis.labelPosition = .bottom
        grafico3View.xAxis.setLabelCount(5, force: false)
        grafico3View.animate(xAxisDuration: 4.0, easingOption: .linear)
        
        //aggiungere dati al grafico
        let dataGraph = BarChartData()
        dataGraph.addDataSet(barTamponi())
        dataGraph.addDataSet(barNuoviContagi())
        dataGraph.setDrawValues(false)
        grafico3View.data = dataGraph
        
    }
    
    
        func lineCasiTotali() -> LineChartDataSet{
           var dataEntries: [ChartDataEntry] = []
           var valuesY : [Int] = []
           for and in arrayDataForGrafici where and.0 <= dateToShow {
               valuesY.append(Int(and.1))
           }
           let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
           for i in 0..<dateArray.count-ricorsion + 1 {
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
           for and in arrayDataForGrafici where and.0 <= dateToShow {
               valuesY.append(Int(and.8))
           }
           let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
           for i in 0..<dateArray.count-ricorsion + 1 {
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
              for and in arrayDataForGrafici where and.0 <= dateToShow {
                  valuesY.append(Int(and.3))
              }
              let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
              for i in 0..<dateArray.count-ricorsion + 1 {
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
         for and in arrayDataForGrafici where and.0 <= dateToShow {
               valuesY.append(Int(and.2))
           }
           let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
           for i in 0..<dateArray.count-ricorsion + 1 {
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
        
      for and in datiVariazione where and.0 <= dateToShow {
        valuesY.append(Int(and.8))
        }
        let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
        for i in 0..<dateArray.count-ricorsion + 1 {
             let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
             dataEntries.append(dataEntry)
         }
        
        let DeltaAttPosLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "∆ Attualmente positivi")
       DeltaAttPosLineChartDataSet.colors = [ColorManager.lighterRed]
       DeltaAttPosLineChartDataSet.lineWidth = 3
       DeltaAttPosLineChartDataSet.drawCirclesEnabled = false
       DeltaAttPosLineChartDataSet.mode = .cubicBezier
     
        return DeltaAttPosLineChartDataSet
    }
    
    func lineDeltaCasiTotali() -> LineChartDataSet{
        var dataEntries: [ChartDataEntry] = []
        var valuesY : [Int] = []
        
      for and in datiVariazione where and.0 <= dateToShow {
        valuesY.append(Int(and.1))
        }
        let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
        for i in 0..<dateArray.count-ricorsion + 1 {
             let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
             dataEntries.append(dataEntry)
         }
        let DeltaCasiTotaliLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "∆ Casi totali")
       DeltaCasiTotaliLineChartDataSet.colors = [ColorManager.mainRedColor]
       DeltaCasiTotaliLineChartDataSet.lineWidth = 3
       DeltaCasiTotaliLineChartDataSet.drawCirclesEnabled = false
       DeltaCasiTotaliLineChartDataSet.mode = .cubicBezier
        return DeltaCasiTotaliLineChartDataSet
    }
    
    func lineDeltaGuariti() -> LineChartDataSet{
        var dataEntries: [ChartDataEntry] = []
        var valuesY : [Int] = []
        
      for and in datiVariazione where and.0 <= dateToShow {
        valuesY.append(Int(and.2))
        }
        let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
        for i in 0..<dateArray.count-ricorsion + 1 {
             let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
             dataEntries.append(dataEntry)
         }
        let DeltaGuaritiLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "∆ Guariti")
       DeltaGuaritiLineChartDataSet.colors = [ColorManager.green]
       DeltaGuaritiLineChartDataSet.lineWidth = 3
       DeltaGuaritiLineChartDataSet.drawCirclesEnabled = false
       DeltaGuaritiLineChartDataSet.mode = .cubicBezier
        return DeltaGuaritiLineChartDataSet
    }
    
    func lineDeltaDecessi() -> LineChartDataSet{
        var dataEntries: [ChartDataEntry] = []
        var valuesY : [Int] = []
        
      for and in datiVariazione where and.0 <= dateToShow {
        valuesY.append(Int(and.3))
        }
        let valuesX : [Int] = Array(1...dateArray.count-ricorsion + 1)
        for i in 0..<dateArray.count-ricorsion + 1 {
             let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
             dataEntries.append(dataEntry)
         }
        let DeltaDecessiLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "∆ Decessi")
       DeltaDecessiLineChartDataSet.colors = [ColorManager.black]
       DeltaDecessiLineChartDataSet.lineWidth = 3
       DeltaDecessiLineChartDataSet.drawCirclesEnabled = false
       DeltaDecessiLineChartDataSet.mode = .cubicBezier
        return DeltaDecessiLineChartDataSet
    }
    
    
    func barNuoviContagi() -> BarChartDataSet{
        var dataEntries: [BarChartDataEntry] = []
        var valuesY : [Int] = []
        for and in arrayDataForGrafici where and.0 <= dateToShow {
            valuesY.append(Int(and.8))
        }
        let valuesX : [Int] = Array(Array(1...dateArray.count-ricorsion + 1))
         for i in 0..<dateArray.count - ricorsion + 1 {
              let dataEntry = BarChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
              dataEntries.append(dataEntry)
          }
        let nuoviContagiBarChartDataSet = BarChartDataSet(entries: dataEntries, label: "Totale positivi")
        nuoviContagiBarChartDataSet.colors = [ColorManager.lighterRed]
        nuoviContagiBarChartDataSet.barBorderWidth = 0.5
        return nuoviContagiBarChartDataSet
    }
    
    func barTamponi() -> BarChartDataSet{
        var dataEntries: [BarChartDataEntry] = []
        var valuesY : [Int] = []
        for and in arrayDataForGrafici where and.0 <= dateToShow {
            valuesY.append(Int(and.7))
        }
        let valuesX : [Int] = Array(Array(1...dateArray.count-ricorsion + 1))
        for i in 0..<dateArray.count - ricorsion + 1 {
             let dataEntry = BarChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
             dataEntries.append(dataEntry)
         }
        let nuoviContagiBarChartDataSet = BarChartDataSet(entries: dataEntries, label: "Tamponi effettuati")
        nuoviContagiBarChartDataSet.colors = [ColorManager.grey]
        nuoviContagiBarChartDataSet.barBorderWidth = 0.5
        return nuoviContagiBarChartDataSet
    }
    
    
//MARK: -VARIAZIONI
    func variazione() -> [(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)]{
        var result: [(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)] = []
        var previousIndex = -1
        for and in arrayDataForGrafici {
            if previousIndex == -1{
                result.append(and)
                previousIndex += 1
            }else{
                var toAppend: (Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64) = arrayDataForGrafici[previousIndex]
                let dateDifference = and.0.interval(ofComponent: .day, fromDate: toAppend.0)
                let newData = Calendar.current.date(byAdding: .day, value: dateDifference, to: toAppend.0)
                toAppend = (newData, and.1 - toAppend.1, and.2 - toAppend.2,and.3-toAppend.3, and.4 - toAppend.4, and.5 - toAppend.5,and.6-toAppend.6, and.7 - toAppend.7, and.8 - toAppend.8) as! (Date, Int64, Int64, Int64, Int64, Int64, Int64, Int64, Int64)
                result.append(toAppend)
                previousIndex += 1
            }
        }
        return result
    }
    
}
