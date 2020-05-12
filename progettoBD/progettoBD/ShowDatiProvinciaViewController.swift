//
//  ShowDatiProvinciaViewController.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 08/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import Charts
import GoogleMaps

class ShowDatiProvinciaViewController: UIViewController, GMSMapViewDelegate {
    
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var casiTotaliView: UILabel!
    @IBOutlet weak var casitotaliVariazione: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    @IBOutlet weak var grafico1Label: UILabel!
    @IBOutlet weak var grefico1View: LineChartView!
    @IBOutlet weak var grafico1Button: UIButton!
    @IBOutlet weak var grafico2Label: UILabel!
    @IBOutlet weak var grafico2view: LineChartView!
    @IBOutlet weak var grafico2Button: UIButton!
    
    var dataPicker = UIDatePicker()
    
    let dbc = DBController.shared
    var provinciaSelezionata : Province = Province()
    var contagioArray : [Contagio] = []
    var dateArray : [Date] = []
    var dateToShow : Date = Date()
    var datiVariazione:[(Date, Int64)] = []
    var arrayDataForGrafici : [(Date, Int64)] = []
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var mapView1 = GMSMapView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        navigationController?.navigationBar.prefersLargeTitles = false
        navBar.title = provinciaSelezionata.denominazioneProvincia
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.showsVerticalScrollIndicator = false
        
        navigationController?.navigationBar.tintColor = ColorManager.mainRedColor
        
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
        
        mapView1.animate(toLocation: CLLocationCoordinate2D(latitude: CLLocationDegrees(provinciaSelezionata.latitudine), longitude: CLLocationDegrees(provinciaSelezionata.longitudine)))
        
        mapView1.animate(toZoom: 10)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: CLLocationDegrees(provinciaSelezionata.latitudine), longitude: CLLocationDegrees(provinciaSelezionata.longitudine))
        marker.title = provinciaSelezionata.denominazioneProvincia
        marker.map = mapView1
        marker.appearAnimation = .pop
        
        var alberghi = ""
        
        if self.provinciaSelezionata.numeroDiAlberghi < 0 {
            alberghi = ": (Non disponibile)"
        } else {
            alberghi = "\(self.provinciaSelezionata.numeroDiAlberghi)"
        }
        
        marker.snippet = "Popolazione : \(self.provinciaSelezionata.abitanti) \n Scuole: \(self.provinciaSelezionata.numeroDiScuole) \n Alberghi \(alberghi) \n Ospedali: \(self.provinciaSelezionata.numeroDiOspedali)"
        
        mapView1.settings.zoomGestures = true
        
        contagioArray = dbc.getContagio()
        dateArray = dbc.getDataArray()
        dateToShow = dateArray.last!
        
        chekAllProvince(selectedDate: dateToShow)
        labelCasiTotali(selectedDate: dateToShow)
        
        arrayDataForGrafici = dbc.getArrayAndamentoPerGraficoProvincia(provincia: "\(provinciaSelezionata.codiceProvincia)")
        datiVariazione = variazione()
        
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
    
    
    var exit = false
    var ricorsion = 1
    
    
    //MARK: - Controlla se nel giorno indicato sono presenti i dati di tutte le regioni, se non lo sono, combia giorno finquando non trova quello con tutti i dati
    func chekAllProvince(selectedDate : Date) {
        for con in contagioArray where con.data == selectedDate && con.provincia == "\(provinciaSelezionata.codiceProvincia)" {
            dateToShow = con.data
            return
        }
        ricorsion += 1
        chekAllProvince(selectedDate: dateArray[dateArray.count - ricorsion])
    }
    
    //MARK: -Ultimo Giorno
    func labelCasiTotali(selectedDate: Date){
        casiTotaliView.text = "\(Int(casiTotali(selectedDate:selectedDate)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneCasiTotali(selectedDate: selectedDate))
        let variazioneNumerica: Int = Int(casiTotali(selectedDate: selectedDate) - casiTotali(selectedDate: Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!))
        
        if variazioneCasiTotali(selectedDate: selectedDate) > 0 {
            casitotaliVariazione.text = "+\(variazioneNumerica)  (+\(deltaPositivi)%)"
        } else {
            casitotaliVariazione.text = "\(variazioneNumerica)  (\(deltaPositivi)%)"
        }
    }
    
    func casiTotali(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for con in contagioArray where con.data == selectedDate && con.provincia == "\(provinciaSelezionata.codiceProvincia)" {
            result += Float(con.numeroCasi)
        }
        return result
    }
    
    func variazioneCasiTotali(selectedDate: Date) -> Float {
        var result: Float = 0
        let oggi = casiTotali(selectedDate: selectedDate)
        if selectedDate == dateArray.first {
            result = casiTotali(selectedDate: selectedDate)
            return result
        }
        
        var giornoPrima: Date = Date ()
        if Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) == dateArray[dateArray.count - ricorsion - 1] {
            giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        } else {
            var i = 0
            for date in dateArray {
                if date == selectedDate {
                    giornoPrima = dateArray[i-1]
                    break
                }
                i += 1
            }
        }
        let ieri = casiTotali(selectedDate: giornoPrima)
        
        result = (((oggi - ieri) * 100)/( ieri ))
        return result
    }
    
    @IBAction func changeDate(_ sender: Any) {
        showCalendar()
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
        labelCasiTotali(selectedDate: dateToShow)
        
        calendarButton.isEnabled = true
        
        var dateString = "\(dateToShow)"
        let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
        dateString.removeSubrange(range)
        if dateToShow != dateArray.last {
            navBar.title = "Contagi del \(dateString)"
            navigationController?.navigationBar.prefersLargeTitles = false
        }
        
        createGrafico1()
        createGrafico2()
        grefico1View.resetZoom()
        grafico2view.resetZoom()
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
    func createGrafico1() {
        //impostazioni grafico
        grefico1View.noDataText = "No data available"
        grefico1View.rightAxis.enabled = false
        grefico1View.backgroundColor = UIColor.white
        grefico1View.gridBackgroundColor = UIColor.white
        grefico1View.xAxis.labelPosition = .bottom
        grefico1View.xAxis.setLabelCount(5, force: false)
        grefico1View.animate(xAxisDuration: 2.0, easingOption: .linear)
        
        
        //aggiungere dati al grafico
        let dataGraph = LineChartData()
        
        dataGraph.addDataSet(lineCasiTotali())
        
        dataGraph.setDrawValues(false)
        grefico1View.data = dataGraph
        
        grafico1Label.text = "Andamento provinciale pandemia"
        grafico1Button.addTarget(self, action: #selector(zoom1), for: .touchUpInside)
        
        grafico2Label.text = "Variazione provinciale pandemia"
        grafico2Button.addTarget(self, action: #selector(zoom2), for: .touchUpInside)
    }
    
    @objc func zoom1(){
        grefico1View.zoomOut()
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
        grafico2view.animate(xAxisDuration: 2.0, easingOption: .linear)
        
        //aggiungere dati al grafico
        let dataGraph = LineChartData()
        dataGraph.addDataSet(lineDeltaCasiTotali())
        
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
    
    
    
    //MARK: -VARIAZIONI
    func variazione() -> [(Date, Int64)]{
        var result: [(Date, Int64)] = []
        var previousIndex = -1
        for and in arrayDataForGrafici {
            if previousIndex == -1{
                result.append(and)
                previousIndex += 1
            }else{
                var toAppend: (Date, Int64) = arrayDataForGrafici[previousIndex]
                let dateDifference = and.0.interval(ofComponent: .day, fromDate: toAppend.0)
                let newData = Calendar.current.date(byAdding: .day, value: dateDifference, to: toAppend.0)
                toAppend = (newData, and.1 - toAppend.1) as! (Date, Int64)
                
                result.append(toAppend)
                previousIndex += 1
            }
        }
        return result
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
