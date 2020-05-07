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
    
    let dbc = DBController.shared
    var regioni : [Regioni] = []
    var contagio : [Contagio] = []
    var andamento : [Andamento] = []
    var province : [Province] = []
    var dateArray : [Date] = []
    
    var dateToShow = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        regioni = dbc.getRegioni()
        contagio = dbc.getContagio()
        andamento = dbc.getAndamento()
        province = dbc.getProvincie()
        dateArray = dbc.getDataArray()
        
        dateToShow = dateArray.last!
        navigationController?.navigationBar.prefersLargeTitles = true
        labelPositivi(selectedDate: dateToShow)
        labelCasiTotali(selectedDate: dateToShow)
        labelDecessi(selectedDate: dateToShow)
        labelGuariti(selectedDate: dateToShow)
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
        let giornoPrima = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
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
        let giornoPrima = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
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
        let giornoPrima = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
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
        let giornoPrima = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate)!
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
    
//    func startDate() -> Date {
//
//        let date = dbc.getDataArray()[0]
//
//          return date
//      }
//
//      func endDate() -> Date {
//
//          return Date()
//
//      }
//
//    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
//        return
//    }
//
//    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
//        return
//    }
    
}

