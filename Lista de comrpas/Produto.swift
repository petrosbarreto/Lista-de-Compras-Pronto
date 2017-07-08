//
//  Produto.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import os.log

class Produto: NSObject, NSCoding{
    //MARK: Propriedades
    var nome:String
    var descricao:String
    var foto:UIImage?
    
    //MARK: Caminhos de arquivamento
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchivingURL = DocumentsDirectory.appendingPathComponent("produtos")
    
    //MARK: Tipos
    struct PropertyKey{
        static let nome = "nome"
        static let descricao = "descricao"
        static let foto = "foto"
    }
    
    //MARK: Inicializadores
    init(nome:String, descricao:String, foto:UIImage?){
        self.nome = nome
        self.descricao = descricao
        self.foto = foto
    }
    
    //MARK: NSCoding
    required convenience init?(coder aDecoder: NSCoder) {
        guard let nome = aDecoder.decodeObject(forKey: PropertyKey.nome) as? String else{
            os_log("Erro ao tentar decodificar o nome do produto.", log: OSLog.default, type: .error)
            return nil
        }
        guard let descricao = aDecoder.decodeObject(forKey: PropertyKey.descricao) as? String else{
            os_log("Erro ao tentar decodificar a descricao do produto.", log: OSLog.default, type: .error)
            return nil
        }
        let foto = aDecoder.decodeObject(forKey: PropertyKey.foto) as? UIImage
        self.init(nome: nome, descricao: descricao, foto: foto)
        
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(nome, forKey: PropertyKey.nome)
        aCoder.encode(descricao, forKey: PropertyKey.descricao)
        aCoder.encode(foto, forKey: PropertyKey.foto)
    }
}
