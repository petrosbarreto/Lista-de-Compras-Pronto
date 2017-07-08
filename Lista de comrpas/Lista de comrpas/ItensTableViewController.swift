//
//  ItensTableViewController.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit

class ItensTableViewController: UITableViewController {
    
    //MARK: propriedades
    var compra:Compra?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = compra!.nome
        if(compra!.total == 0.0){
            print("Entrou!")
            let rightButton = UIBarButtonItem(title: "Comprar", style: .plain, target: self, action: #selector(fazerCompra))
            navigationItem.rightBarButtonItem = rightButton
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compra!.itens.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as? ItemTableViewCell else{
            fatalError("A célula não é uma intância de ItemTableViewCell")
        }

        let item = compra!.itens[indexPath.row]
        cell.fotoImage.image = item.produto.foto
        cell.nomeLabel.text = item.produto.nome
        cell.descricaoLabel.text = item.produto.descricao
        cell.quantidadeLabel.text = "\(item.quantidade)"
        
        addAccessiblityToTableViewCell(cell: cell)
        return cell
    }
    
    // MARK: Navigation
    func fazerCompra(){
        performSegue(withIdentifier: "Comprar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
            case "Comprar":
                guard let comprarVC = segue.destination as? ComprarViewController else{
                    fatalError("A View de destino não é uma instância de ComprarViewController.")
                }
                comprarVC.compra = compra
            default:
                fatalError("Identificador inesperado!")
        }
    }
    
    //MARK: Accessiblity
    private func addAccessiblityToTableViewCell(cell: ItemTableViewCell){
        
        //Desabilitando labels descritivos
        cell.nomeProdutoLabel.isAccessibilityElement = false
        cell.descricaoProdutoLabel.isAccessibilityElement = false
        cell.quantidadeProdutoLabel.isAccessibilityElement = false
        
        //Personalizando accessiblityLabel dos dados
        cell.nomeLabel.accessibilityLabel = "Produto: \(cell.nomeLabel.text!)"
        cell.descricaoLabel.accessibilityLabel = "Descrição: \(cell.descricaoLabel.text!)"
        cell.quantidadeLabel.accessibilityLabel = "Quantidade: \(cell.quantidadeLabel.text!)"
    }
    

}
