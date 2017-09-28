//
//  CompraEntity+CoreDataClass.swift
//  ListaCompras
//
//  Created by Renan Soares Germano on 28/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CompraEntity)
public class CompraEntity: NSManagedObject {
    var total: Float {
        get{
            var total: Float = 0.0
            (self.itens?.allObjects as! [ItemEntity]).filter{
                total += $0.precoUnitario * Float($0.quantidade); return false
                
            }
            return total
        }
    }
}
