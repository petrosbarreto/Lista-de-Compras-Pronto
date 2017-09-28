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
    
    var produto:ProdutoEntity?
    private var produtoPersistence: ProdutoPersistence!
    private var nomeOriginal:String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.produtoPersistence = ProdutoPersistence()
        atualizarEstadoDoBotaoSalvar()
        imagemProduto.isUserInteractionEnabled = true
        
        if let produto = self.produto{
            nomeOriginal = produto.nome
            navigationItem.title = produto.nome
            nomeProduto.text = produto.nome
            descricaoProduto.text = produto.descricao
            imagemProduto.image = UIImage(named: produto.foto!)
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
            produto.nome = nome
            produto.descricao = descricao
            //COLOCAR NOME DA NOVA IMAGEM
            performSegue(withIdentifier: "CriarProduto", sender: self)
        }else{
            //Criando
            //PEGAR NOME DA NOVA IMAGEM
            self.produto = self.produtoPersistence.create(nome: nome, descricao: descricao, foto: "defaultPhoto")
            performSegue(withIdentifier: "CriarProduto", sender: self)
        }
        
        
    }
    
    @IBAction func cancelar(_ sender: UIBarButtonItem) {
        if presentingViewController != nil{
            dismiss(animated: true, completion: nil)
        }else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    private func atualizarEstadoDoBotaoSalvar(){
        botaoSalvar.isEnabled =
            !((nomeProduto.text ?? "").isEmpty) &&
            !((descricaoProduto.text ?? "").isEmpty)
    }
    
    private func isNomeValido() -> Bool{
        var produtos = self.produtoPersistence.read()
        for p in produtos{
            if p.nome?.uppercased() == self.produto!.nome?.uppercased(){
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
