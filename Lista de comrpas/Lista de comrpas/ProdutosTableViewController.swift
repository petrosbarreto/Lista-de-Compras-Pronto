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
    var produtos:[Produto] = [Produto]()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = editButtonItem
        if let produtos = carregarProdutos(){
            self.produtos += produtos
        }else{
            carregarDadosSimples()
        }
        
        //Adding accessiblity
        addAccessiblityToNavigationItem()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return produtos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Produto", for: indexPath) as? ProdutoTableViewCell else{
            fatalError("A célula selecionada não é uma instância de ProdutoTableViewCell")
        }
        let produtoSelecionado = produtos[indexPath.row]
        
        cell.fotoProduto.image = produtoSelecionado.foto
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
            let produtoSelecionado = produtos[indexPath.row]
            if let produtosFromFile = carregarProdutos(){
                self.produtos = produtosFromFile.filter{$0.nome.uppercased() != produtoSelecionado.nome.uppercased()}
            }else{
                let novosProdutos = self.produtos.filter{$0.nome.uppercased() != produtoSelecionado.nome.uppercased()}
                self.produtos = novosProdutos
            }
            salvarProdutos()
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
            
                novoProdutoViewController.produto = produtos[indexPath.row]
            
            default:
                fatalError("Identificar não esperado!")
        }
    }
    
    @IBAction func voltarDeCriacaoDeProduto(sender:UIStoryboardSegue){
        if let sourceViewController  = sender.source as? NovoProdutoViewController, let produto = sourceViewController.produto{
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow{
                produtos[selectedIndexPath.row] = produto
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }else{
                let novoIndexPath = IndexPath(row: produtos.count, section: 0)
                produtos.append(produto)
                tableView.insertRows(at: [novoIndexPath], with: .automatic)
            }
            salvarProdutos()
        }
    }
    
    //MARK: Métodos privados
    private func carregarDadosSimples(){
        //Imagem dos produtos
        let fotoArroz = #imageLiteral(resourceName: "arroz")
        let fotoFeijao = #imageLiteral(resourceName: "feijao")
        let fotoMacarrao = #imageLiteral(resourceName: "macarrao")
        let fotoPaes = #imageLiteral(resourceName: "paes")
        let fotoLeite = #imageLiteral(resourceName: "leite")
        let fotoVerdurasLegumes = #imageLiteral(resourceName: "verduras_e_legumes")
        let fotoFrutas = #imageLiteral(resourceName: "frutas")
        
        //Produtos
        let arroz = Produto(nome: "Arroz", descricao: "Arroz branco", foto: fotoArroz)
        let feijao = Produto(nome: "Feijão", descricao: "Feijão carioca", foto: fotoFeijao)
        let macarrao = Produto(nome: "Macarrão", descricao: "Macarrão espaguete", foto: fotoMacarrao)
        let paes = Produto(nome: "Pães", descricao: "Pães franceses", foto: fotoPaes)
        let leite = Produto(nome: "Leite", descricao: "Leite integral", foto: fotoLeite)
        let verdurasLegumes = Produto(nome: "Verduras e Legumes", descricao: "Verduras e Legumes diversos", foto: fotoVerdurasLegumes)
        let frutas = Produto(nome: "Frutas", descricao: "Frutas diversas", foto: fotoFrutas)
        
        produtos += [arroz, feijao, macarrao, paes, leite, verdurasLegumes, frutas]
    }
    
    private func salvarProdutos(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(produtos, toFile: Produto.ArchivingURL.path)
        if isSuccessfulSave {
            os_log("Produtos salvos com sucesso.", log: OSLog.default, type: .debug)
        } else {
            os_log("Falho ao tentar salvar produtos.", log: OSLog.default, type: .error)
        }
    }
    
    private func carregarProdutos() -> [Produto]?{
        guard let produtos = NSKeyedUnarchiver.unarchiveObject(withFile: Produto.ArchivingURL.path) as? [Produto] else{
            return nil
        }
        return produtos
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
