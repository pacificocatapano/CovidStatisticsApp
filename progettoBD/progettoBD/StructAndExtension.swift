//
//  StructAndExtension.swift
//  progettoBD
//
//  Created by Salvatore Giugliano on 03/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import Foundation
import UIKit

struct Province : Codable {
    
    var codiceProvincia : Int
    var denominazioneProvincia : String
    var siglaProvincia : String
    var regioneAppartenenza : String
    var latitudine : Float
    var longitudine : Float
    var abitanti : Int
    var densitàAbitanti : Float
    var estensione : Float
    var numeroDiScuole : Int
    var numeroDiAlberghi : Int
    var numeroDiOspedali : Int
    var numeroSpostamentiInterni : Int
    var numeroSpostamnetiEsterni : Int
    
    init() {
        self.codiceProvincia = Int()
        self.denominazioneProvincia = String()
        self.siglaProvincia = String()
        self.regioneAppartenenza = String()
        self.latitudine = Float()
        self.longitudine = Float()
        self.abitanti = Int()
        self.densitàAbitanti = Float()
        self.estensione = Float()
        self.numeroDiScuole = Int()
        self.numeroDiAlberghi = Int()
        self.numeroDiOspedali = Int()
        self.numeroSpostamentiInterni = Int()
        self.numeroSpostamnetiEsterni = Int()
        
    }
    
    init(codiceProvincia: Int, denominazioneProvincia:String, siglaProvincia : String, regioneAppartenenza: String,latitudine: Float, longitudine: Float, abitanti: Int, densitàAbitanti: Float, estensione : Float,numeroDiScuole: Int, numeroDiAlberghi: Int, numeroDiOspedali: Int, numeroSpostamentiInterni: Int, numeroSpostamnetiEsterni : Int) {
        self.codiceProvincia = codiceProvincia
        self.denominazioneProvincia = denominazioneProvincia
        self.siglaProvincia = siglaProvincia
        self.regioneAppartenenza = regioneAppartenenza
        self.latitudine = latitudine
        self.longitudine = longitudine
        self.abitanti = abitanti
        self.densitàAbitanti = densitàAbitanti
        self.estensione = estensione
        self.numeroDiScuole = numeroDiScuole
        self.numeroDiAlberghi = numeroDiAlberghi
        self.numeroDiOspedali = numeroDiOspedali
        self.numeroSpostamentiInterni = numeroSpostamentiInterni
        self.numeroSpostamnetiEsterni = numeroSpostamnetiEsterni
    }
    
    enum CodingKeys: String, CodingKey {
        case codiceProvincia
        case denominazioneProvincia
        case siglaProvincia
        case regioneAppartenenza
        case latitudine
        case longitudine
        case abitanti
        case densitàAbitanti
        case estensione
        case numeroDiScuole
        case numeroDiAlberghi
        case numeroDiOspedali
        case numeroSpostamentiInterni
        case numeroSpostamnetiEsterni
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.codiceProvincia = try container.decode(Int.self, forKey: .codiceProvincia)
        self.denominazioneProvincia = try container.decode(String.self, forKey: .denominazioneProvincia)
        self.siglaProvincia = try container.decode(String.self, forKey: .siglaProvincia)
        self.regioneAppartenenza = try container.decode(String.self, forKey: .regioneAppartenenza)
        self.latitudine = try container.decode(Float.self, forKey: .latitudine)
        self.longitudine = try container.decode(Float.self, forKey: .longitudine)
        self.abitanti = try container.decode(Int.self, forKey: .abitanti)
        self.densitàAbitanti = try container.decode(Float.self, forKey: .densitàAbitanti)
        self.estensione = try container.decode(Float.self, forKey: .estensione)
        self.numeroDiScuole = try container.decode(Int.self, forKey: .numeroDiScuole)
        self.numeroDiAlberghi = try container.decode(Int.self, forKey: .numeroDiAlberghi)
        self.numeroDiOspedali = try container.decode(Int.self, forKey: .numeroDiOspedali)
        self.numeroSpostamentiInterni = try container.decode(Int.self, forKey: .numeroSpostamentiInterni)
        self.numeroSpostamnetiEsterni = try container.decode(Int.self, forKey: .numeroSpostamnetiEsterni)
    }
    
    func encode(to encoder: Encoder ) throws {
        var conteiner = encoder.container(keyedBy: CodingKeys.self)
        try conteiner.encode(codiceProvincia, forKey: .codiceProvincia)
        try conteiner.encode(denominazioneProvincia, forKey: .denominazioneProvincia)
        try conteiner.encode(siglaProvincia, forKey: .siglaProvincia)
        try conteiner.encode(regioneAppartenenza, forKey: .regioneAppartenenza)
        try conteiner.encode(latitudine, forKey: .latitudine)
        try conteiner.encode(longitudine, forKey: .longitudine)
        try conteiner.encode(abitanti, forKey: .abitanti)
        try conteiner.encode(densitàAbitanti, forKey: .densitàAbitanti)
        try conteiner.encode(estensione, forKey: .estensione)
        try conteiner.encode(numeroDiScuole, forKey: .numeroDiScuole)
        try conteiner.encode(numeroDiAlberghi, forKey: .numeroDiAlberghi)
        try conteiner.encode(numeroDiOspedali, forKey: .numeroDiOspedali)
        try conteiner.encode(numeroSpostamentiInterni, forKey: .numeroSpostamentiInterni)
        try conteiner.encode(numeroSpostamnetiEsterni, forKey: .numeroSpostamnetiEsterni)
    }
}

struct Regioni : Codable {
    
    var codiceRegione : Int
    var denominazioneRegione : String
    var abitanti : Int
    var densitàAbitanti : Float
    var numeroDiAutostrade : Int
    var numeroDiSuperStrade : Int
    var numeroDiAereoporti : Int
    var numeroDiStazioni : Int
    
    init() {
        self.codiceRegione = Int()
        self.denominazioneRegione = String()
        self.abitanti = Int()
        self.densitàAbitanti = Float()
        self.numeroDiAutostrade = Int()
        self.numeroDiSuperStrade = Int()
        self.numeroDiAereoporti = Int()
        self.numeroDiStazioni = Int()
    }
    
    init(codiceRegione: Int, denominazioneRegione:String, abitanti: Int, densitàAbitanti: Float, numeroDiAutostrade: Int, numeroDiSuperStrade: Int, numeroDiAereoporti: Int, numeroDiStazioni: Int) {
        self.codiceRegione = codiceRegione
        self.denominazioneRegione = denominazioneRegione
        self.abitanti = abitanti
        self.densitàAbitanti = densitàAbitanti
        self.numeroDiAutostrade = numeroDiAutostrade
        self.numeroDiSuperStrade = numeroDiSuperStrade
        self.numeroDiAereoporti = numeroDiAereoporti
        self.numeroDiStazioni = numeroDiStazioni
    }
    
    enum CodingKeys: String, CodingKey {
        case codiceRegione
        case denominazioneRegione
        case abitanti
        case densitàAbitanti
        case numeroDiAutostrade
        case numeroDiSuperStrade
        case numeroDiAereoporti
        case numeroDiStazioni
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.codiceRegione = try container.decode(Int.self, forKey: .codiceRegione)
        self.denominazioneRegione = try container.decode(String.self, forKey: .denominazioneRegione)
        self.abitanti = try container.decode(Int.self, forKey: .abitanti)
        self.densitàAbitanti = try container.decode(Float.self, forKey: .densitàAbitanti)
        self.numeroDiAutostrade = try container.decode(Int.self, forKey: .numeroDiAutostrade)
        self.numeroDiSuperStrade = try container.decode(Int.self, forKey: .numeroDiSuperStrade)
        self.numeroDiAereoporti = try container.decode(Int.self, forKey: .numeroDiAereoporti)
        self.numeroDiStazioni = try container.decode(Int.self, forKey: .numeroDiStazioni)
    }
    
    func encode(to encoder: Encoder ) throws {
        var conteiner = encoder.container(keyedBy: CodingKeys.self)
        try conteiner.encode(codiceRegione, forKey: .codiceRegione)
        try conteiner.encode(denominazioneRegione, forKey: .denominazioneRegione)
        try conteiner.encode(abitanti, forKey: .abitanti)
        try conteiner.encode(densitàAbitanti, forKey: .densitàAbitanti)
        try conteiner.encode(numeroDiAutostrade, forKey: .numeroDiAutostrade)
        try conteiner.encode(numeroDiSuperStrade, forKey: .numeroDiSuperStrade)
        try conteiner.encode(numeroDiAereoporti, forKey: .numeroDiAereoporti)
        try conteiner.encode(numeroDiStazioni, forKey: .numeroDiStazioni)
    }
}

struct Contagio : Codable {
    var data : Date
    var provincia : String
    var numeroCasi : Int
    
    init() {
        self.data = Date()
        self.provincia = String()
        self.numeroCasi = Int()
    }
    
    init(data: Date, provincia: String, numeroCasi: Int) {
        self.data = data
        self.provincia = provincia
        self.numeroCasi = numeroCasi
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case provincia
        case numeroCasi
    }
    
    public init(from decoder: Decoder) throws {
        let conteiner = try decoder.container(keyedBy: CodingKeys.self)
        
        let dataType = try conteiner.decode(Data.self, forKey: .data)
        self.data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataType) as! Date
        
        self.provincia = try conteiner.decode(String.self, forKey: .provincia)
        self.numeroCasi = try conteiner.decode(Int.self, forKey: .numeroCasi)
    }
    
    func encode(to encoder: Encoder) throws {
        var conteiner = encoder.container(keyedBy: CodingKeys.self)
        
        let dataType = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        try conteiner.encode(dataType, forKey: .data)
        
        try conteiner.encode(provincia, forKey: .provincia)
        try conteiner.encode(numeroCasi, forKey: .numeroCasi)
    }
}

struct Andamento: Codable {
    
    var data: Date
    var regione: String
    var contagi : Int
    var decessi : Int
    var guariti : Int
    var ricoverati : Int
    var isolamentoDomiciliare : Int
    var terapiaIntensiva : Int
    var tamponiEffettuati : Int
    var totalePositivi : Int

    init() {
        self.data = Date()
        self.regione = String()
        self.contagi = Int()
        self.decessi = Int()
        self.guariti = Int()
        self.ricoverati = Int()
        self.isolamentoDomiciliare = Int()
        self.terapiaIntensiva = Int()
        self.tamponiEffettuati = Int()
        self.totalePositivi = Int()
    }
    
    init(data: Date, regione: String, contagi: Int, decessi: Int, guariti: Int, ricoverati: Int, isolamentoDomiciliare: Int, terapiaIntensiva: Int, tamponiEffettuati: Int, totalePositivi: Int ) {
        self.data = data
        self.regione = regione
        self.contagi = contagi
        self.decessi = decessi
        self.guariti = guariti
        self.ricoverati = ricoverati
        self.isolamentoDomiciliare = isolamentoDomiciliare
        self.terapiaIntensiva = terapiaIntensiva
        self.tamponiEffettuati = tamponiEffettuati
        self.totalePositivi = totalePositivi
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case regione
        case contagi
        case decessi
        case guariti
        case ricoverati
        case isolamentoDomiciliare
        case terapiaIntensiva
        case tamponiEffettuati
        case totalePositivi
    }
    
     public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let dataType = try container.decode(Data.self, forKey: .data)
        self.data = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(dataType) as! Date
        
        self.regione = try container.decode(String.self, forKey: .regione)
        self.contagi = try container.decode(Int.self, forKey: .contagi)
        self.decessi = try container.decode(Int.self, forKey: .decessi)
        self.guariti = try container.decode(Int.self, forKey: .guariti)
        self.ricoverati = try container.decode(Int.self, forKey: .ricoverati)
        self.isolamentoDomiciliare = try container.decode(Int.self, forKey: .isolamentoDomiciliare)
        self.terapiaIntensiva = try container.decode(Int.self, forKey: .terapiaIntensiva)
        self.tamponiEffettuati = try container.decode(Int.self, forKey: .tamponiEffettuati)
        self.totalePositivi = try container.decode(Int.self, forKey: .totalePositivi)
    }
    
    func encode(to encoder : Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        let dataType = try NSKeyedArchiver.archivedData(withRootObject: data, requiringSecureCoding: false)
        try container.encode(dataType, forKey: .data)
        
        try container.encode(regione, forKey: .regione)
        try container.encode(contagi, forKey: .contagi)
        try container.encode(decessi, forKey: .decessi)
        try container.encode(guariti, forKey: .guariti)
        try container.encode(ricoverati, forKey: .ricoverati)
        try container.encode(isolamentoDomiciliare, forKey: .isolamentoDomiciliare)
        try container.encode(terapiaIntensiva, forKey: .terapiaIntensiva)
        try container.encode(tamponiEffettuati, forKey: .tamponiEffettuati)
        try container.encode(totalePositivi, forKey: .totalePositivi)
    }
}

struct RegioniEAndamento {
    var regione : String
    var contagiTotali: Int
    
    init() {
        self.regione = String()
        self.contagiTotali = Int()
    }
    
    init(regione: String, contagiTotali: Int) {
        self.regione = regione
        self.contagiTotali = contagiTotali
    }
    
   
}


extension UISearchBar {
    
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}



extension String {
  func toDate(withFormat format: String = "yyyy-MM-dd") -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    guard let date = dateFormatter.date(from: self) else {
      preconditionFailure("Take a look to your format")
    }
    let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
    return modifiedDate
  }
}
