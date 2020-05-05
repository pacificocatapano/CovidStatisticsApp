//
//  InfoRegioniProvinceViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 04/05/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class InfoRegioniProvinceViewController: UIViewController, UISearchBarDelegate, UISearchControllerDelegate {

    @IBOutlet weak var searchBarInfoRegioniProvince: UISearchBar!
    @IBOutlet weak var newData: UIButton!
    /*
    @IBAction func cancelAction(_ sender: Any) {

    }
    @IBOutlet weak var cancelButton: UIButton!
   */
    override func viewDidLoad() {
        super.viewDidLoad()
        newData.layer.cornerRadius = 10
        searchBarInfoRegioniProvince.delegate = self
    }
    
/*        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
           if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
               let keyboardHeight = keyboardFrame.cgRectValue.height
               UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .init(), animations: { () -> Void in
                   self.view.frame.origin = CGPoint.init(x: self.view.frame.origin.x, y: UIApplication.shared.keyWindow!.safeAreaInsets.top)
               }, completion: nil)
           }
       }

       @objc func keyboardWillHide() {
           animateToCenter()
       }

    func animateToCenter() {
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: .init(), animations: { () -> Void in
            self.view.center = CGPoint.init(x: self.view.frame.midX, y: self.view.frame.maxY - self.view.frame.height * (0.05 - 0.5))
        }, completion: nil)*/
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Do some search stuff
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBarInfoRegioniProvince.text = ""
        //inserire dismiss keyboard
    }
    
}

