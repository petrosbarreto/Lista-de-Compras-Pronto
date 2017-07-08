//
//  ViewController.swift
//  Lista de comrpas
//
//  Created by Renan Soares Germano on 30/06/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit

class NovaCompraViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate{
    
    //MARK: Propriedades
    @IBOutlet weak var botaoSalvar: UIBarButtonItem!
    @IBOutlet weak var nomeCompra: UITextField!
    var itens:[Item] = [Item]()
    var qtdItensSelecionados = 0
    var compra:Compra?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let produtos = carregarProdutos(){
            for produto in produtos{
                let item = Item(quantidade: 0, produto: produto)
                itens.append(item)
            }
        }else{
            carregarDadosSimples()
        }
        atualizarEstadoDoBotaoSalvar()
    }
    
    //MARK: Métodos de UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        botaoSalvar.isEnabled = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        atualizarEstadoDoBotaoSalvar()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nomeCompra.resignFirstResponder()
        return true
    }
    
    //MARK: Métodos de UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath) as! ItemTableViewCell
        
        let item = itens[indexPath.row]
        
        cell.fotoImage.image = item.produto.foto
        cell.nomeLabel.text = item.produto.nome
        cell.descricaoLabel.text = item.produto.descricao
        cell.quantidadeLabel.text = "\(item.quantidade)"
        
        addAccessiblityToTableViewCell(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nomeCompra.resignFirstResponder()
        let item = itens[indexPath.row]
        
        let alerta = UIAlertController(title: "Quantidade", message: "Entre com a quantidade necessárias.", preferredStyle: .alert)
        
        func adicionarTextField(textField: UITextField){
            textField.placeholder = "Quantidade"
            if(item.quantidade > 0){
                textField.text = "\(item.quantidade)"
            }
            textField.keyboardType = .numberPad
        }
        
        func pegarQuatidade(alertAction: UIAlertAction){
            let textField = alerta.textFields![0]
            var qtd = 0
            if (textField.text != nil && !(textField.text!.isEmpty)){
                qtd = Int(textField.text!)!
            }
            
            if qtd > 0 && item.quantidade == 0{
                qtdItensSelecionados += 1
            }else if qtd == 0 && item.quantidade > 0{
                qtdItensSelecionados -= 1
            }
        
            item.quantidade = qtd
            tableView.reloadRows(at: [indexPath], with: .none)
            atualizarEstadoDoBotaoSalvar()
        }
        
        alerta.addTextField(configurationHandler: adicionarTextField)
        
        let acaoConfirmar = UIAlertAction(title: "Confirmar", style: .default, handler: pegarQuatidade)
        let acaoCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
        
        alerta.addAction(acaoCancelar)
        alerta.addAction(acaoConfirmar)
        self.present(alerta, animated: true)
    }
    
    //MARK: Navegação
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        compra?.itens = itens.filter{$0.quantidade>0}
    }

    //MARK: Actions
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        compra = Compra(nome: nomeCompra.text!, itens: [Item]())
        if isNomeValido(){
            performSegue(withIdentifier: "CriarCompra", sender: self)
        }else{
            let alerta = UIAlertController(title: "Nome inválido", message: "Já existe uma compra com este nome. Insira outro nome ou delete a compra já existente.", preferredStyle: .alert)
            let okAcao = UIAlertAction(title: "OK", style: .default)
            alerta.addAction(okAcao)
            self.present(alerta, animated: true)
        }
    }
    
    @IBAction func CancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        
        let arrozItem = Item(quantidade: 0, produto: arroz)
        let feijaoItem = Item(quantidade: 0, produto: feijao)
        let macarraoItem = Item(quantidade: 0, produto: macarrao)
        let paesItem = Item(quantidade: 0, produto: paes)
        let leiteItem = Item(quantidade: 0, produto: leite)
        let verdurasLegumesItem = Item(quantidade: 0, produto: verdurasLegumes)
        let frutasItem = Item(quantidade: 0, produto: frutas)
        
        itens += [arrozItem, feijaoItem, macarraoItem, paesItem, leiteItem, verdurasLegumesItem, frutasItem]
    }
    
    private func atualizarEstadoDoBotaoSalvar(){
        botaoSalvar.isEnabled = !((nomeCompra.text ?? "").isEmpty) && qtdItensSelecionados > 0
    }
    
    private func carregarProdutos() -> [Produto]?{
        return NSKeyedUnarchiver.unarchiveObject(withFile: Produto.ArchivingURL.path) as? [Produto]
    }
    
    private func carregarCompras() -> [Compra]{
        guard let compras = NSKeyedUnarchiver.unarchiveObject(withFile: Compra.ArchivingURL.path) as? [Compra] else{
            return [Compra]()
        }
        return compras
    }
    
    private func isNomeValido() -> Bool{
        for c in carregarCompras(){
            if self.compra!.nome.uppercased() == c.nome.uppercased(){
                return false
            }
        }
        return true
    }
    
    //MARK: Accessiblity
    private func addAccessiblityToTableViewCell(cell: ItemTableViewCell){
        cell.accessibilityHint = "Dê dois toques para adicionar quantidade"
        
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

