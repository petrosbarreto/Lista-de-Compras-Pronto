//
//  CompraTableViewCell.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 01/07/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit

class CompraTableViewCell: UITableViewCell {
    
    //MARK: Propriedades
    @IBOutlet weak var nomeLabel: UILabel!
    @IBOutlet weak var qtdItens: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
