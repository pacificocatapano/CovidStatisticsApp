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
    
    let dbc = DBController.shared
    var regioneAggiunta : Andamento = Andamento()
    var regioneArray : [Regioni] = []
    var dateArray : [Date] = []
    var andamento : [Andamento] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        dateArray = dbc.getDataArray()
        andamento = dbc.getAndamento()
        
        titleLabel.text = regioneAggiunta.regione
        labelDecessi(selectedDate: regioneAggiunta.data)
        labelGuariti(selectedDate: regioneAggiunta.data)
        labelCasiTotali(selectedDate: regioneAggiunta.data)
        labelPositivi(selectedDate: regioneAggiunta.data)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func okButton(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "aggiungiDati") as! AggiungiDatiViewController
        self.dismiss(animated: true, completion: {
            vc.ok = true
            //vc.dismissVc()
            vc.viewDidLoad()
        })
        
    }

    //MARK: - AttualmentePositivi
    func labelPositivi(selectedDate: Date){
        attualmentePositiviLabel.text = "\(Int(attualmentePositivi(selectedDate: selectedDate)))"
        
        let deltaPositivi = String(format: "%.2f", variazioneAttualmentePositivi(selectedDate: selectedDate))
        let variazioneNumericaAttualmentePositivi : Int = (regioneAggiunta.totalePositivi) - Int( attualmentePositivi(selectedDate: dateArray[dateArray.count - 2]))
        if variazioneAttualmentePositivi(selectedDate: selectedDate) > 0 {
            variazionePositiviLabel.text = "+\(variazioneNumericaAttualmentePositivi)  (+\(deltaPositivi)%)"
        } else {
            variazionePositiviLabel.text = "\(variazioneNumericaAttualmentePositivi)  (\(deltaPositivi)%)"
        }
    }
    
    func attualmentePositivi(selectedDate : Date) -> Float {
        var result: Float = 0
        
        for and in andamento where and.data == selectedDate && and.regione == regioneAggiunta.regione {
            result += Float(and.totalePositivi)
        }

        return result
    }
    
    func variazioneAttualmentePositivi(selectedDate: Date) -> Float {
        var result: Float = 0
        let attPositivi = regioneAggiunta.totalePositivi
        if selectedDate == dateArray.first {
            result = attualmentePositivi(selectedDate: selectedDate)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - 2]
        let positiviGiornoPrima = attualmentePositivi(selectedDate: giornoPrima)
    
        result = (((Float(attPositivi) - positiviGiornoPrima) * 100)/( positiviGiornoPrima ))
        return result
    }
    
    //MARK: - CasiTotali
    func labelCasiTotali( selectedDate : Date){
        casiTotaliLabel.text = "\(Int(casiTotali(selectedDate: selectedDate)))"
        
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
        if selectedDate == dateArray.first {
            result = casiTotali(selectedDate: selectedDate)
            return result
        }
        let giornoPrima = dateArray[dateArray.count - 2]
        let casiTotaliGiornoPrima = casiTotali(selectedDate: giornoPrima)
    
        result = (((casiTotaliOggi - casiTotaliGiornoPrima) * 100)/( casiTotaliGiornoPrima ))
        return result
    }
    //END
    
    //MARK: - Decessi Ultimo Giorno
    func labelDecessi(selectedDate : Date){
        decessiLabel.text = "\(Int(decessi(selectedDate: selectedDate)))"
        
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
        guaritiLabel.text = "\(Int(guariti(selectedDate:selectedDate)))"
        
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
