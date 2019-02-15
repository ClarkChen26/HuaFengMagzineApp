//
//  ShelfMagazineListViewController.swift
//  HuaFeng
//
//  Created by Zhijie Chen on 8/19/18.
//  Copyright © 2018 Zhijie Chen. All rights reserved.
//

import CoreData
import UIKit

class WriterMagazineListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var writer : Writer!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (writer.mag?.allObjects.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "magazineCell", for: indexPath)
        
        if let magazine = writer.mag?.allObjects[indexPath.row] as? Magazine {
            cell.textLabel?.text = magazine.magTitle
            cell.detailTextLabel?.text = magazine.magSubtitle
            cell.imageView?.image = UIImage(named: (magazine.magPics)!)
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SenderSegue" {
            let magazineViewController = segue.destination as! PdfViewController
            let indexPath = tableView.indexPathForSelectedRow
            if let magazine = writer.mag?.allObjects[(indexPath?.row)!] as? Magazine  {
                magazineViewController.magazine = magazine
                magazineViewController.title = magazine.magTitle
            }
            
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
}
