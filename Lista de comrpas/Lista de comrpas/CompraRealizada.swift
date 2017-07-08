//
//  CompraRealizada.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import Foundation

class CompraRealizada{
    var compra:Compra
    var data:Date
    
    init(compra:Compra, data:Date){
        self.compra = compra
        self.data = data
    }
}
