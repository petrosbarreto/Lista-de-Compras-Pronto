//
//  ComprasTableViewController.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit
import os.log

class ComprasFeitasTableViewController: UITableViewController {
    
    //Propriedades
    var compras:[Compra] = [Compra]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Compras"
        navigationItem.leftBarButtonItem = editButtonItem
        if let compras = carregarCompras(){
            self.compras = compras.filter{$0.itens[0].precoUnitario > 0.0}
        }else{
            carregarDadosSimples()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let compras = carregarCompras(){
            self.compras = compras.filter{$0.itens[0].precoUnitario > 0.0}
        }else{
            carregarDadosSimples()
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compras.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "Compra", for: indexPath) as! CompraTableViewCell
     let compra = compras[indexPath.row]
        
     cell.nomeLabel.text = compra.nome
     cell.totalLabel.text = "R$ \(compra.total)"
     
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
            let novasCompras = self.compras.filter{$0.nome.uppercased() != compraSelecionada.nome.uppercased()}
            self.compras = novasCompras
            salvarCompras()
            self.compras =  novasCompras.filter{$0.itens[0].precoUnitario > 0.0}
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier ?? ""){
        case "MostrarDetalhesDeCompraFeita":
            guard let comprarViewController = segue.destination as? ComprarViewController else{
                fatalError("O destino não é uma instância de ItensTableViewController")
            }
            
            guard let celulaCompraSelecionada = sender as? CompraTableViewCell else{
                fatalError("O objeto sender não é uma instância de CompraTableViewCell")
            }
            
            guard let indexPath = tableView.indexPath(for: celulaCompraSelecionada) else{
                fatalError("A célula selecionada não está sendo mostrada pela TableView")
            }
            
            let compraSelecionada = compras[indexPath.row]
            comprarViewController.compra = compraSelecionada
            
        default:
            fatalError("Identificador inesperados, \(segue.identifier)")
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
        
        
        //Compra 3
        let itensCompra3:[Item] = [Item(quantidade: 5, produto: arroz, precoUnitario: 10.0),
                                   Item(quantidade: 3, produto: feijao, precoUnitario: 5.0),
                                   Item(quantidade: 3, produto: macarrao, precoUnitario: 3.0),
                                   Item(quantidade: 8, produto: paes, precoUnitario: 0.20),
                                   Item(quantidade: 12, produto: leite, precoUnitario: 2.0),
                                   Item(quantidade: 20, produto: verdurasLegumes, precoUnitario: 1.0),
                                   Item(quantidade: 30, produto: frutas, precoUnitario: 3.0)]
        let compra = Compra(nome: "Compra Exemplo", itens: itensCompra3)
        
        self.compras = [compra]
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
}
