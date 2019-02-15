//
// ShelfDetailViewController.swift
//  HuaFeng
//
//  Created by Zhijie Chen on 8/13/18.
//  Copyright © 2018 Zhijie Chen. All rights reserved.
//

import UIKit


class ShelfDetailViewController: UITableViewController, UITextFieldDelegate {
    // MARK: IBAction
    @IBAction private func cancel(_ sender: Any) {
        performSegue(withIdentifier: "ShelfDetailDidFinishUnwindSegue", sender: self)
    }
    
    @IBAction private func save(_ sender: Any) {
        let orderIndex = delegate.initialOrderIndexForShelfDetailViewController(self)
        do {
            try MagazineService.shared.addShelf(withName: name, andOrderIndex: Int32(orderIndex))
            
            performSegue(withIdentifier: "ShelfDetailDidFinishUnwindSegue", sender: self)
        }
        catch _ {
            let alertController = UIAlertController(title: "Save failed", message: "Failed to save the new lent item", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: UITableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        nameTextField.becomeFirstResponder()
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        name = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        
        return false
    }
    
    // MARK: View Management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if selectedShelf != nil {
            navigationItem.title = "Edit Category"
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem = nil
        }
        else {
            navigationItem.title = "Add Category"
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(ShelfDetailViewController.cancel(_:)))
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(ShelfDetailViewController.save(_:)))
        }
        
        nameTextField.text = name
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defer {
            super.viewWillDisappear(animated)
        }
        
        guard let someShelf = selectedShelf else {
            return
        }
        
        do {
            try MagazineService.shared.renameShelf(someShelf, withNewName: name)
        }
        catch _ {
            let alertController = UIAlertController(title: "Save failed", message: "Failed to save the new lent item", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: Properties
    var selectedShelf: Shelf? {
        didSet {
            if let someShelf = selectedShelf {
                name = someShelf.name!
            }
            else {
                name = ShelfDetailViewController.defaultName
            }
        }
    }
    var delegate: ShelfDetailViewControllerDelegate!
    
    // MARK: Properties (Private)
    private var name = ShelfDetailViewController.defaultName
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private weak var nameTextField: UITextField!
    
    // MARK: Properties (Private Static Constant)
    private static let defaultName = "New Shelf"
}
