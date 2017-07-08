//
//  NovoProdutoViewController.swift
//  Lista de Compras
//
//  Created by Renan Soares Germano on 01/07/17.
//  Copyright © 2017 Renan Soares Germano. All rights reserved.
//

import UIKit

class NovoProdutoViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Propriedades
    @IBOutlet weak var nomeProduto: UITextField!
    @IBOutlet weak var descricaoProduto: UITextField!
    @IBOutlet weak var imagemProduto: UIImageView!
    @IBOutlet weak var botaoSalvar: UIBarButtonItem!
    var produto:Produto?
    private var nomeOriginal:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        atualizarEstadoDoBotaoSalvar()
        imagemProduto.isUserInteractionEnabled = true
        
        if let produto = self.produto{
            nomeOriginal = produto.nome
            navigationItem.title = produto.nome
            nomeProduto.text = produto.nome
            descricaoProduto.text = produto.descricao
            imagemProduto.image = produto.foto
        }
        
        atualizarEstadoDoBotaoSalvar()
        addAccessibility()
    }
    
    //MARK: Médotos do UITextFieldDelegate
    func textFieldDidBeginEditing(_ textField: UITextField) {
        atualizarEstadoDoBotaoSalvar()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        atualizarEstadoDoBotaoSalvar()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Métodos de UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let imagemSelecionada = info[UIImagePickerControllerOriginalImage] as? UIImage else{
            fatalError("Erro ao selecionar imagem: \(info)")
        }
        imagemProduto.image = imagemSelecionada
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Actions
    @IBAction func imagemProdutoTapped(_ sender: UITapGestureRecognizer) {
        if descricaoProduto.isFirstResponder{
            descricaoProduto.resignFirstResponder()
        }else if nomeProduto.isFirstResponder{
            nomeProduto.resignFirstResponder()
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        let nome = nomeProduto.text ?? ""
        let descricao = descricaoProduto.text ?? ""
        let foto = imagemProduto.image
        
        if let produto = self.produto{
            //Editando
            self.produto!.nome = nome
            if nome != self.nomeOriginal && isNomeValido(){
                self.produto!.nome = nome
                self.produto!.descricao = descricao
                self.produto!.foto = foto
                performSegue(withIdentifier: "CriarProduto", sender: self)
            }else{
                self.produto!.descricao = descricao
                self.produto!.foto = foto
                performSegue(withIdentifier: "CriarProduto", sender: self)
            }
        }else{
            //Criando
            self.produto = Produto(nome: nome, descricao: descricao, foto: foto)
            if isNomeValido(){
                self.produto!.nome = nome
                self.produto!.descricao = descricao
                self.produto!.foto = foto
                performSegue(withIdentifier: "CriarProduto", sender: self)
            }else{
                self.produto = nil
            }
        }
        
        
    }
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        if presentingViewController != nil{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK: Métodos privados
    private func carregarDadosSimples() -> [Produto]{
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
        
        return [arroz, feijao, macarrao, paes, leite, verdurasLegumes, frutas]
    }
    
    private func atualizarEstadoDoBotaoSalvar(){
        botaoSalvar.isEnabled =
            !((nomeProduto.text ?? "").isEmpty) &&
            !((descricaoProduto.text ?? "").isEmpty)
    }
    
    private func isNomeValido() -> Bool{
        var produtos = [Produto]()
        if let produtosFromFile = NSKeyedUnarchiver.unarchiveObject(withFile: Produto.ArchivingURL.path) as? [Produto]{
            produtos = produtosFromFile
        }else{
            produtos = carregarDadosSimples()
        }
        for p in produtos{
            if p.nome.uppercased() == self.produto!.nome.uppercased(){
                let alerta = UIAlertController(title: "Nome inválido", message: "Já existe um produto com este nome.", preferredStyle: .alert)
                let okAcao = UIAlertAction(title: "OK", style: .default)
                alerta.addAction(okAcao)
                self.present(alerta, animated: true)
                return false
            }
        }
        return true
    }
    
    //MARK: Accessibility
    private func addAccessibility(){
        imagemProduto.isAccessibilityElement = true
        imagemProduto.accessibilityLabel = "Foto do produto"
        imagemProduto.accessibilityTraits = UIAccessibilityTraitButton
        
        //New Product
        var accessiblityHint = "Dê dois toques para selecionar foto"
        
        //Editing an existing product
        if self.produto != nil{
            accessiblityHint = "Dê dois toques para trocar foto"
        }
        imagemProduto.accessibilityHint = accessiblityHint
    }

}
