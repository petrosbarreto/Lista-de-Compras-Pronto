//
//  ProdutoPersistence.swift
//  Lista de Compras
//
//  Created by Renan Soares Germano on 27/09/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import CoreData

class ProdutoPersistence{
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
    
    func create(nome: String, descricao: String, foto: String) -> ProdutoEntity{
        let entity = NSEntityDescription.entity(forEntityName: "ProdutoEntity", in: self.managedContext)!
        let novoProduto = NSManagedObject(entity: entity, insertInto: self.managedContext) as! ProdutoEntity
        novoProduto.nome = nome
        novoProduto.descricao = descricao
        novoProduto.foto = foto
        self.saveContext()
        return novoProduto
    }
    
    func read() -> [ProdutoEntity]{
        var result: [ProdutoEntity] = []
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProdutoEntity")
        do{
            result = try self.managedContext.fetch(fetchRequest) as! [ProdutoEntity]
        }catch let error as NSError{
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        return result;
    }
    
    func delete(produto: ProdutoEntity){
        self.managedContext.delete(produto)
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
