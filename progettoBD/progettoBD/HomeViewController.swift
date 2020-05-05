//
//  HomeViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 30/04/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit
import SQLite

class HomeViewController: UIViewController, CalendarViewDataSource, CalendarViewDelegate {

    
    
    
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
    
    @IBAction func changeDate(_ sender: Any) {
        showCalendar()
    }
    
    func showCalendar(){
        
        let dismissView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        self.view.addSubview(dismissView)
        dismissView.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        dismissView.tag = 100
        
        let style = CalendarView.Style()
        
        
        style.cellShape                = .bevel(8.0)
        style.cellColorDefault         = UIColor.clear
        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor          = UIColor.gray
        
        style.cellTextColorDefault     = UIColor(red: 249/255, green: 180/255, blue: 139/255, alpha: 1.0)
        style.cellTextColorToday       = UIColor.orange
        style.cellTextColorWeekend     = UIColor(red: 237/255, green: 103/255, blue: 73/255, alpha: 1.0)
        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)
            
        style.headerBackgroundColor    = UIColor.white
        style.weekdaysBackgroundColor  = UIColor.white
        style.firstWeekday             = .monday
        
        style.locale                   = Locale(identifier: "it_IT")
        
        style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.weekdaysFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        let calendarView =  CalendarView(frame: CGRect(x: view.frame.origin.x + 10, y: view.frame.origin.y + 10, width: view.frame.width - 20, height: view.frame.height/2))
        
        calendarView.style = style
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = true
        
        
        
        calendarView.backgroundColor = UIColor(red: 252/255, green: 252/255, blue: 252/255, alpha: 1.0)
        
        self.view.addSubview(calendarView)
    
    }
    
    func startDate() -> Date {
          
        let date = dbc.getDataArray()[0]
          
          return date
      }
      
      func endDate() -> Date {
          
          return Date()
    
      }
    
    func calendar(_ calendar: CalendarView, didSelectDate date: Date, withEvents events: [CalendarEvent]) {
        return
    }
    
    func calendar(_ calendar : CalendarView, didScrollToMonth date : Date) {
        return
    }
    
}

