//
//  DocumentViewController.swift
//  Documents Core Data Relationships
//
//  Created by Felipe Costa on 6/28/19.
//  Copyright © 2019 Felipe Costa. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    
    var document: Document?
    var category: Category?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        
        if let document = document {
            let name = document.name
            nameTextField.text = name
            bodyTextView.text = document.body
            title = name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func saveDocument(_ sender: Any) {
        guard let name = nameTextField.text else {
            let alert = UIAlertController(title: "Alert", message: "Document not saved.\nThe name is not accessible.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let documentName = name.trimmingCharacters(in: .whitespaces)
        if (documentName == "") {
            let alert = UIAlertController(title: "Alert", message: "Document not saved.\nA name is required.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        let body = bodyTextView.text
        
        if document == nil {
            // document doesn't exist, create new one
            if let category = category {
                document = Document(name: documentName, body: body, category: category)
            }
        } else {
            // document exists, update existing one
            if let category = category {
                document?.update(name: documentName, body: body, category: category)
            }
        }
        
        if let document = document {
            do {
                let managedContext = document.managedObjectContext
                try managedContext?.save()
            } catch {
                let alert = UIAlertController(title: "Alert", message: "Document not saved.\nAn error occured saving context.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertController(title: "Alert", message: "Document not saved.\nA Document entity could not be created.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        navigationController?.popViewController(animated: true)
    }
}
