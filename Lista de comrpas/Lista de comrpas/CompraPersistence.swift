//
//  CompraPersistence.swift
//  ListaCompras
//
//  Created by Renan Soares Germano on 28/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import CoreData

class CompraPersistence{
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
    
    func create(nome: String, itens: NSSet) -> CompraEntity{
        let entity = NSEntityDescription.entity(forEntityName: "Compra", in: self.managedContext)!
        let novaCompra = NSManagedObject(entity: entity, insertInto: self.managedContext) as! CompraEntity
        novaCompra.nome = nome
        novaCompra.addToItens(itens)
        self.saveContext()
        return novaCompra
    }
    
    func read() -> [Compra]{
        var result: [Compra] = [Compra]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CompraEtity")
        do{
            result = try self.managedContext.fetch(fetchRequest) as! [Compra]
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result
    }
    
    func delete(compra: CompraEntity){
        self.managedContext.delete(compra)
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
