//
//  DBController.swift
//  UTaste
//
//  Created by Andrea Bello on 08/02/2019.
//  Copyright © 2019 Boeing 752. All rights reserved.
//
/*
import Foundation
import UIKit
import SQLite
import SQLite3

class DBController: NSObject {
    static let shared = DBController()
    
    //private let fileManager = FileManager.default
    let path = Bundle.main.path(forResource: "ProgettoBD", ofType: "db")!
    
    public var ingredients: [Ingredient] = []
    
    override init() {
        super.init()
        //print("DBController init")
        
        ingredients = self.getIngredients()
    }
    
    private func getIngredients() -> [Ingredient] {
        do {
            let db = try Connection(path, readonly: true)
            
            /*let ingredient = Table("ingredient")
            let all = Array(try db.prepare(ingredient))
            //let enName = Expression<String>("enName")
            return all.map{ row in
                return row[Expression<String>("enName")]
            }*/
            
            let stmt = try db.prepare("SELECT * FROM Ingredient WHERE Ingredient.isActive = 1 ORDER BY Ingredient.enName ASC")
            
            /*for row in stmt {
                print(row[1] as! String)
                dataToReturn.append(row[1] as! String)
            }*/
            
            return stmt.map{ row in
                return Ingredient(id: row[0] as! Int64,
                                  idFlavorDB: row[1] as! Int64,
                                  enName: row[2] as! String,
                                  itName: row[3] as! String,
                                  //idNaturalSource: nil,
                                  idCategory: row[5] as! Int64,
                                  wikiPage: row[6] as! String,
                                  isActive: true)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getMolecules(_ id: Int64) -> [Molecule]{
        do {
            let db = try Connection(path, readonly: true)
            
            let stmt = try db.prepare("SELECT Molecule.* FROM Composed JOIN Ingredient ON Ingredient.id = Composed.idIngredient JOIN Molecule ON Molecule.id = Composed.idMolecule WHERE Ingredient.id = \(id) ORDER BY Molecule.id ASC")
   
            return stmt.map{ row in
                var isSyn = false
                if row[1] as! Int64 == 1 {
                    isSyn = true
                }
                     
                return Molecule(id: row[0] as! Int64,
                                isSynthetic: isSyn,
                                commonName: row[2] as! String,
                                iupacName: row[3] as! String)
            }
            
        } catch {
            print("Unexpected error: \(error)")
        }
        return []
    }
    
    public func getFlavors(_ ids: [Int64], numberOfFlavors: Int) -> [Flavor] {
        do {
            let db = try Connection(path, readonly: true)
            
            var orQueries = ""
            for id in ids{
                orQueries += " OR Ingredient.id = \(id)"
            }
            
            let stmt = try db.prepare("Select Count(Flavor.id) as flavorCount, Flavor.* FROM Flavor JOIN Tastes ON Tastes.idFlavor = Flavor.id JOIN Molecule ON Tastes.idMolecule = Molecule.id JOIN Composed ON Composed.idMolecule = Molecule.id JOIN Ingredient ON Composed.idIngredient = Ingredient.id WHERE Ingredient.id = \(ids[0])\(orQueries) GROUP BY Tastes.idFlavor ORDER BY flavorCount DESC LIMIT \(numberOfFlavors)")
            
            return stmt.map{ row in
                //return (row[0] as! Int64, Flavor(id: row[1] as! Int64, name: row[2] as! String))
                //return Flavor(id: row[1] as! Int64, name: (row[2] as! String).capitalized)
                return Flavor(id: row[1] as! Int64, enName: (row[2] as! String).capitalized, itName: (row[3] as! String).capitalized)
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

*/
