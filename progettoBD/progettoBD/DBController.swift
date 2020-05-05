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
    let path = Bundle.main.path(forResource: "data", ofType: "sqlite")!
    
    override init() {
        super.init()
        //print("DBController init")
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
                //return (row[0] as! Int64, Flavor(id: row[1] as! Int64, name: row[2] as! String))
                //return Flavor(id: row[1] as! Int64, name: (row[2] as! String).capitalized)
                
                let dateObj = (row[0] as! String).toDate()
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
                
                let dateObj = (row[0] as! String).toDate()
                
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
                
                let dateObj = (row[0] as! String).toDate()
                return dateObj
            }
            
            
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
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


