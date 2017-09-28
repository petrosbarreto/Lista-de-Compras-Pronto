//
//  ItemEntity+CoreDataProperties.swift
//  ListaCompras
//
//  Created by Renan Soares Germano on 28/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//
//

import Foundation
import CoreData


extension ItemEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemEntity> {
        return NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
    }

    @NSManaged public var quantidade: Int32
    @NSManaged public var precoUnitario: Float
    @NSManaged public var produto: ProdutoEntity?

}
