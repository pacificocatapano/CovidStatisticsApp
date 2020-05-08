//
//  ShowDatiProvinciaViewController.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 08/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class ShowDatiProvinciaViewController: UIViewController {

    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var casiTotaliView: UILabel!
    @IBOutlet weak var casitotaliVariazione: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var calendarButton: UIBarButtonItem!
    var dataPicker = UIDatePicker()
    
    let dbc = DBController.shared
    var provinciaSelezionata : Province = Province()
    var contagioArray : [Contagio] = []
    var dateArray : [Date] = []
    var dateToShow : Date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.tintColor = ColorManager.mainRedColor
        navigationController?.navigationBar.prefersLargeTitles = true
        
        contagioArray = dbc.getContagio()
        dateArray = dbc.getDataArray()
        dateToShow = dateArray.last!
        
        chekAllProvince(selectedDate: dateToShow)
        labelCasiTotali(selectedDate: dateToShow)
        // Do any additional setup after loading the view.
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
        let barButton = UIBarButtonItem(title: "Done", style: .plain, target: target, action: #selector(saveDate))//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        toolBar.tag = 300
        view.addSubview(toolBar)
    }
    
    @objc func saveDate() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-DD"
        let oldDate = dateToShow
        dateToShow = Calendar.current.date(byAdding: .day, value: 1, to: dataPicker.date)!
        
        if dateToShow > oldDate {
            
            ricorsion = dateToShow.interval(ofComponent: .day, fromDate: oldDate)
        } else {
            ricorsion = oldDate.interval(ofComponent: .day, fromDate: dateToShow)
        }
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
