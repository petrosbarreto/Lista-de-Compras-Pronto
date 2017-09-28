//
//  ProdutoTableViewController.swift
//  Lista de Compras
//
//  Created by Renan Soares Germano on 01/07/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import os.log

class ProdutosTableViewController: UITableViewController {
    
    //MARK: Propriedades
    var produtosEntity: [ProdutoEntity]!
    var produtoPersistece: ProdutoPersistence!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        
        self.produtoPersistece = ProdutoPersistence()
//        self.produtoPersistece.create(nome: "Arroz", descricao: "Arroz branco", foto: "arroz")
//        self.produtoPersistece.create(nome: "Feijão", descricao: "Feijão carioca", foto: "feijao")
//        self.produtoPersistece.create(nome: "Frutas", descricao: "Frutas diversas", foto: "frutas")
//        self.produtoPersistece.create(nome: "Default", descricao: "Default product", foto: "defaultPhoto")
        self.produtosEntity = produtoPersistece.read()
        
        //Adding accessiblity
        addAccessiblityToNavigationItem()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtosEntity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Produto", for: indexPath) as? ProdutoTableViewCell else{
            fatalError("A célula selecionada não é uma instância de ProdutoTableViewCell")
        }
        let produtoSelecionado = produtosEntity[indexPath.row]
        
        cell.fotoProduto.image = UIImage(named: produtoSelecionado.foto ?? "defaultPhoto")
        cell.nomeProduto.text = produtoSelecionado.nome
        cell.descricaoProduto.text = produtoSelecionado.descricao
        
        //Adding accessibility
        addAccessibilityToTableViewCell(cell: cell)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Produto", for: indexPath)
        if editingStyle == .delete {
            let produtoSelecionado = produtosEntity[indexPath.row]
            self.produtoPersistece.delete(produto: produtoSelecionado)
            self.produtosEntity.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
            case "CriarProduto":
                print("Adicionar Produto")
            case "EditarProduto":
                guard let novoProdutoViewController = segue.destination as? NovoProdutoViewController else{
                    fatalError("O objeto de destino não é uma instância de NovoProdutoViewController")
                }
                
                guard let produtoTableViewCell = sender as? ProdutoTableViewCell else{
                    fatalError("A célula selecionada não é uma instância de ProdutoTableViewCell")
                }
            
                guard let indexPath = tableView.indexPath(for: produtoTableViewCell) else{
                    fatalError("A célula selecionada não está sendo exibida na TableView")
                }
            
                novoProdutoViewController.produto = produtosEntity[indexPath.row]
            
            default:
                fatalError("Identificar não esperado!")
        }
    }
    
    @IBAction func voltarDeCriacaoDeProduto(sender:UIStoryboardSegue){
        if let sourceViewController  = sender.source as? NovoProdutoViewController, let produto = sourceViewController.produto{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                produtosEntity[selectedIndexPath.row] = produto
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                let novoIndexPath = IndexPath(row: produtosEntity.count, section: 0)
                produtosEntity.append(produto)
                tableView.insertRows(at: [novoIndexPath], with: .automatic)
            }
        }
    }
    
    //MARK: Accessibility
    private func addAccessiblityToNavigationItem(){
        //Add Button
        let plusButton = navigationItem.rightBarButtonItem
        plusButton?.accessibilityHint = "Dê dois toques para adicionar novo produto"
    }
    
    private func addAccessibilityToTableViewCell(cell: UITableViewCell){
        cell.accessibilityHint = "Dê dois toques para detalhes"
    }
}
