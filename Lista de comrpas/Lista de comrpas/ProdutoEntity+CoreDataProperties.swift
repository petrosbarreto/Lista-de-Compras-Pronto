//
//  ProdutoEntity+CoreDataProperties.swift
//  Lista de Compras
//
//  Created by Renan Soares Germano on 27/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//
//

import UIKit
import CoreData


extension ProdutoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProdutoEntity> {
        return NSFetchRequest<ProdutoEntity>(entityName: "ProdutoEntity")
    }

    @NSManaged public var nome: String?
    @NSManaged public var descricao: String?
    @NSManaged public var foto: String?

}
