//
//  CompraEntity+CoreDataProperties.swift
//  ListaCompras
//
//  Created by Renan Soares Germano on 28/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//
//

import Foundation
import CoreData


extension CompraEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompraEntity> {
        return NSFetchRequest<CompraEntity>(entityName: "CompraEntity")
    }

    @NSManaged public var nome: String?
    @NSManaged public var itens: NSSet?

}

// MARK: Generated accessors for itens
extension CompraEntity {

    @objc(addItensObject:)
    @NSManaged public func addToItens(_ value: ItemEntity)

    @objc(removeItensObject:)
    @NSManaged public func removeFromItens(_ value: ItemEntity)

    @objc(addItens:)
    @NSManaged public func addToItens(_ values: NSSet)

    @objc(removeItens:)
    @NSManaged public func removeFromItens(_ values: NSSet)

}
