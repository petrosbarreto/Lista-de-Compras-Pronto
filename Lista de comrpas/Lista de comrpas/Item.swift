//
//  Item.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import Foundation
import os.log

class Item: NSObject, NSCoding{
    //MARK: Propriedades
    var quantidade:Int
    var produto:Produto
    var precoUnitario:Float = 0.0
    
    //MARK: Tipos
    struct PropertyKey{
        static let quantidade = "quantidade"
        static let produto = "produto"
        static let precoUnitario = "preco_unitario"
    }
    
    //MARK: Inicializadores
    init(quantidade: Int, produto: Produto){
        self.quantidade = quantidade
        self.produto = produto
        self.precoUnitario = Float(0)
    }
    
    init(quantidade: Int, produto: Produto, precoUnitario: Float){
        self.quantidade = quantidade
        self.produto = produto
        self.precoUnitario = precoUnitario
    }
    
    //MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        let quantidade = aDecoder.decodeInteger(forKey: PropertyKey.quantidade)
        guard let produto = aDecoder.decodeObject(forKey: PropertyKey.produto) as? Produto else{
            os_log("Erro ao tentar decodificar produto de item.", log: OSLog.default, type: .error)
            return nil
        }
        let precoUnitario = aDecoder.decodeFloat(forKey: PropertyKey.precoUnitario)
        self.init(quantidade: quantidade, produto: produto, precoUnitario: precoUnitario)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(quantidade, forKey: PropertyKey.quantidade)
        aCoder.encode(produto, forKey: PropertyKey.produto)
        aCoder.encode(precoUnitario, forKey: PropertyKey.precoUnitario)
    }
    
}
