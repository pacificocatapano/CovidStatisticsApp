//
//  HomeViewController.swift
//  progettoBD
//
//  Created by Pacifico Catapano on 30/04/2020.
//  Copyright © 2020 Pacifico Catapano. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var nome : String?
    var dettagli: String?
    @IBOutlet weak var StanzaCollectionView: UICollectionView!
    let cellId = "SampleCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationItem.title = nome
        // Do any additional setup after loading the view.
        //collectionViewFlow.minimumInteritemSpacing = 36
        self.StanzaCollectionView.register(UINib(nibName: "SampleCell", bundle: nil), forCellWithReuseIdentifier: cellId)
        
        self.StanzaCollectionView.delegate = self
        self.StanzaCollectionView.dataSource = self
        
    }
    let collectionViewFlow = UICollectionViewFlowLayout()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Test = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
//        Test.layer.cornerRadius = 15
        return Test
    }
    

}
