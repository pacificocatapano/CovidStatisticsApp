//
//  ProviciaViewController.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 07/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import Charts
import GoogleMaps

class DettagliRegioneProviciaViewController: UIViewController,UIScrollViewDelegate, GMSMapViewDelegate {
    
    var dataToSet : (Bool, Any) = (true, 0)
    var selectedRegione = Regioni()
    let dbc = DBController.shared
    var andamentoArray: [Andamento] = []
    var regioniArray :[Regioni] = []
    var dateArray : [Date] = []
    
    var dateToShow = Date()
    
    @IBOutlet weak var navBar: UINavigationItem!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var numeroPositivi: UILabel!
    @IBOutlet weak var variazionePositivi: UILabel!
    @IBOutlet weak var numeroCasiTotali: UILabel!
    @IBOutlet weak var variazioneCasiTotali: UILabel!
    @IBOutlet weak var numeroDecessi: UILabel!
    @IBOutlet weak var variazioneDecessi: UILabel!
    @IBOutlet weak var numeroGuariti: UILabel!
    @IBOutlet weak var variazioneGuariti: UILabel!
    @IBOutlet weak var HomeScrollView: UIScrollView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var grafico1Label: UILabel!
    @IBOutlet weak var grafico1View: LineChartView!
    @IBOutlet weak var grafico1Button: UIButton!
    @IBOutlet weak var grafico2Label: UILabel!
    @IBOutlet weak var grafico2view: LineChartView!
    @IBOutlet weak var grafico2Button: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    
    var dataPicker = UIDatePicker()
    var datiVariazione:[(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)] = []
    var arrayDataForGrafici : [(Date, Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)] = []
    let searchController = UISearchController(searchResultsController: nil)
    
    var mapView1 = GMSMapView()
    
    var lon = Float()
    var lat = Float()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.navigationBar.tintColor = ColorManager.mainRedColor
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataToSet.0 == true {
            navBar.title = (dataToSet.1 as! Regioni).denominazioneRegione
            selectedRegione = dataToSet.1 as! Regioni
        }
        
        scrollView.showsVerticalScrollIndicator = false
        
        navigationController?.navigationBar.prefersLargeTitles = false
        
        let originY = navigationController?.navigationBar.frame.maxY
        
        let camera = GMSCameraPosition.camera(withLatitude: 41.8928, longitude: 12.4837, zoom: 5.0)
        
        mapView1 = GMSMapView.map(withFrame: CGRect(x: view.frame.origin.x, y: originY!, width: view.frame.width, height: view.frame.height/4), camera: camera)
        
        mapView1.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        mapView1.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        mapView1.layer.shadowOpacity = 10.0
        mapView1.layer.shadowRadius = 2.0
        mapView1.layer.masksToBounds = false
        
        self.view.addSubview(mapView1)
        mapView1.mapType = .normal
        
        progettoBD.getLocation(fromAddress: selectedRegione.denominazioneRegione , completion: {(location) -> Void in
            
            if location != nil {
                DispatchQueue.main.async {
                    self.mapView1.animate(toLocation: CLLocationCoordinate2D(latitude: CLLocationDegrees(location!.latitude), longitude: CLLocationDegrees(location!.longitude)))
                    self.mapView1.animate(toZoom: 6.35)
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(location!.latitude), longitude: CLLocationDegrees(location!.longitude))
                    marker.title = self.selectedRegione.denominazioneRegione
                    marker.snippet = "Italia"
                    marker.map = self.mapView1
                    marker.appearAnimation = .pop
                    marker.snippet = "Popolazione : \(self.selectedRegione.abitanti) \n \(self.selectedRegione.numeroDiStazioni) Stazioni e  \(self.selectedRegione.numeroDiAereoporti) Aereoporti  \n Autostrade e SS \(self.selectedRegione.numeroDiAutostrade + self.selectedRegione.numeroDiSuperStrade)"
                }
            }
        })
        
        mapView1.settings.zoomGestures = true
        
        dateArray = dbc.getDataArray()
        dateToShow = dateArray.last!
        
        checkDati(selectedDate: dateToShow)
        
        arrayDataForGrafici = dbc.getArrayAndamentoPerGraficoRegione(regione: selectedRegione.denominazioneRegione)
        datiVariazione = variazione()
        
        labelPositiviRegione(selectedDate: dateToShow, Regione: selectedRegione)
        labelDecessiRegione(selectedDate: dateToShow, regione: selectedRegione)
        labelGuaritiRegione(selectedDate: dateToShow, regione: selectedRegione)
        labelCasiTotaliRegione(selectedDate: dateToShow, regione: selectedRegione)
        
        createGrafico1()
        createGrafico2()
        
        grafico1Button.tintColor = ColorManager.mainRedColor
        grafico2Button.tintColor = ColorManager.mainRedColor
        
        grafico1Button.backgroundColor = UIColor.clear
        grafico2Button.backgroundColor = UIColor.clear
        // Do any additional setup after loading the view.
    }
    
    //MARK: - MapView
    
    let geocoder = GMSGeocoder()
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        mapView.clear()
    }
    
    func mapView(_ mapView: GMSMapView, idleAt cameraPosition: GMSCameraPosition) {
        geocoder.reverseGeocodeCoordinate(cameraPosition.target) { (response, error) in
            guard error == nil else {
                return
            }
            
            if let result = response?.firstResult() {
                let marker = GMSMarker()
                marker.position = cameraPosition.target
                marker.title = result.lines?[0]
                marker.snippet = result.lines?[1]
                marker.map = mapView
            }
        }
    }
    
    //MARK: - Cambia il giorno da mostare
    var exit = false
    var ricorsion = 1
    
    func checkDati(selectedDate : Date) {
        for and in andamentoArray where and.data == selectedDate && and.regione == (dataToSet.1 as! Regioni).denominazioneRegione {
            dateToShow = and.data
            return
        }
        ricorsion += 1
        checkDati(selectedDate: dateArray[dateArray.count - ricorsion])
    }
    
    //MARK: - attualmentePositiviRegione
    func labelPositiviRegione(selectedDate: Date, Regione: Regioni){
        numeroPositivi.text = "\(Int(attualmentePositiviRegione(selectedDate: selectedDate, regione: selectedRegione)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneAttualmentePositiviRegione(selectedDate: selectedDate, regione: selectedRegione))
        let variazioneNumericaAttualmentePositivi : Int = Int(attualmentePositiviRegione(selectedDate: selectedDate, regione: selectedRegione) - attualmentePositiviRegione(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!, regione: selectedRegione))
        if variazioneAttualmentePositiviRegione(selectedDate: selectedDate, regione: selectedRegione) > 0 {
            variazionePositivi.text = "+\(variazioneNumericaAttualmentePositivi)  (+\(deltaPositivi)%)"
        } else {
            variazionePositivi.text = "\(variazioneNumericaAttualmentePositivi)  (\(deltaPositivi)%)"
        }
    }
    
    func attualmentePositiviRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        
        for and in andamentoArray where and.data == selectedDate && and.regione == regione.denominazioneRegione {
            result += Float(and.totalePositivi)
        }
        return result
    }
    
    func variazioneAttualmentePositiviRegione(selectedDate: Date, regione: Regioni) -> Float {
        var result: Float = 0
        let oggi = attualmentePositiviRegione(selectedDate: selectedDate, regione: regione)
        var giornoPrima = Date()
        if selectedDate == dateArray.first {
            result = attualmentePositiviRegione(selectedDate: selectedDate, regione: regione)
            return result
        }else if selectedDate == dateArray[1] {
            giornoPrima = dateArray[0]
        } else {
            giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        }
        let ieri = attualmentePositiviRegione(selectedDate: giornoPrima, regione: regione)
        
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    //END******************************************************
    
    //MARK: - casiTotaliRegione
    func labelCasiTotaliRegione( selectedDate : Date ,regione:Regioni){
        numeroCasiTotali.text = "\(Int(casiTotaliRegione(selectedDate: selectedDate, regione: regione)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneCasiTotaliRegione(selectedDate: selectedDate, regione: regione))
        let variazioneNumericaCasiTotali: Int = Int(casiTotaliRegione(selectedDate: selectedDate, regione: regione) - casiTotaliRegione(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!, regione: regione))
        if variazioneCasiTotaliRegione(selectedDate: selectedDate, regione: regione) > 0 {
            variazioneCasiTotali.text = "+\(variazioneNumericaCasiTotali)  (+\(deltaPositivi)%)"
        } else {
            variazionePositivi.text = "\(variazioneNumericaCasiTotali)  (\(deltaPositivi)%)"
        }
    }
    
    func casiTotaliRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        
        for and in andamentoArray where and.data == selectedDate && and.regione == regione.denominazioneRegione {
            result += Float(and.contagi)
        }
        return result
    }
    
    func variazioneCasiTotaliRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        let oggi = casiTotaliRegione(selectedDate: selectedDate, regione: regione)
        var giornoPrima = Date()
        if selectedDate == dateArray.first {
            result = casiTotaliRegione(selectedDate: selectedDate, regione: regione)
            return result
        } else if selectedDate == dateArray[1] {
            giornoPrima = dateArray[0]
        } else {
            giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        }
        let ieri = casiTotaliRegione(selectedDate: giornoPrima, regione: regione)
        
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    //END
    
    //MARK: - decessiRegione Ultimo Giorno
    func labelDecessiRegione(selectedDate : Date ,regione:Regioni){
        numeroDecessi.text = "\(Int(decessiRegione(selectedDate: selectedDate, regione: regione)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneDecessiRegione(selectedDate: selectedDate, regione: regione))
        let variazioneNumericaDecessi: Int = Int(decessiRegione(selectedDate: selectedDate, regione: regione) - decessiRegione(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!, regione: regione))
        
        if variazioneDecessiRegione(selectedDate: selectedDate, regione: regione) > 0 {
            variazioneDecessi.text = "+\(variazioneNumericaDecessi)  (+\(deltaPositivi)%)"
        } else {
            variazioneDecessi.text = "\(variazioneNumericaDecessi)  (\(deltaPositivi)%)"
        }
    }
    
    func decessiRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        
        for and in andamentoArray where and.data == selectedDate && and.regione == regione.denominazioneRegione {
            result += Float(and.decessi)
        }
        return result
    }
    
    func variazioneDecessiRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        let oggi = decessiRegione(selectedDate: selectedDate, regione: regione)
        var giornoPrima = Date()
        if selectedDate == dateArray.first {
            result = decessiRegione(selectedDate: selectedDate, regione: regione)
            return result
        } else if selectedDate == dateArray[1] {
            giornoPrima = dateArray[0]
        } else {
            giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        }
        let ieri = decessiRegione(selectedDate: giornoPrima, regione: regione)
        
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    //END
    
    //MARK: - guaritiRegione Ultimo Giorno
    func labelGuaritiRegione(selectedDate : Date ,regione:Regioni){
        numeroGuariti.text = "\(Int(guaritiRegione(selectedDate:selectedDate, regione: regione)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneGuaritiRegione(selectedDate: selectedDate, regione: regione))
        let variazioneNumericaGuariti: Int = Int(guaritiRegione(selectedDate: selectedDate, regione: regione) - guaritiRegione(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!, regione: regione))
        
        if variazioneGuaritiRegione(selectedDate: selectedDate, regione: regione) > 0 {
            variazioneGuariti.text = "+\(variazioneNumericaGuariti)  (+\(deltaPositivi)%)"
        } else {
            variazioneGuariti.text = "\(variazioneNumericaGuariti)  (\(deltaPositivi)%)"
        }
    }
    
    func guaritiRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        
        for and in andamentoArray where and.data == selectedDate && and.regione == regione.denominazioneRegione {
            result += Float(and.guariti)
        }
        return result
    }
    
    func variazioneGuaritiRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        let oggi = guaritiRegione(selectedDate: selectedDate, regione: regione)
        var giornoPrima = Date()
        if selectedDate == dateArray.first {
            result = guaritiRegione(selectedDate: selectedDate, regione: regione)
            return result
        } else if selectedDate == dateArray[1] {
            giornoPrima = dateArray[0]
        } else {
            giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        }
        let ieri = guaritiRegione(selectedDate: giornoPrima, regione: regione)
        
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    //END
    
    @IBAction func changeDate(_ sender: Any) {
        showCalendar()
    }
    
    //MARK: -Calendar
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
        dataPicker.date = Calendar.current.date(byAdding: .day, value: -1, to: dateToShow)!
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
        toolBar.backgroundColor = UIColor.white
        let barButton = UIBarButtonItem(title: "Done", style: .done, target: target, action: #selector(saveDate))//3
        barButton.tintColor = ColorManager.mainRedColor
        toolBar.setItems([flexible, barButton], animated: false)//4
        toolBar.tag = 300
        view.addSubview(toolBar)
    }
    
    var dateInterval = 0
    
    @objc func saveDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        dateToShow = Calendar.current.date(byAdding: .day, value: 1, to: dataPicker.date)!
        
        dateInterval = 0
        
        for date in dateArray.reversed() {
            if date == dateToShow {
                dateInterval += 1
                break
            }
            dateInterval += 1
        }
        
        ricorsion = dateInterval
        
        labelDecessiRegione(selectedDate: dateToShow, regione: selectedRegione)
        labelGuaritiRegione(selectedDate: dateToShow, regione: selectedRegione)
        labelPositiviRegione(selectedDate: dateToShow, Regione: selectedRegione)
        labelCasiTotaliRegione(selectedDate: dateToShow, regione: selectedRegione)
        
        calendarButton.isEnabled = true
        
        var dateString = "\(dateToShow)"
        let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
        dateString.removeSubrange(range)
        if dateToShow != dateArray.last {
            navBar.title = "Contagi del \(dateString) in \(selectedRegione)"
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        navigationController?.navigationBar.barTintColor = ColorManager.navigationBar
        tabBarController?.tabBar.isHidden = false
        createGrafico1()
        createGrafico2()
        grafico1View.resetZoom()
        grafico2view.resetZoom()
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
        
        grafico1Label.text = "Andamento regionale pandemia"
        grafico1Button.addTarget(self, action: #selector(zoom1), for: .touchUpInside)
        
        grafico2Label.text = "Variazione regionale pandemia"
        grafico2Button.addTarget(self, action: #selector(zoom2), for: .touchUpInside)
    }
    
    @objc func zoom1(){
        grafico1View.zoomOut()
    }
    
    @objc func zoom2(){
        grafico2view.zoomOut()
    }
    
    func createGrafico2() {
        //impostazioni grafico
        grafico2view.noDataText = "No data available"
        grafico2view.rightAxis.enabled = false
        grafico2view.backgroundColor = UIColor.white
        grafico2view.gridBackgroundColor = UIColor.white
        grafico2view.xAxis.labelPosition = .bottom
        grafico2view.xAxis.setLabelCount(5, force: false)
        grafico2view.animate(xAxisDuration: 4.0, easingOption: .linear)
        
        //aggiungere dati al grafico
        let dataGraph = LineChartData()
        dataGraph.addDataSet(lineDeltaAttPos())
        dataGraph.addDataSet(lineDeltaCasiTotali())
        dataGraph.addDataSet(lineDeltaGuariti())
        dataGraph.addDataSet(lineDeltaDecessi())
        
        dataGraph.setDrawValues(false)
        grafico2view.data = dataGraph
        
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
        CasiTotaliLineChartDataSet.drawCirclesEnabled = true
        CasiTotaliLineChartDataSet.circleRadius = 2
        CasiTotaliLineChartDataSet.circleColors = [ColorManager.mainRedColor]
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
        attualmentePositiviLineChartDataSet.drawCirclesEnabled = true
        attualmentePositiviLineChartDataSet.circleRadius = 2
        attualmentePositiviLineChartDataSet.circleColors = [ColorManager.lighterRed]
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
        guaritiLineChartDataSet.drawCirclesEnabled = true
        guaritiLineChartDataSet.circleRadius = 2
        guaritiLineChartDataSet.circleColors = [ColorManager.green]
        guaritiLineChartDataSet.circleRadius = 0.5
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
        decessiLineChartDataSet.drawCirclesEnabled = true
        decessiLineChartDataSet.circleRadius = 2
        decessiLineChartDataSet.circleColors = [ColorManager.black]
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
        DeltaAttPosLineChartDataSet.drawCirclesEnabled = true
        DeltaAttPosLineChartDataSet.circleRadius = 2
        DeltaAttPosLineChartDataSet.circleColors = [ColorManager.lighterRed]
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
        DeltaCasiTotaliLineChartDataSet.drawCirclesEnabled = true
        DeltaCasiTotaliLineChartDataSet.circleRadius = 2
        DeltaCasiTotaliLineChartDataSet.circleColors = [ColorManager.mainRedColor]
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
        DeltaGuaritiLineChartDataSet.drawCirclesEnabled = true
        DeltaGuaritiLineChartDataSet.circleRadius = 2
        DeltaGuaritiLineChartDataSet.circleColors = [ColorManager.green]
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
        DeltaDecessiLineChartDataSet.drawCirclesEnabled = true
        DeltaDecessiLineChartDataSet.circleRadius = 2
        DeltaDecessiLineChartDataSet.circleColors = [ColorManager.black]
        DeltaDecessiLineChartDataSet.mode = .cubicBezier
        return DeltaDecessiLineChartDataSet
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

