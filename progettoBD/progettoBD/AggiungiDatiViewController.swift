//
//  AggiungiDatiViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit


class AggiungiDatiViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIScrollViewDelegate {
    
    
    var ok = false
    /*
     @IBAction func confirmButton(_ sender: Any) {
     performSegue(withIdentifier: "", sender: nil)
     }
     */
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var dataPickerView: UIPickerView!
    var pickerViewIndex  = 2
    @IBOutlet weak var date: UIDatePicker!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var selectRegionProvince: UILabel!
    @IBOutlet weak var ConfirmButton: UIButton!
    //******START TEXT FIELDS ******
    @IBOutlet weak var decessiTextField: UITextField!
    @IBOutlet weak var guaritiTextField: UITextField!
    @IBOutlet weak var attualmentePositiviTextField: UITextField!
    @IBOutlet weak var ricoveratiTextFiel: UITextField!
    @IBOutlet weak var terapiaIntensivaTextFiel: UITextField!
    @IBOutlet weak var isolamentoDomiciliareTextField: UITextField!
    @IBOutlet weak var tamponiEffettuati: UITextField!
    //****END TEXT FIELDS ****
    //MARK: -Label
    @IBOutlet weak var positiviLabel: UILabel!
    @IBOutlet weak var guaritiLabel: UILabel!
    @IBOutlet weak var decessiLabel: UILabel!
    @IBOutlet weak var ricoveratiLabel: UILabel!
    @IBOutlet weak var terapiaIntensivaLabel: UILabel!
    @IBOutlet weak var isolamentoDomiciliareLabel: UILabel!
    @IBOutlet weak var tamponiEffettuatiLabel: UILabel!
    
    @IBOutlet weak var stackView: UIStackView!
    
    
    let dbc = DBController.shared
    var regioniArray : [Regioni] = []
    var provinceArray : [Province] = []
    var andamentoArray : [Andamento] = []
    var dateArray : [Date] = []
    
    var textFieldNumber : Int = 0
    let bar = UIToolbar()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ConfirmButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
        date.minimumDate = dateArray.last
        date.maximumDate = Date()
        dataPickerView.selectRow(pickerViewIndex, inComponent: 0, animated: true)
        scrollView.delegate = self
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        ConfirmButton.backgroundColor = ColorManager.mainRedColor
        ConfirmButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        ConfirmButton.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        ConfirmButton.layer.shadowOpacity = 6.0
        ConfirmButton.layer.shadowRadius = 10.0
        ConfirmButton.layer.masksToBounds = false
        ConfirmButton.layer.cornerRadius = 10.0
        
        decessiTextField.keyboardType = .numberPad
        guaritiTextField.keyboardType = .numberPad
        attualmentePositiviTextField.keyboardType = .numberPad
        ricoveratiTextFiel.keyboardType = .numberPad
        terapiaIntensivaTextFiel.keyboardType = .numberPad
        isolamentoDomiciliareTextField.keyboardType = .numberPad
        tamponiEffettuati.keyboardType = .numberPad
        
        let next = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(doneTapped))
        bar.items = [next]
        bar.sizeToFit()
        bar.tintColor = ColorManager.mainRedColor
        decessiTextField.inputAccessoryView = bar
        guaritiTextField.inputAccessoryView = bar
        attualmentePositiviTextField.inputAccessoryView = bar
        ricoveratiTextFiel.inputAccessoryView = bar
        terapiaIntensivaTextFiel.inputAccessoryView = bar
        isolamentoDomiciliareTextField.inputAccessoryView = bar
        tamponiEffettuati.inputAccessoryView = bar
        
        ConfirmButton.addTarget(self, action: #selector(goToResultPage), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        if ok == true {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 || scrollView.contentOffset.x < 0 {
            scrollView.contentOffset.x = 0
        }
    }
    
    @IBAction func segmentedAction(_ sender: Any) {
        let getIndex = segmentedControl.selectedSegmentIndex
        switch getIndex {
        case 0:
            
            attualmentePositiviTextField.endEditing(true)
            selectRegionProvince.text = "Seleziona regioni"
            dataPickerView.reloadAllComponents()
            dataPickerView.selectRow(pickerViewIndex, inComponent: 0, animated: true)
            decessiTextField.isHidden = false
            guaritiTextField.isHidden = false
            tamponiEffettuati.isHidden = false
            terapiaIntensivaTextFiel.isHidden = false
            ricoveratiTextFiel.isHidden = false
            isolamentoDomiciliareTextField.isHidden = false
            decessiLabel.isHidden = false
            guaritiLabel.isHidden = false
            positiviLabel.text = "Nuovi Positivi"
            ricoveratiLabel.isHidden = false
            terapiaIntensivaLabel.isHidden = false
            tamponiEffettuatiLabel.isHidden = false
            isolamentoDomiciliareLabel.isHidden = false
        case 1:
            attualmentePositiviTextField.endEditing(true)
            selectRegionProvince.text = "Seleziona province"
            dataPickerView.reloadAllComponents()
            dataPickerView.selectRow(pickerViewIndex, inComponent: 0, animated: true)
            decessiTextField.isHidden = true
            guaritiTextField.isHidden = true
            tamponiEffettuati.isHidden = true
            terapiaIntensivaTextFiel.isHidden = true
            attualmentePositiviTextField.text = ""
            ricoveratiTextFiel.isHidden = true
            isolamentoDomiciliareTextField.isHidden = true
            decessiLabel.isHidden = true
            guaritiLabel.isHidden = true
            positiviLabel.text = "Casi Totali"
            ricoveratiLabel.isHidden = true
            terapiaIntensivaLabel.isHidden = true
            tamponiEffettuatiLabel.isHidden = true
            isolamentoDomiciliareLabel.isHidden = true
        default:
            print("Error segmented control")
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if segmentedControl.selectedSegmentIndex == 0 {
            return regioniArray.count
        } else {
            return provinceArray.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if segmentedControl.selectedSegmentIndex == 0 {
            return regioniArray[row].denominazioneRegione
        } else {
            return provinceArray[row].denominazioneProvincia
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        pickerViewIndex = row
    }
    
    
    @objc func keyboardWillShow(notification:NSNotification){
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func doneTapped() {
        if textFieldNumber == 0 {
            if segmentedControl.selectedSegmentIndex == 0 {
                guaritiTextField.becomeFirstResponder()
            } else {
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(goToResultPage))
                bar.items = [done]
            }
        } else if textFieldNumber == 1 {
            decessiTextField.becomeFirstResponder()
        } else if textFieldNumber == 2 {
            ricoveratiTextFiel.becomeFirstResponder()
        } else if textFieldNumber == 3 {
            terapiaIntensivaTextFiel.becomeFirstResponder()
        } else if textFieldNumber == 4 {
            isolamentoDomiciliareTextField.becomeFirstResponder()
        } else if textFieldNumber == 5 {
            tamponiEffettuati.becomeFirstResponder()
            let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(goToResultPage))
            bar.items = [done]
        }
    }
    
    @objc func goToResultPage(){
        
        
        if segmentedControl.selectedSegmentIndex == 0 {
            for and in andamentoArray where and.regione == regioniArray[pickerViewIndex].denominazioneRegione && and.data == date.date {
                let alertView = UIAlertController()
                alertView.title = "Dati già presenti"
                alertView.message = "I dati del giorno \(and.data) in \(and.regione) sono già presenti"
                alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            }
            
        } else {
            for con in dbc.getContagio() where con.provincia == "\(provinceArray[pickerViewIndex].codiceProvincia)" && con.data == date.date{
                let alertView = UIAlertController()
                alertView.title = "Dati già presenti"
                alertView.message = "I dati del giorno \(con.data) in \(provinceArray[pickerViewIndex].denominazioneProvincia) sono già presenti"
                alertView.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            }
        }
        self.performSegue(withIdentifier: "ShowAddedResultRegione", sender: self)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if segmentedControl.selectedSegmentIndex == 0 {
            if textField == attualmentePositiviTextField {
                let next = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(doneTapped))
                bar.items = [next]
                textFieldNumber = 0
            } else if textField == guaritiTextField {
                textFieldNumber = 1
            }  else if textField == decessiTextField {
                textFieldNumber = 2
            } else if textField == ricoveratiTextFiel {
                textFieldNumber = 3
            } else if textField == terapiaIntensivaTextFiel {
                textFieldNumber = 4
            } else if textField == isolamentoDomiciliareTextField{
                textFieldNumber = 5
            } else if textField == tamponiEffettuati {
                textFieldNumber = 6
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(goToResultPage))
                bar.items = [done]
            }
        } else {
            if textField == attualmentePositiviTextField {
                let done = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(goToResultPage))
                bar.items = [done]
                textFieldNumber = 6
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowAddedResultRegione" {
            let controller = segue.destination as! DatiAppenaAggiuntiViewController
            
            if segmentedControl.selectedSegmentIndex == 0 {
                controller.regioneArray = regioniArray
                andamentoArray = dbc.getAndamentoLastDate()
                
                
                var decessi = Int(decessiTextField.text ?? "") ?? 0
                var positivi = Int(attualmentePositiviTextField.text ?? "") ?? 0
                var guariti = Int(guaritiTextField.text ?? "") ?? 0
                var ricoverati = Int(ricoveratiTextFiel.text ?? "") ?? 0
                var terapiaIntensiva = Int(terapiaIntensivaTextFiel.text ?? "") ?? 0
                var isolamento = Int(isolamentoDomiciliareTextField.text ?? "") ?? 0
                var tamponi = Int(tamponiEffettuati.text ?? "") ?? 0
                
                for and in andamentoArray where and.regione == regioniArray[pickerViewIndex].denominazioneRegione {
                    decessi += and.decessi
                    positivi += and.totalePositivi
                    guariti += and.guariti
                    ricoverati += and.ricoverati
                    terapiaIntensiva += and.terapiaIntensiva
                    isolamento += and.isolamentoDomiciliare
                    tamponi += and.tamponiEffettuati
                }
                
                let newAndamentoData = Andamento(data: date.date, regione: regioniArray[pickerViewIndex].denominazioneRegione, contagi: decessi + positivi + guariti, decessi: decessi, guariti: guariti, ricoverati: ricoverati, isolamentoDomiciliare: isolamento, terapiaIntensiva: terapiaIntensiva, tamponiEffettuati: tamponi, totalePositivi: positivi)
                
                dbc.setAndamento(andamento: newAndamentoData)
                
                controller.regioneAggiunta = newAndamentoData
            } else {
                controller.provinceArray = provinceArray
                
                let casi = Int(attualmentePositiviTextField.text ?? "") ?? 0
                
                dbc.setContagio(contagio:  Contagio(data: date.date, provincia: provinceArray[pickerViewIndex].denominazioneProvincia, numeroCasi: casi))
                
                controller.provinciaAggiunta = Contagio(data: date.date, provincia: provinceArray[pickerViewIndex].denominazioneProvincia, numeroCasi: casi)
            }
        }
    }
    
    
    /*
     func dismissVc (){
     if ok == true {
     self.dismiss(animated: true, completion: nil)
     }
     }
     */
    
}
