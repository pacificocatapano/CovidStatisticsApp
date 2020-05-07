//
//  HomeViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 30/04/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import SQLite
import Charts


//MARK: - Grafico opzioni fuori dalla classe
enum Option {
    case toggleValues
    case toggleIcons
    case toggleHighlight
    case animateX
    case animateY
    case animateXY
    case saveToGallery
    case togglePinchZoom
    case toggleAutoScaleMinMax
    case toggleData
    case toggleBarBorders
    // CandleChart
    case toggleShadowColorSameAsCandle
    case toggleShowCandleBar
    // CombinedChart
    case toggleLineValues
    case toggleBarValues
    case removeDataSet
    // CubicLineSampleFillFormatter
    case toggleFilled
    case toggleCircles
    case toggleCubic
    case toggleHorizontalCubic
    case toggleStepped
    // HalfPieChartController
    case toggleXValues
    case togglePercent
    case toggleHole
    case spin
    case drawCenter
    // RadarChart
    case toggleXLabels
    case toggleYLabels
    case toggleRotate
    case toggleHighlightCircle
    
    var label: String {
        switch self {
        case .toggleValues: return "Toggle Y-Values"
        case .toggleIcons: return "Toggle Icons"
        case .toggleHighlight: return "Toggle Highlight"
        case .animateX: return "Animate X"
        case .animateY: return "Animate Y"
        case .animateXY: return "Animate XY"
        case .saveToGallery: return "Save to Camera Roll"
        case .togglePinchZoom: return "Toggle PinchZoom"
        case .toggleAutoScaleMinMax: return "Toggle auto scale min/max"
        case .toggleData: return "Toggle Data"
        case .toggleBarBorders: return "Toggle Bar Borders"
        // CandleChart
        case .toggleShadowColorSameAsCandle: return "Toggle shadow same color"
        case .toggleShowCandleBar: return "Toggle show candle bar"
        // CombinedChart
        case .toggleLineValues: return "Toggle Line Values"
        case .toggleBarValues: return "Toggle Bar Values"
        case .removeDataSet: return "Remove Random Set"
        // CubicLineSampleFillFormatter
        case .toggleFilled: return "Toggle Filled"
        case .toggleCircles: return "Toggle Circles"
        case .toggleCubic: return "Toggle Cubic"
        case .toggleHorizontalCubic: return "Toggle Horizontal Cubic"
        case .toggleStepped: return "Toggle Stepped"
        // HalfPieChartController
        case .toggleXValues: return "Toggle X-Values"
        case .togglePercent: return "Toggle Percent"
        case .toggleHole: return "Toggle Hole"
        case .spin: return "Spin"
        case .drawCenter: return "Draw CenterText"
        // RadarChart
        case .toggleXLabels: return "Toggle X-Labels"
        case .toggleYLabels: return "Toggle Y-Labels"
        case .toggleRotate: return "Toggle Rotate"
        case .toggleHighlightCircle: return "Toggle highlight circle"
        }
    }
}
//FINE OPZIONI GRAFICO

class HomeViewController: UIViewController, ChartViewDelegate {

    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var numeroPositivi: UILabel!
    @IBOutlet weak var variazionePositivi: UILabel!
    @IBOutlet weak var numeroCasiTotali: UILabel!
    @IBOutlet weak var variazioneCasiTotali: UILabel!
    @IBOutlet weak var numeroDecessi: UILabel!
    @IBOutlet weak var variazioneDecessi: UILabel!
    @IBOutlet weak var numeroGuariti: UILabel!
    @IBOutlet weak var variazioneGuariti: UILabel!
    @IBOutlet weak var grafico: LineChartView!
    
    @IBOutlet weak var HomeScrollView: UIScrollView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    
    var dataPicker = UIDatePicker()
    
    let dbc = DBController.shared
    var regioni : [Regioni] = []
    var contagio : [Contagio] = []
    var andamento : [Andamento] = []
    var province : [Province] = []
    var dateArray : [Date] = []
    var options: [Option]!
    
    var dateToShow = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        regioni = dbc.getRegioni()
        contagio = dbc.getContagio()
        andamento = dbc.getAndamento()
        province = dbc.getProvincie()
        dateArray = dbc.getDataArray()
        
        createChart()
        grafico.pinchZoomEnabled = false
        grafico.doubleTapToZoomEnabled = false
        grafico.drawGridBackgroundEnabled = true
        
        dateToShow = dateArray.last!
        navigationController?.navigationBar.prefersLargeTitles = true
        labelPositivi(selectedDate: dateToShow)
        labelCasiTotali(selectedDate: dateToShow)
        labelDecessi(selectedDate: dateToShow)
        labelGuariti(selectedDate: dateToShow)
       /*
        setDataCount(dateArray.count, range: UInt32(dbc.getMaxContagio() + 100))
        updateSetData()*/
    }
    
    //MARK: - AttualmentePositivi
    func labelPositivi(selectedDate: Date){
        numeroPositivi.text = "\(Int(attualmentePositivi(selectedDate: selectedDate)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneAttualmentePositivi(selectedDate: selectedDate))
        let variazioneNumericaAttualmentePositivi : Int = Int(attualmentePositivi(selectedDate: selectedDate) - attualmentePositivi(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!))
        if variazioneAttualmentePositivi(selectedDate: selectedDate) > 0 {
            variazionePositivi.text = "+\(variazioneNumericaAttualmentePositivi)  (+\(deltaPositivi)%)"
        } else {
            variazionePositivi.text = "\(variazioneNumericaAttualmentePositivi)  (\(deltaPositivi)%)"
        }
    }
    
    func attualmentePositivi(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate {
            result += Float(and.totalePositivi)
        }
        return result
    }
    
    func variazioneAttualmentePositivi(selectedDate: Date) -> Float {
        var result: Float = 0
        let attPositivi = attualmentePositivi(selectedDate: selectedDate)
        if selectedDate == dateArray.first {
            result = attualmentePositivi(selectedDate: selectedDate)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - 2]
        let positiviGiornoPrima = attualmentePositivi(selectedDate: giornoPrima)
    
        result = (((attPositivi - positiviGiornoPrima) * 100)/( positiviGiornoPrima ))
        return result
    }
    //END******************************************************
    
    //MARK: - CasiTotali
    func labelCasiTotali( selectedDate : Date){
        numeroCasiTotali.text = "\(Int(casiTotali(selectedDate: selectedDate)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneCasiTotali(selectedDate: selectedDate))
        let variazioneNumericaCasiTotali: Int = Int(casiTotali(selectedDate: selectedDate) - casiTotali(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!))
        if variazioneCasiTotali(selectedDate: selectedDate) > 0 {
            variazioneCasiTotali.text = "+\(variazioneNumericaCasiTotali)  (+\(deltaPositivi)%)"
        } else {
            variazionePositivi.text = "\(variazioneNumericaCasiTotali)  (\(deltaPositivi)%)"
        }
    }
    
    func casiTotali(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate {
            result += Float(and.contagi)
        }
        return result
    }
    
    func variazioneCasiTotali(selectedDate: Date) -> Float {
        var result: Float = 0
        let casiTotaliOggi = casiTotali(selectedDate: selectedDate)
        if selectedDate == dateArray.first {
            result = casiTotali(selectedDate: selectedDate)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - 2]
        let casiTotaliGiornoPrima = casiTotali(selectedDate: giornoPrima)
    
        result = (((casiTotaliOggi - casiTotaliGiornoPrima) * 100)/( casiTotaliGiornoPrima ))
        return result
    }
    //END
    
    //MARK: - Decessi Ultimo Giorno
    func labelDecessi(selectedDate : Date){
        numeroDecessi.text = "\(Int(decessi(selectedDate: selectedDate)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneDecessiFunc(selectedDate: selectedDate))
        let variazioneNumericaDecessi: Int = Int(decessi(selectedDate: selectedDate) - decessi(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!))
        
        if variazioneDecessiFunc(selectedDate: selectedDate) > 0 {
            variazioneDecessi.text = "+\(variazioneNumericaDecessi)  (+\(deltaPositivi)%)"
        } else {
            variazioneDecessi.text = "\(variazioneNumericaDecessi)  (\(deltaPositivi)%)"
        }
    }
    
    func decessi(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate {
            result += Float(and.decessi)
        }
        return result
    }
    
    func variazioneDecessiFunc(selectedDate: Date) -> Float {
        var result: Float = 0
        let oggi = decessi(selectedDate: selectedDate)
        if selectedDate == dateArray.first {
            result = decessi(selectedDate: selectedDate)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - 2]
        let ieri = decessi(selectedDate: giornoPrima)
    
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    //END
    
    //MARK: - Guariti Ultimo Giorno
    func labelGuariti(selectedDate: Date){
        numeroGuariti.text = "\(Int(guariti(selectedDate:selectedDate)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneGuaritiFunc(selectedDate: selectedDate))
        let variazioneNumericaGuariti: Int = Int(guariti(selectedDate: selectedDate) - guariti(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!))
        
        if variazioneGuaritiFunc(selectedDate: selectedDate) > 0 {
            variazioneGuariti.text = "+\(variazioneNumericaGuariti)  (+\(deltaPositivi)%)"
        } else {
            variazioneGuariti.text = "\(variazioneNumericaGuariti)  (\(deltaPositivi)%)"
        }
    }
    
    func guariti(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate {
            result += Float(and.guariti)
        }
        return result
    }
    
    func variazioneGuaritiFunc(selectedDate: Date) -> Float {
        var result: Float = 0
        let oggi = guariti(selectedDate: selectedDate)
        if selectedDate == dateArray.first {
            result = guariti(selectedDate: selectedDate)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - 2]
        let ieri = guariti(selectedDate: giornoPrima)
    
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    //END
    
    @IBAction func changeDate(_ sender: Any) {
        showCalendar()
        print("OK")
    }
    
    func showCalendar(){
        
        calendarButton.isEnabled = false
        let dismissView = UIView(frame: CGRect(x: UIScreen.main.bounds.origin.x, y: UIScreen.main.bounds.origin.y, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(dismissView)
        dismissView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dismissView.tag = 100
        let tapOutsideToDismissGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissModalView))
        dismissView.addGestureRecognizer(tapOutsideToDismissGestureRecognizer)
        dismissView.tag = 100
        
        dataPicker = UIDatePicker(frame: CGRect(x: view.frame.origin.x, y: view.frame.height*2/3, width: view.frame.width, height: view.frame.height/3))
        
        dataPicker.minimumDate = Calendar.current.date(byAdding: .day, value: -1, to: dateArray.first!)!
        dataPicker.maximumDate = Calendar.current.date(byAdding: .day, value: -1, to: dateArray.last!)!
        dataPicker.backgroundColor = UIColor.white
        dataPicker.datePickerMode = .date
        dataPicker.tag = 200
        view.addSubview(dataPicker)
        
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.barTintColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
        
        
        let toolBar = UIToolbar(frame: CGRect(x: dataPicker.frame.origin.x,
                                              y: dataPicker.frame.origin.y - dataPicker.frame.height/5,
                                              width: dataPicker.frame.width,
                                              height: dataPicker.frame.height/5))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(saveDate))//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        toolBar.tag = 300
        view.addSubview(toolBar)
    }
    
    @objc func saveDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        dateToShow = Calendar.current.date(byAdding: .day, value: 1, to: dataPicker.date)!
        
        labelDecessi(selectedDate: dateToShow)
        labelGuariti(selectedDate: dateToShow)
        labelPositivi(selectedDate: dateToShow)
        labelCasiTotali(selectedDate: dateToShow)
        
        calendarButton.isEnabled = true
        
        var dateString = "\(dateToShow)"
        let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
        dateString.removeSubrange(range)
        if dateToShow != dateArray.last {
            navBar.title = "Contagi del \(dateString)"
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        navigationController?.navigationBar.barTintColor = ColorManager.navigationBar
        tabBarController?.tabBar.isHidden = false
        view.viewWithTag(100)?.removeFromSuperview()
        view.viewWithTag(200)?.removeFromSuperview()
        view.viewWithTag(300)?.removeFromSuperview()
    }
    
    @objc func dismissModalView(){
        calendarButton.isEnabled = true
        navigationController?.navigationBar.barTintColor = ColorManager.navigationBar
        tabBarController?.tabBar.isHidden = false
        view.viewWithTag(100)?.removeFromSuperview()
        view.viewWithTag(200)?.removeFromSuperview()
        view.viewWithTag(300)?.removeFromSuperview()
    }
    
    //MARK: -Grafico
    func createChart() {
        grafico.noDataText = "No data available"
        var dataEntries: [ChartDataEntry] = []
        var valuesY : [Int] = []
        for and in andamento {
            valuesY.append(and.contagi)
        }
        var valuesX : [Int] = Array(0...dateArray.count-1)
        for i in 0..<dateArray.count-1 {
            let dataEntry = ChartDataEntry(x: Double(valuesX[i]), y: Double(valuesY[i]))
            
        dataEntries.append(dataEntry)
        }
        grafico.rightAxis.enabled = false
        grafico.backgroundColor = UIColor.white
        grafico.gridBackgroundColor = UIColor.white
        grafico.xAxis.labelPosition = .bottom
        grafico.xAxis.setLabelCount(5, force: false)
        //grafico.animate(xAxisDuration: 2.5)
        
        
        //Line Casi Totali
        let CasiTotaliLineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Casi Totali")
        CasiTotaliLineChartDataSet.colors = [ColorManager.mainRedColor]
        CasiTotaliLineChartDataSet.lineWidth = 3
        CasiTotaliLineChartDataSet.drawCirclesEnabled = false
        CasiTotaliLineChartDataSet.mode = .cubicBezier
        
        /* nel caso volessimo l'area
        CasiTotaliLineChartDataSet.fill = UIColor.white
        CasiTotaliLineChartDataSet.fillAlpha = 0.8
        CasiTotaliLineChartDataSet.drawFilledEnabled = true
        */
        
        let dataGraph = LineChartData()
        dataGraph.addDataSet(CasiTotaliLineChartDataSet)
        dataGraph.setDrawValues(false)
        grafico.data = dataGraph
        
        
        /*
        self.options = [.toggleValues,
                        .toggleFilled,
                        .toggleCircles,
                        .toggleCubic,
                        .toggleStepped,
                        .toggleHighlight,
                        .animateX,
                        .animateY,
                        .animateXY,
                        .saveToGallery,
                        .togglePinchZoom,
                        .toggleAutoScaleMinMax,
                        .toggleData]
*/
        
        
/*
        grafico.chartDescription?.enabled = false

        grafico.leftAxis.enabled = false
        grafico.rightAxis.drawAxisLineEnabled = false
        grafico.xAxis.drawAxisLineEnabled = false
        
        grafico.drawBordersEnabled = false
        grafico.setScaleEnabled(true)

        let l = grafico.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
 */
        
        
        
        
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let colors = ColorManager.allColors
        
        let block: (Int) -> ChartDataEntry = { (i) -> ChartDataEntry in
            let val = Double(arc4random_uniform(range) + 3)
            return ChartDataEntry(x: Double(i), y: val)
        }
        let dataSets = (0..<3).map { i -> LineChartDataSet in
            let yVals = (0..<count).map(block)
            let set = LineChartDataSet(entries: yVals, label: "DataSet \(i)")
            set.lineWidth = 2.5
            set.circleRadius = 4
            set.circleHoleRadius = 2
            let color = colors[i % colors.count]
            set.setColor(color)
            set.setCircleColor(color)
            
            return set
        }
        
        dataSets[0].lineDashLengths = [5, 5]
        dataSets[0].colors = ChartColorTemplates.vordiplom()
        dataSets[0].circleColors = ChartColorTemplates.vordiplom()
        
        let data = LineChartData(dataSets: dataSets)
        data.setValueFont(.systemFont(ofSize: 7, weight: .light))
        grafico.data = data
    }
    
    var shouldHideData: Bool = false
    
    func updateSetData (){
        if self.shouldHideData == true {
            grafico.data = nil
            return
        }else{
            setDataCount(dateArray.count, range: UInt32(dbc.getMaxContagio() + 100))
        }
    }
}

