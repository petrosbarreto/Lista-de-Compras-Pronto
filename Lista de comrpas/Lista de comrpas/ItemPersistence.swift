//
//  ItemPersistence.swift
//  ListaCompras
//
//  Created by Renan Soares Germano on 28/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import CoreData

class ItemPersistence{
    //MARK: Properties
    private var managedContext: NSManagedObjectContext!
    
    //MARK: Initializers
    init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{
            print("Error while getting the AppDelegate instance.")
            return
        }
        self.managedContext = appDelegate.persistentContainer.viewContext
    }
    
    func create(produto: ProdutoEntity, quantidade: Int, precoUnitario: Float) -> ItemEntity{
        let entity = NSEntityDescription.entity(forEntityName: "ItemEntity", in: self.managedContext)!
        let novoItem = NSManagedObject(entity: entity, insertInto: self.managedContext) as! ItemEntity
        novoItem.produto = produto
        novoItem.quantidade = Int32(quantidade)
        novoItem.precoUnitario = precoUnitario
        self.saveContext()
        return novoItem
    }
    
    func read() -> [ItemEntity]{
        var result: [ItemEntity] = [ItemEntity]()
        let fetchRequest = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        do{
            result = try self.managedContext.fetch(fetchRequest) as! [ItemEntity]
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    
    func delete(item: ItemEntity){
        self.managedContext.delete(item)
        self.saveContext()
    }
    
    private func saveContext(){
        do {
            try self.managedContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}
