//
//  ComprarViewController.swift
//  Lista de Compras
//
//  Created by Renan Soares Germano on 02/07/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit

class ComprarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    //MARK: Propriedades
    var compra:Compra?
    private let botaoFinalizarCompra:UIBarButtonItem = UIBarButtonItem()
    private var qtdItensComprados = 0
    private var isCompraPronta:Bool = false
    
    @IBOutlet weak var totalCompraLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isCompraPronta = isPronta()
        navigationItem.title = "\(compra!.nome)"
        if !isPronta(){
            botaoFinalizarCompra.title = "Finalizar"
            botaoFinalizarCompra.target = self
            botaoFinalizarCompra.action = #selector(finalizarCompra)
            navigationItem.rightBarButtonItem = botaoFinalizarCompra
            atualizarEstadoDoBotaoFinalizar()
        }else{
            totalLabel.text = "\(compra!.total)"
        }
        addAccessibility()
    }
    
    //MARK: Métodos de UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return compra!.itens.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item") as! ItemTableViewCell
        let item = compra!.itens[indexPath.row]
        cell.fotoImage.image = item.produto.foto
        cell.nomeLabel.text = item.produto.nome
        cell.quantidadeLabel.text = "\(item.quantidade)"
        cell.precoUnitarioLabel.text = "\(item.precoUnitario)"
        cell.totalLabel.text = "\(Float(item.quantidade)*item.precoUnitario)"
        addAccessiblityToTableViewCell(cell: cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = compra!.itens[indexPath.row]
        if !isCompraPronta{
            let alerta = UIAlertController(title: "\(item.produto.nome)", message: "Entre com o preço unitário de \(item.produto.nome).", preferredStyle: .alert)
            
            func adicionarTextField(textField: UITextField){
                textField.placeholder = "Preço"
                if(item.precoUnitario > Float(0)){
                    textField.text = "\(item.precoUnitario)"
                }
                textField.keyboardType = .decimalPad
            }
            
            func pegarPreco(alertAction: UIAlertAction){
                let textField = alerta.textFields![0]
                var preco = Float(0)
                if (textField.text != nil && !(textField.text!.isEmpty)){
                    preco = Float(((textField.text)?.replacingOccurrences(of: ",", with: "."))!)!
                }
                
                
                if preco > 0 && item.precoUnitario == 0{
                    qtdItensComprados += 1
                }else if preco == 0 && item.precoUnitario > Float(0){
                    qtdItensComprados -= 1
                }
                
                item.precoUnitario = preco
                totalLabel.text = "\(Float(totalLabel.text!)!+(Float(item.quantidade)*preco))"
                tableView.reloadRows(at: [indexPath], with: .none)
                updateTotalAccessibility()
                atualizarEstadoDoBotaoFinalizar()
            }
            
            alerta.addTextField(configurationHandler: adicionarTextField)
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
            let acaoConfirmar = UIAlertAction(title: "Confirmar", style: .default, handler: pegarPreco)
            
            alerta.addAction(acaoCancelar)
            alerta.addAction(acaoConfirmar)
            self.present(alerta, animated: true)
        }
    }
    
    //MARK: Navegação
    func finalizarCompra(){
        print("FinalizarCompraTapped!")
        performSegue(withIdentifier: "FinalizarCompra", sender: self)
    }
    
    //MARK: Métodos privados
    private func atualizarEstadoDoBotaoFinalizar(){
        botaoFinalizarCompra.isEnabled = qtdItensComprados == compra?.itens.count
    }
    
    private func isPronta() -> Bool{
        for item in self.compra!.itens{
            if item.precoUnitario == 0.0{
                return false
            }
        }
        return true
    }
    
    //MARK: Accessiblity
    private func addAccessibility(){
        self.totalCompraLabel.isAccessibilityElement = false
    }
    
    private func updateTotalAccessibility(){
        var totalCompraAccessibilityLabel = "Total: \(totalLabel.text!) "
        if Float(totalLabel.text!)! > 0{
            totalCompraAccessibilityLabel += "reais"
        }else{
            totalCompraAccessibilityLabel += "real"
        }
        
        self.totalLabel.accessibilityLabel = totalCompraAccessibilityLabel
    }
    
    private func addAccessiblityToTableViewCell(cell: ItemTableViewCell){
        cell.accessibilityHint = "Dê dois toques para adicionar preço unitário"
        
        //Desabilitando labels descritivos
        cell.nomeProdutoLabel.isAccessibilityElement = false
        cell.quantidadeProdutoLabel.isAccessibilityElement = false
        cell.precoItemLabel.isAccessibilityElement = false
        cell.totalItemLabel.isAccessibilityElement = false
        
        //Personalizando accessiblityLabel dos dados
        cell.nomeLabel.accessibilityLabel = "Produto: \(cell.nomeLabel.text!)"
        cell.quantidadeLabel.accessibilityLabel = "Quantidade: \(cell.quantidadeLabel.text!)"
        
        var precoUnitarioAccessibilityLabel = "Preço unitário: \(cell.precoUnitarioLabel.text!) "
        if Float(cell.precoUnitarioLabel.text!)! > 0{
            precoUnitarioAccessibilityLabel += "reais"
        }else{
            precoUnitarioAccessibilityLabel += "real"
        }
        
        cell.precoUnitarioLabel.accessibilityLabel = precoUnitarioAccessibilityLabel
        
        var subTotalAccessibilityLabel = "Subtotal: \(cell.totalLabel.text!) "
        if Float(cell.totalLabel.text!)! > 0{
            subTotalAccessibilityLabel += "reais"
        }else{
            subTotalAccessibilityLabel += "real"
        }
        
        cell.totalLabel.accessibilityLabel = subTotalAccessibilityLabel
    }
    
}
