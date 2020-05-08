//
//  ProviciaViewController.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 07/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class DettagliRegioneProviciaViewController: UIViewController {
    
    var dataToSet : (Bool, Any) = (true, 0)
    var selectedRegione = Regioni()
    var selectedProvincia = Province()
    let dbc = DBController.shared
    var andamentoArray: [Andamento] = []
    var regioniArray :[Regioni] = []
    var provinceArray : [Province] = []
    var contagioArray : [Contagio] = []
    var dateArray : [Date] = []
    
    var dateToShow = Date()
    
    @IBOutlet weak var navBar: UINavigationItem!
    
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
    var dataPicker = UIDatePicker()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.tintColor = ColorManager.mainRedColor
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if dataToSet.0 == true {
            navBar.title = (dataToSet.1 as! Regioni).denominazioneRegione
            selectedRegione = dataToSet.1 as! Regioni
        }
        
        dateArray = dbc.getDataArray()
        dateToShow = dateArray.last!
        
        checkDati(selectedDate: dateToShow)
        
        if dataToSet.0 == true {
            labelPositiviRegione(selectedDate: dateToShow, Regione: selectedRegione)
            labelDecessiRegione(selectedDate: dateToShow, regione: selectedRegione)
            labelGuaritiRegione(selectedDate: dateToShow, regione: selectedRegione)
            labelCasiTotaliRegione(selectedDate: dateToShow, regione: selectedRegione)
        }
        // Do any additional setup after loading the view.
    }
    
    var exit = false
    var ricorsion = 1
    
    
    //MARK: - Controlla se nel giorno indicato sono presenti i dati di tutte le regioni, se non lo sono, combia giorno finquando non trova quello con tutti i dati
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
        let attPositivi = attualmentePositiviRegione(selectedDate: selectedDate, regione: regione)
        if selectedDate == dateArray.first {
            result = attualmentePositiviRegione(selectedDate: selectedDate, regione: regione)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        let positiviGiornoPrima = attualmentePositiviRegione(selectedDate: giornoPrima, regione: regione)
        
        result = (((attPositivi - positiviGiornoPrima) * 100)/( positiviGiornoPrima ))
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
        let casiTotaliOggi = casiTotaliRegione(selectedDate: selectedDate, regione: regione)
        if selectedDate == dateArray.first {
            result = casiTotaliRegione(selectedDate: selectedDate, regione: regione)
        }
        let giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        let casiTotaliGiornoPrima = casiTotaliRegione(selectedDate: giornoPrima, regione: regione)
        
        result = (((casiTotaliOggi - casiTotaliGiornoPrima) * 100)/( casiTotaliGiornoPrima ))
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
        if selectedDate == dateArray.first {
            result = decessiRegione(selectedDate: selectedDate, regione: regione)
        }
        let giornoPrima = dateArray[dateArray.count - ricorsion - 1]
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
        
        for and in andamentoArray where and.data == selectedDate {
            result += Float(and.guariti)
        }
        return result
    }
    
    func variazioneGuaritiRegione(selectedDate : Date ,regione:Regioni) -> Float {
        var result: Float = 0
        let oggi = guaritiRegione(selectedDate: selectedDate, regione: regione)
        if selectedDate == dateArray.first {
            result = guaritiRegione(selectedDate: selectedDate, regione: regione)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - ricorsion - 1]
        let ieri = guaritiRegione(selectedDate: giornoPrima, regione: regione)
        
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
        dataPicker.maximumDate = dateArray[dateArray.count - 1 - ricorsion]
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
        //        let style = CalendarView.Style()
        //
        //
        //        style.cellShape                = .bevel(8.0)
        //        style.cellColorDefault         = UIColor.clear
        //        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        //        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        //        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        //        style.headerTextColor          = UIColor.gray
        //
        //        style.cellTextColorDefault     = UIColor(red: 249/255, green: 180/255, blue: 139/255, alpha: 1.0)
        //        style.cellTextColorToday       = UIColor.orange
        //        style.cellTextColorWeekend     = UIColor(red: 237/255, green: 103/255, blue: 73/255, alpha: 1.0)
        //        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)
        //
        //        style.headerBackgroundColor    = UIColor.white
        //        style.weekdaysBackgroundColor  = UIColor.white
        //        style.firstWeekday             = .monday
        //
        //        style.locale                   = Locale(identifier: "it_IT")
        //
        //        style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        //        style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        //        style.weekdaysFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        //
        //
        //        calendarView.style = style
        //
        //        calendarView.frame = CGRect(x: view1.frame.origin.x + 5, y: view1.frame.origin.y + 5, width: view1.frame.width - 10, height: view.frame.height - 5)
        //        calendarView.direction = .horizontal
        //        calendarView.multipleSelectionEnable = false
        //        calendarView.marksWeekends = true
        //
        //
        //
        //        calendarView.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        //
        //        view.addSubview(calendarView)
        //        calendarView.tag = 200
    }
    
    @objc func saveDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        dateToShow = Calendar.current.date(byAdding: .day, value: 1, to: dataPicker.date)!
        
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
