//
//  ProdutoTableViewCell.swift
//  Lista de Compras
//
//  Created by Renan Soares Germano on 01/07/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit

class ProdutoTableViewCell: UITableViewCell {
    
    //MARK: Propriedades
    @IBOutlet weak var fotoProduto: UIImageView!
    @IBOutlet weak var nomeProduto: UILabel!
    @IBOutlet weak var descricaoProduto: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
