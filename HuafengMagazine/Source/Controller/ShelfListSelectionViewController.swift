//
//  ShelfListViewController.swift
//  HuaFeng
//
//  Created by Zhijie Chen on 8/13/18.
//  Copyright © 2018 Zhijie Chen. All rights reserved.
//

import CoreData
import UIKit


class ShelfListSelectionViewController: UIViewController, ShelfDetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    var magazine : Magazine!
    
    // MARK: IBAction (Unwind Segue)
    @IBAction private func ShelfDetailDidFinish(_ sender: UIStoryboardSegue) {
        // Intentionally left blank
    }
    
    // MARK: ShelfDetailViewControllerDelegate
    func initialOrderIndexForShelfDetailViewController(_ shelfDetailViewController: ShelfDetailViewController) -> Int {
        return shelfListTable.numberOfRows(inSection: 0)
    }
    
    // MARK: UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShelfCell", for: indexPath)
        let someShelf = fetchedResultsController!.object(at: indexPath)
        cell.textLabel!.text = someShelf.name
        
        return cell
    }

    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        shelfListTable.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            shelfListTable.deleteRows(at: [indexPath!], with: .left)
        case .insert:
            shelfListTable.insertRows(at: [newIndexPath!], with: .left)
        case .move:
            shelfListTable.moveRow(at: indexPath!, to: newIndexPath!)
        case .update:
            if let cell = shelfListTable.cellForRow(at: indexPath!), let shelf = anObject as? Shelf {
                cell.textLabel!.text = shelf.name
            }
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            shelfListTable.deleteSections(IndexSet(integer: sectionIndex), with: .left)
        case .insert:
            shelfListTable.insertSections(IndexSet(integer: sectionIndex), with: .left)
        default:
            print("Unexpected change type in controller:didChangeSection:atIndex:forChangeType:")
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        shelfListTable.endUpdates()
    }
    
    // MARK: Private
    private func setupResultsController() {
        fetchedResultsController = MagazineService.shared.Shelves()
        fetchedResultsController?.delegate = self
        
        shelfListTable.reloadData()
    }
    
    // MARK: View Management
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectedIndexPath = shelfListTable.indexPathForSelectedRow {
            shelfListTable.deselectRow(at: selectedIndexPath, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if segue.identifier == "ToFavoriteSegue" {
        //            if let indexPath = shelfListTable.indexPathForSelectedRow, let _ = fetchedResultsController?.object(at: indexPath) {
        //                _ = segue.destination as! MagazineListViewController
        ////                magazineListViewController.selectedCategory = selectedCategory
        //
        //                shelfListTable.deselectRow(at: indexPath, animated: true)
        //            }
        //        }
        if segue.identifier == "AddShelfSegue" {
            let navigationController = segue.destination as! UINavigationController
            let shelfDetailViewController = navigationController.topViewController as! ShelfDetailViewController
            shelfDetailViewController.delegate = self
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupResultsController()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        magazine.addToShelf((fetchedResultsController?.object(at: indexPath))!)
        MagazineService.shared.save()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Properties (Private)
    private var fetchedResultsController: NSFetchedResultsController<Shelf>?
    
    // MARK: Properties (IBOutlet)
    @IBOutlet weak private var shelfListTable: UITableView!
}


