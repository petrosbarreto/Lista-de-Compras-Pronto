//
//  Compra.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import Foundation
import os.log

class Compra: NSObject, NSCoding{
    //MARK: Propriedades
    var nome:String
    var itens:[Item]
    var total:Float{
        get{
            var total:Float = 0.0
            for item in itens{
                let subTotal = Float(item.quantidade) * item.precoUnitario
                total = total + Float(subTotal)
            }
            return total
        }
    }
    
    //MARK: Caminhos de arquivamento
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivingURL = DocumentsDirectory.appendingPathComponent("compras")
    
    //MARK: Tipos
    struct PropertyKey{
        static let nome = "nome"
        static let itens = "itens"
    }
    
    //MARK: Inicializadores
    init(nome:String){
        self.nome = nome
        self.itens = [Item]()
    }
    
    init(nome:String, itens:[Item]){
        self.nome = nome
        self.itens = itens
    }
    
    //MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let nome = aDecoder.decodeObject(forKey: PropertyKey.nome) as? String else{
            os_log("Erro ao tentar decodificar o nome de compra.", log: OSLog.default, type: .error)
            return nil
        }
        guard let itens = aDecoder.decodeObject(forKey: PropertyKey.itens) as? [Item] else{
            os_log("Erro ao tentar decodificar itens de compra.", log: OSLog.default, type: .error)
            return nil
        }
        self.init(nome: nome, itens: itens)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nome, forKey: PropertyKey.nome)
        aCoder.encode(itens, forKey: PropertyKey.itens)
    }
}
