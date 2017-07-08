//
//  ComprasAFazerTableViewController.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 01/07/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import os.log

class ComprasAFazerTableViewController: UITableViewController {
    
    //MARK: Propriedades
    var compras:[Compra] = [Compra]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Compras"
        navigationItem.leftBarButtonItem = editButtonItem
        if let compras = carregarCompras(){
            self.compras = compras.filter{$0.itens[0].precoUnitario == 0.0}
        }else{
            carregarDadosSimples()
        }
        addAccessibilityToNavigationItem()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compras.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Compra", for: indexPath) as? CompraTableViewCell else{
            fatalError("A célula não é uma instância de CompraTableViewCell")
        }
        let compra = self.compras[indexPath.row]
        cell.nomeLabel.text = compra.nome
        if compra.itens.count > 1{
            cell.qtdItens.text = "\(compra.itens.count) itens"
        }else{
            cell.qtdItens.text = "\(compra.itens.count) item"
        }
        addAccessibilityToTableViewCell(cell: cell)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let compraSelecionada = self.compras[indexPath.row]
            if let compras = carregarCompras(){
                self.compras = compras
            }
            let novasCompras = self.compras.filter{
                ($0.nome.uppercased() != compraSelecionada.nome.uppercased() && $0.itens[0].precoUnitario == 0.0)||($0.nome.uppercased() != compraSelecionada.nome.uppercased() && $0.itens[0].precoUnitario > 0.0)}
            self.compras = novasCompras
            salvarCompras()
            self.compras =  novasCompras.filter{$0.itens[0].precoUnitario == 0.0}
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: Navegação
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
        case "AdicionarCompra":
            print("Criar nova compra")
            
        case "MostrarItensDeCompra":
            guard let itensTableViewController = segue.destination as? ItensTableViewController else{
                fatalError("O destino não é uma instância de ItensTableViewController")
            }
            
            guard let celulaCompraSelecionada = sender as? CompraTableViewCell else{
                fatalError("O objeto sender não é uma instância de CompraTableViewCell")
            }
            
            guard let indexPath = tableView.indexPath(for: celulaCompraSelecionada) else{
                fatalError("A célula selecionada não está sendo mostrada pela TableView")
            }
            
            let compraSelecionada = compras[indexPath.row]
            itensTableViewController.compra = compraSelecionada
            
        default:
            fatalError("Identificador inesperados, \(segue.identifier)")
        }
    }
    
    @IBAction func voltarDeCricaoDeCompra(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? NovaCompraViewController, let compra = sourceViewController.compra{
            
            if var comprasFromFile = carregarCompras(){
                comprasFromFile.append(compra)
                self.compras = comprasFromFile
            }else{
                self.compras = [compra]
            }
            salvarCompras()
            self.compras = compras.filter{$0.itens[0].precoUnitario == 0.0}
            tableView.reloadData()
            
        }
    }
    
    @IBAction func voltarDeRealizacaoDeCompra(sender: UIStoryboardSegue){
        if let sourceViewController = sender.source as? ComprarViewController, let compra = sourceViewController.compra, compra === compras[(tableView.indexPathForSelectedRow?.row)!]{
            if let comprasFromFile = carregarCompras(){
                self.compras = comprasFromFile.filter{$0.nome.uppercased() != compra.nome.uppercased()}
                self.compras.append(compra)
            }else{
                compras.remove(at: (tableView.indexPathForSelectedRow?.row)!)
                compras.insert(compra, at: (tableView.indexPathForSelectedRow?.row)!)
            }
            salvarCompras()
            self.compras = compras.filter{$0.itens[0].precoUnitario == 0.0}
            tableView.reloadData()
            
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
        let verdurasLegumes = Produto(nome: "Vegetais", descricao: "Verduras e Legumes", foto: fotoVerdurasLegumes)
        let frutas = Produto(nome: "Frutas", descricao: "Frutas diversas", foto: fotoFrutas)
        
        //Compras
        
        //Compra 1
        let itensCompra1:[Item] = [Item(quantidade: 5, produto: arroz),
                                   Item(quantidade: 3, produto: feijao),
                                   Item(quantidade: 3, produto: macarrao)]
        let compra1 = Compra(nome: "Compra 1", itens: itensCompra1)
        
        //Compra 2
        let itensCompra2:[Item] = [Item(quantidade: 5, produto: arroz),
                                   Item(quantidade: 3, produto: feijao),
                                   Item(quantidade: 3, produto: macarrao),
                                   Item(quantidade: 8, produto: paes),
                                   Item(quantidade: 12, produto: leite)]
        let compra2 = Compra(nome: "Compra 2", itens: itensCompra2)
        
        //Compra 3
        let itensCompra3:[Item] = [Item(quantidade: 5, produto: arroz),
                                   Item(quantidade: 3, produto: feijao),
                                   Item(quantidade: 3, produto: macarrao),
                                   Item(quantidade: 8, produto: paes),
                                   Item(quantidade: 12, produto: leite),
                                   Item(quantidade: 20, produto: verdurasLegumes),
                                   Item(quantidade: 30, produto: frutas)]
        let compra3 = Compra(nome: "Compra 3", itens: itensCompra3)
        
        self.compras += [compra1, compra2, compra3]
    }
    
    private func salvarCompras(){
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(compras, toFile: Compra.ArchivingURL.path)
        if isSuccessfulSave {
            os_log("Compras salvos com sucesso.", log: OSLog.default, type: .debug)
        } else {
            os_log("Falho ao tentar salvar compras.", log: OSLog.default, type: .error)
        }
    }
    
    private func carregarCompras() -> [Compra]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Compra.ArchivingURL.path) as? [Compra]
    }
    
    //MARK: Accessibility
    private func addAccessibilityToNavigationItem(){
        //Add button
        let plusButton = navigationItem.rightBarButtonItem!
        plusButton.accessibilityHint = "Dê dois toques para nova Lista de Compras"
    }
    
    private func addAccessibilityToTableViewCell(cell: UITableViewCell){
        cell.accessibilityHint = "Dê dois toques para detalhes"
    }
    
}
