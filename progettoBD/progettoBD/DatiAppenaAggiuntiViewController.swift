//
//  DatiAppenaAggiuntiViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 05/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class DatiAppenaAggiuntiViewController: UIViewController {

    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var attualmentePositiviLabel: UILabel!
    @IBOutlet weak var variazionePositiviLabel: UILabel!
    @IBOutlet weak var casiTotaliLabel: UILabel!
    @IBOutlet weak var variazioneCasiTotaliLabel: UILabel!
    @IBOutlet weak var decessiLabel: UILabel!
    @IBOutlet weak var variazioneDecessiTotaleLabel: UILabel!
    @IBOutlet weak var guaritiLabel: UILabel!
    @IBOutlet weak var varazioneGuaritiLabel: UILabel!
    @IBOutlet weak var attualmentePositiviStack: UIStackView!
    @IBOutlet weak var decessiStack: UIStackView!
    @IBOutlet weak var guaritiStack: UIStackView!
    
    let dbc = DBController.shared
    var regioneAggiunta : Andamento = Andamento()
    var regioneArray : [Regioni] = []
    var dateArray : [Date] = []
    var andamento : [Andamento] = []
    var provinciaAggiunta : Contagio = Contagio()
    var provinceArray : [Province] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateArray = dbc.getDataArray()
        if regioneAggiunta.regione != Andamento().regione {
        andamento = dbc.getAndamento()
        dateArray.append(regioneAggiunta.data)
        
        titleLabel.text = regioneAggiunta.regione
        labelDecessi(selectedDate: regioneAggiunta.data)
        labelGuariti(selectedDate: regioneAggiunta.data)
        labelCasiTotali(selectedDate: regioneAggiunta.data)
        labelPositiviRegione(selectedDate: regioneAggiunta.data)
        // Do any additional setup after loading the view.
        } else if provinciaAggiunta.provincia != Contagio().provincia {
            var nomeProvincia = ""
            for prov in provinceArray where prov.denominazioneProvincia == provinciaAggiunta.provincia {
                nomeProvincia = prov.denominazioneProvincia
            }
            dateArray.append(provinciaAggiunta.data)
            titleLabel.text = nomeProvincia
            attualmentePositiviStack.isHidden = true
            decessiStack.isHidden = true
            guaritiStack.isHidden = true
            labelCasiTotaliProvincia(selectedDate: provinciaAggiunta.data)
        }
    }
    
    @IBAction func okButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "aggiungiDati") as! AggiungiDatiViewController
        self.dismiss(animated: true, completion: {
            self.dbc.setAndamento(andamento: self.regioneAggiunta)
            vc.ok = true
            vc.viewDidLoad()
        })
        
    }
    //MARK: -CasiTotaliProvincia
    func labelCasiTotaliProvincia(selectedDate: Date){
        casiTotaliLabel.text = "\(Int(provinciaAggiunta.numeroCasi))"
        
        let deltaPositivi = String(format: "%.2f", variazioneCasiTotaliProvincia(selectedDate: selectedDate))
        let variazioneNumerica: Int = Int(casiTotaliProvincia(selectedDate: selectedDate) - casiTotaliProvincia(selectedDate: dateArray[dateArray.count - 2]))
        
        if variazioneCasiTotali(selectedDate: selectedDate) > 0 {
            variazioneCasiTotaliLabel.text = "+\(variazioneNumerica)  (+\(deltaPositivi)%)"
        } else {
            variazioneCasiTotaliLabel.text = "\(variazioneNumerica)  (\(deltaPositivi)%)"
        }
    }
    
    func casiTotaliProvincia(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for con in dbc.getContagio() where con.data == selectedDate && con.provincia == "\(provinciaAggiunta.provincia)" {
            result += Float(con.numeroCasi)
        }
        return result
    }
    
    func variazioneCasiTotaliProvincia(selectedDate: Date) -> Float {
        var result: Float = 0
        let casiTotaliOggi = provinciaAggiunta.numeroCasi
        
        let giornoPrima = dateArray[dateArray.count - 2]
        let casiTotaliGiornoPrima = casiTotaliProvincia(selectedDate: giornoPrima)
        
        result = (((Float(casiTotaliOggi) - casiTotaliGiornoPrima) * 100)/( casiTotaliGiornoPrima ))
        return result
    }
    
    //MARK: - AttualmentePositiviRegione
    func labelPositiviRegione(selectedDate: Date){
        attualmentePositiviLabel.text = "\(regioneAggiunta.totalePositivi)"
        
        let deltaPositivi = String(format: "%.2f", variazioneAttualmentePositiviRegione(selectedDate: selectedDate))
        let variazioneNumericaAttualmentePositivi : Int = (regioneAggiunta.totalePositivi) - Int( attualmentePositiviRegione(selectedDate: dateArray[dateArray.count - 2]))
        if variazioneAttualmentePositiviRegione(selectedDate: selectedDate) > 0 {
            variazionePositiviLabel.text = "+\(variazioneNumericaAttualmentePositivi)  (+\(deltaPositivi)%)"
        } else {
            variazionePositiviLabel.text = "\(variazioneNumericaAttualmentePositivi)  (\(deltaPositivi)%)"
        }
    }
    
    func attualmentePositiviRegione(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate && and.regione == regioneAggiunta.regione {
            result += Float(and.totalePositivi)
        }

        return result
    }
    
    func variazioneAttualmentePositiviRegione(selectedDate: Date) -> Float {
        var result: Float = 0
        let attPositivi = regioneAggiunta.totalePositivi
        let giornoPrima = dateArray[dateArray.count - 2]
        let positiviGiornoPrima = attualmentePositiviRegione(selectedDate: giornoPrima)
    
        result = (((Float(attPositivi) - positiviGiornoPrima) * 100)/( positiviGiornoPrima ))
        return result
    }
    
    //MARK: - CasiTotaliRegione
    func labelCasiTotali( selectedDate : Date){
        casiTotaliLabel.text = "\(regioneAggiunta.contagi)"
        
        let deltaPositivi = String(format: "%.2f", variazioneCasiTotali(selectedDate: selectedDate))
        let variazioneNumericaCasiTotali: Int = regioneAggiunta.contagi - Int(casiTotali(selectedDate: dateArray[dateArray.count - 2]))
        if variazioneCasiTotali(selectedDate: selectedDate) > 0 {
            variazioneCasiTotaliLabel.text = "+\(variazioneNumericaCasiTotali)  (+\(deltaPositivi)%)"
        } else {
            variazioneCasiTotaliLabel.text = "\(variazioneNumericaCasiTotali)  (\(deltaPositivi)%)"
        }
    }
    
    func casiTotali(selectedDate : Date) -> Float {
      var result: Float = 0
      
      for and in andamento where and.data == selectedDate && and.regione == regioneAggiunta.regione {
          result += Float(and.contagi)
      }
      return result
    }
    
    func variazioneCasiTotali(selectedDate: Date) -> Float {
        var result: Float = 0
        let casiTotaliOggi = Float(regioneAggiunta.contagi)

        let giornoPrima = dateArray[dateArray.count - 2]
        let casiTotaliGiornoPrima = casiTotali(selectedDate: giornoPrima)
    
        result = (((casiTotaliOggi - casiTotaliGiornoPrima) * 100)/( casiTotaliGiornoPrima ))
        return result
    }
    //END
    
    //MARK: - Decessi Ultimo Giorno
    func labelDecessi(selectedDate : Date){
        decessiLabel.text = "\(regioneAggiunta.decessi)"
        
        let deltaPositivi = String(format: "%.2f", variazioneDecessiFunc(selectedDate: selectedDate))
        let variazioneNumericaDecessi: Int = regioneAggiunta.decessi -  Int(decessi(selectedDate: dateArray[dateArray.count - 2]))
        
        if variazioneDecessiFunc(selectedDate: selectedDate) > 0 {
            variazioneDecessiTotaleLabel.text = "+\(variazioneNumericaDecessi)  (+\(deltaPositivi)%)"
        } else {
            variazioneDecessiTotaleLabel.text = "\(variazioneNumericaDecessi)  (\(deltaPositivi)%)"
        }
    }
    
    func decessi(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate && and.regione == regioneAggiunta.regione {
            result += Float(and.decessi)
        }
        return result
    }
    
    func variazioneDecessiFunc(selectedDate: Date) -> Float {
        var result: Float = 0
        let oggi = Float(regioneAggiunta.decessi)
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
        guaritiLabel.text = "\(regioneAggiunta.guariti)"
        
        let deltaPositivi = String(format: "%.2f", variazioneGuaritiFunc(selectedDate: selectedDate))
        let variazioneNumericaGuariti: Int = regioneAggiunta.guariti - Int( guariti(selectedDate: dateArray[dateArray.count - 2]))
        
        if variazioneGuaritiFunc(selectedDate: selectedDate) > 0 {
            varazioneGuaritiLabel.text = "+\(variazioneNumericaGuariti)  (+\(deltaPositivi)%)"
        } else {
            varazioneGuaritiLabel.text = "\(variazioneNumericaGuariti)  (\(deltaPositivi)%)"
        }
    }
    
    func guariti(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate && and.regione == regioneAggiunta.regione {
            result += Float(and.guariti)
        }
        return result
    }
    
    func variazioneGuaritiFunc(selectedDate: Date) -> Float {
        var result: Float = 0
        let oggi = Float(regioneAggiunta.guariti)
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

}
