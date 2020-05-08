//
//  DBController.swift
//  UTaste
//
//  Created by Andrea Bello on 08/02/2019.
//  Copyright © 2019 Boeing 752. All rights reserved.
//

import Foundation
import UIKit
import SQLite
import SQLite3

class DBController: NSObject {
    static let shared = DBController()
    
    private let null : NSNull = NSNull()
    
    //private let fileManager = FileManager.default
    var path = Bundle.main.path(forResource: "data", ofType: "sqlite")!
    
    func copyDatabaseIfNeeded() {
           // Move database file from bundle to documents folder

           let fileManager = FileManager.default

           let documentsUrl = fileManager.urls(for: .documentDirectory,
                                                       in: .userDomainMask)

           guard documentsUrl.count != 0 else {
               return // Could not find documents URL
           }

           let finalDatabaseURL = documentsUrl.first!.appendingPathComponent("data.sqlite")

           if !( (try? finalDatabaseURL.checkResourceIsReachable()) ?? false) {
               print("DB does not exist in documents folder")

               let documentsURL = Bundle.main.resourceURL?.appendingPathComponent("data.sqlite")

               do {
                     try fileManager.copyItem(atPath: (documentsURL?.path)!, toPath: finalDatabaseURL.path)
                     } catch let error as NSError {
                       print("Couldn't copy file to final location! Error:\(error.description)")
               }

           } else {
               print("Database file found at path: \(finalDatabaseURL.path)")
           }

        path = finalDatabaseURL.absoluteString
       }

    
    override init() {
        super.init()
        if path == Bundle.main.path(forResource: "data", ofType: "sqlite")! {
            copyDatabaseIfNeeded()
        }
    }
    
    public func getRegioni() -> [Regioni] {
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT * FROM REGIONI R ORDER BY R.DENOMINAZIONEREGIONE ASC")
            
            return stmt.map{ row in
                let codiceRegione = Int(row[0] as!String)!
                let denominazioneRegione = row[1] as! String
                let abitanti = Int(row[2] as! String)
                let densitàAbitanti = Float(row[3] as! String)
                let numeroDiAutostrade = Int(row[4] as! String)
                let numeroDiSuperStrade = Int(row[5] as! String)
                let numeroDiAereoporti = Int(row[6] as! String)
                let numeroDiStazioni = Int(row[7] as! String)
                
                return Regioni(codiceRegione: codiceRegione, denominazioneRegione: denominazioneRegione, abitanti: abitanti!, densitàAbitanti: densitàAbitanti!, numeroDiAutostrade: numeroDiAutostrade ?? -1, numeroDiSuperStrade: numeroDiSuperStrade ?? -1, numeroDiAereoporti: numeroDiAereoporti ?? -1, numeroDiStazioni: numeroDiStazioni ?? -1)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getProvincie() -> [Province]{
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT * FROM PROVINCE P ORDER BY P.DENOMINAZIONEPROVINCIA ASC")
            
            return stmt.map{ row in
                
                let codiceProvincia = Int(row[0] as!String)!
                let denominazioneProvincia = row[1] as! String
                let siglaProvincia = row[2] as! String
                let regioneAppartenenza = row[3] as! String
                let latitudine = Float(row[4] as! String)
                let longitudine = Float(row[5] as! String)
                let abitanti = Int(row[6] as! String)
                let densitàAbitanti = Float(row[7] as! String)
                let estensione = Float(row[8] as! String)
                let numeroDiScuole = Int(row[9] as! String)
                let numeroDiAlberghi = Int(row[10] as! String)
                let numeroDiOspedali = Int(row[11] as! String)
                let numeroSpostamentiInterni = Int(row[12] as! String)
                let numeroSpostamnetiEsterni = Int(row[12] as! String)
                
                return Province(codiceProvincia: codiceProvincia, denominazioneProvincia: denominazioneProvincia, siglaProvincia: siglaProvincia, regioneAppartenenza: regioneAppartenenza, latitudine: latitudine!, longitudine: longitudine!, abitanti: abitanti ?? -1, densitàAbitanti: densitàAbitanti ?? -1, estensione: estensione ?? -1, numeroDiScuole: numeroDiScuole ?? -1, numeroDiAlberghi: numeroDiAlberghi ?? -1, numeroDiOspedali: numeroDiOspedali ?? -1 , numeroSpostamentiInterni: numeroSpostamentiInterni ?? -1, numeroSpostamnetiEsterni: numeroSpostamnetiEsterni ?? -1)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getContagio() -> [Contagio] {
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT * FROM CONTAGIO C ORDER BY C.DATA ASC")
            
            return stmt.map{ row in
                
                var dateString = row[0] as! String
                let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
                dateString.removeSubrange(range)
                let dateObj = dateString.toDate()
                let provincia = row[1] as! String
                let numeroCasi = Int(row[2] as! String)
                
                return Contagio(data: dateObj, provincia: provincia, numeroCasi: numeroCasi!)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getAndamento() -> [Andamento] {
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT * FROM ANDAMENTO A ORDER BY A.DATAANDAMENTO ASC")
            
            return stmt.map{ row in
                
                var dateString = row[0] as! String
                let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
                dateString.removeSubrange(range)
                let dateObj = dateString.toDate()
                
                let regione = row[1] as! String
                let contagi = Int(row[2] as! String)
                let decessi = Int(row[3] as! String)
                let guariti = Int(row[4] as! String)
                let ricoverati = Int(row[5] as! String)
                let isolamentoDomiciliare = Int(row[6] as! String)
                let terapiaIntensiva = Int(row[7] as! String)
                let tamponiEffettuati = Int(row[8] as! String)
                let totalePositivi = Int(row[9] as! String)
                
                return Andamento(data:  dateObj, regione: regione, contagi: contagi!, decessi: decessi!, guariti: guariti!, ricoverati: ricoverati!, isolamentoDomiciliare: isolamentoDomiciliare!, terapiaIntensiva: terapiaIntensiva!, tamponiEffettuati: tamponiEffettuati!, totalePositivi: totalePositivi!)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getDataArray() -> [Date] {
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare(" SELECT * FROM DATECAMPIONE D ")
            
            
            return stmt.map{ row in
                
                var dateString = row[0] as! String
                let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
                dateString.removeSubrange(range)
                let dateObj = dateString.toDate()
                
                return dateObj
            }
            
            
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    
    // 5 regioni con più contagi **
    public func getRegioniPiùColpite(selectedDate: Date) -> [RegioniEAndamento] {
        do {
            let db = try Connection(path, readonly: true)
            
            var dateString = "\(selectedDate)"
            let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
            dateString.removeSubrange(range)
            
            //TO DO:aggiustare query
            let stmt = try db.prepare("SELECT A.REGIONE, A.CONTAGI FROM ANDAMENTO A WHERE A.DATAANDAMENTO = \(dateString)")
            //*********
            
            return stmt.map{ row in
                
                let regione = row[0] as! String
                let contagi = Int(row[1] as! String)
                
                return RegioniEAndamento(regione: regione, contagiTotali: contagi!)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getMaxContagio() -> Int {
           do {
               let db = try Connection(path, readonly: true)
               
               //TO DO:aggiustare query
               let stmt = try db.prepare("SELECT MAX(A.CONTAGI) FROM ANDAMENTO A WHERE A.DATAANDAMENTO = (SELECT MAX(D.DATA) FROM DATECAMPIONE D)")
               //*********
            
            let result : Int = stmt.row[0]
            return result
           } catch {
               print("Unexpected error: \(error)")
           }
           return Int()
       }
    
    public func getAndamentoLastDate() -> [Andamento]{
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT * FROM ANDAMENTO A WHERE A.DATAANDAMENTO = (SELECT MAX(D.DATA) FROM DATECAMPIONE D)")
            
            return stmt.map{ row in
                
                var dateString = row[0] as! String
                let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
                dateString.removeSubrange(range)
                let dateObj = dateString.toDate()
                
                let regione = row[1] as! String
                let contagi = Int(row[2] as! String)
                let decessi = Int(row[3] as! String)
                let guariti = Int(row[4] as! String)
                let ricoverati = Int(row[5] as! String)
                let isolamentoDomiciliare = Int(row[6] as! String)
                let terapiaIntensiva = Int(row[7] as! String)
                let tamponiEffettuati = Int(row[8] as! String)
                let totalePositivi = Int(row[9] as! String)
                
                return Andamento(data:  dateObj, regione: regione, contagi: contagi!, decessi: decessi!, guariti: guariti!, ricoverati: ricoverati!, isolamentoDomiciliare: isolamentoDomiciliare!, terapiaIntensiva: terapiaIntensiva!, tamponiEffettuati: tamponiEffettuati!, totalePositivi: totalePositivi!)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getArrayAndamentoPerGrafico() -> [(Date,Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64)]{
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT a.dataAndamento, SUM(A.contagi), SUM(A.decessi), SUM(A.guariti), SUM(A.ricoverati), SUM(A.isolamentodomiciliare), SUM(A.terapiaintensiva), SUM(A.tamponieffettuati), SUM(A.totalePositivi) FROM andamento A GROUP BY a.dataandamento")
            
            return stmt.map{ row in
                
                var dateString = row[0] as! String
                let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
                dateString.removeSubrange(range)
                let dateObj = dateString.toDate()
                
                let contagi = row[1] as! Int64
                let decessi = row[2] as! Int64
                let guariti = (row[3] as! Int64)
                let ricoverati = (row[4] as! Int64)
                let isolamentoDomiciliare = (row[5] as! Int64)
                let terapiaIntensiva = (row[6] as! Int64)
                let tamponiEffettuati = (row[7] as! Int64)
                let totalePositivi = (row[8] as! Int64)
                
                let result :(Date,Int64,Int64,Int64,Int64,Int64,Int64,Int64,Int64) = (dateObj, contagi,decessi,guariti,ricoverati,isolamentoDomiciliare,terapiaIntensiva,tamponiEffettuati,totalePositivi)
                
                return result
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func setAndamento(andamento: Andamento){
        do {
            let db = try Connection(path, readonly: false)
            
            var dateString = "\(andamento.data)"
            let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
            dateString.removeSubrange(range)
            let dateObj = dateString.toDate()
            
            let dateTable = Table("DATECAMPIONE")
            var data = Expression<Date>("data")
            
            let insertData = dateTable.insert(data <- dateObj)
            
            let andamentoTable = Table("ANDAMENTO")
            data = Expression<Date>("dataAndamento")
            let regione = Expression<String>("regione")
            let contagi = Expression<String>("contagi")
            let decessi = Expression<String>("decessi")
            let guariti = Expression<String>("guariti")
            let ricoverati = Expression<String>("ricoverati")
            let isolamentoDomiciliare = Expression<String>("isolamentoDomiciliare")
            let terapiaIntensiva = Expression<String>("terapiaIntensiva")
            let tamponiEffettuati = Expression<String>("tamponiEffettuati")
            let totalePositivi = Expression<String>("totalePositivi")
            
            let insertAndamento = andamentoTable.insert(data <- dateObj, regione <- andamento.regione,contagi <- "\(andamento.contagi)", decessi <- "\(andamento.decessi)", guariti <- "\(andamento.guariti)", ricoverati <- "\(andamento.ricoverati)", isolamentoDomiciliare <- "\(andamento.isolamentoDomiciliare)", terapiaIntensiva <- "\(andamento.terapiaIntensiva)", tamponiEffettuati <- "\(andamento.tamponiEffettuati)", totalePositivi <- "\(andamento.totalePositivi)")
            
            
            try db.run(insertData)
            try db.run(insertAndamento)
            
            
        } catch {
            print("Unexpected error: \(error)")
        }
    }
    
    public func setContagio(contagio: Contagio) {
        do {
            let db = try Connection(path, readonly: false)
            
            var dateString = "\(contagio.data)"
            let range = dateString.index(dateString.startIndex, offsetBy: 10)..<dateString.endIndex
            dateString.removeSubrange(range)
            let dateObj = dateString.toDate()
            
            var check = false
            
            for date in getDataArray() {
                if date == contagio.data {
                    check = true
                    break
                }
            }
            
            if check == false {
                let dateTable = Table("DATECAMPIONE")
                let data = Expression<Date>("data")
                let insertData = dateTable.insert(data <- dateObj)
                try db.run(insertData)
            }
            
            let contagioTable = Table("CONTAGIO")
            let data = Expression<Date>("data")
            let provincia = Expression<String>("provincia")
            let casi = Expression<String>("casi")
            
            let newContagioData = contagioTable.insert(data <- dateObj, provincia <- contagio.provincia, casi <- "\(contagio.numeroCasi)" )
            try db.run(newContagioData)
        }  catch {
            print("Unexpected error: \(error)")
        }
    }
    
}




extension DBController {
    func applicationDocumentsDirectory() {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "it.ada" in the application's documents directory.
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print(url.absoluteString)
        }
    }
}




