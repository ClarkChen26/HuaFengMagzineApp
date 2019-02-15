
import CoreData
import UIKit


class ShelfListViewController: UIViewController, ShelfDetailViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
        // MARK: IBAction
    @IBAction private func edit(_ sender: Any) {
        shelfListTable.setEditing(true, animated: true)
        navigationItem.setLeftBarButton(doneButton, animated: true)
    }
    
    @IBAction private func done(_ sender: Any) {
        shelfListTable.setEditing(false, animated: true)
        horizontalSwipeToEditMode = false
        
        navigationItem.setLeftBarButton(editButton, animated: true)
    }
    
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
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // If the table is in editing mode we let the user rename Shelf, otherwise select the Shelf and
        // display its lent items
        if shelfListTable.isEditing && !horizontalSwipeToEditMode {
            performSegue(withIdentifier: "ShelfDetailSegue", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // Since the table view is already updated, because the move input came from it being manipulated, we have to set a flag
        // so we don't try and update the table view again in the NSFetchedResultsControllerDelegate methods
        ignoreUpdates = true
        defer {
            ignoreUpdates = false
        }
        
        guard let shelf = fetchedResultsController?.object(at: sourceIndexPath) else {
            return
        }
        
        shelf.weight = Int32(destinationIndexPath.row)
        // The ranges need to be calculated not considering the above change, because it hasn't yet been saved
        if let shelves = fetchedResultsController?.fetchedObjects {
            let reindexRange: NSRange
            let shiftForward: Bool
            if sourceIndexPath.row > destinationIndexPath.row {
                reindexRange = NSMakeRange(destinationIndexPath.row, sourceIndexPath.row - destinationIndexPath.row)
                shiftForward = true
            }
            else {
                reindexRange = NSMakeRange(sourceIndexPath.row + 1, destinationIndexPath.row - sourceIndexPath.row)
                shiftForward = false
            }
            
            let subShelves = ((shelves as NSArray).subarray(with: reindexRange)) as! Array<Shelf>
            do {
                try MagazineService.shared.reindex(subShelves, shiftForward: shiftForward)
            }
            catch {
                let alertController = UIAlertController(title: "Move Failed", message: "Failed to move Shelf", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        navigationItem.setLeftBarButton(doneButton, animated: true)
        
        horizontalSwipeToEditMode = true
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        navigationItem.setLeftBarButton(editButton, animated: true)
        
        horizontalSwipeToEditMode = false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {
            return
        }
        
        guard let shelf = fetchedResultsController?.object(at: indexPath) else {
            return
        }
        
        var shelvesToReindex: Array<Shelf>?
        let numberOfRows = shelfListTable.numberOfRows(inSection: 0)
        if indexPath.row + 1 < numberOfRows {
            if let shelves = fetchedResultsController?.fetchedObjects {
                let reindexRange = NSMakeRange(indexPath.row + 1, numberOfRows - (indexPath.row + 1))
                shelvesToReindex = ((shelves as NSArray).subarray(with: reindexRange)) as? Array<Shelf>
            }
        }
        
        do {
            try MagazineService.shared.deleteShelf(shelf)
            
            if let someshelves = shelvesToReindex {
                do {
                    try MagazineService.shared.reindex(someshelves, shiftForward: false)
                }
                catch _ {
                    let alertController = UIAlertController(title: "Delete Failed", message: "Failed to re-order remaining shelves", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
        catch _ {
            let alertController = UIAlertController(title: "Delete Failed", message: "Failed to delete shelf", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard !ignoreUpdates else {
            return
        }
        
        shelfListTable.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard !ignoreUpdates else {
            return
        }
        
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
        guard !ignoreUpdates else {
            return
        }
        
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
        guard !ignoreUpdates else {
            return
        }
        
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
        else if segue.identifier == "ShelfDetailSegue" {
            if let indexPath = shelfListTable.indexPathForSelectedRow, let selectedShelf = fetchedResultsController?.object(at: indexPath) {
                let shelfDetailViewController = segue.destination as! ShelfDetailViewController
                shelfDetailViewController.selectedShelf = selectedShelf
                shelfDetailViewController.delegate = self
            }
        }
        else if segue.identifier == "ToFavoriteSegue" {
            if let indexPath = shelfListTable.indexPathForSelectedRow, let selectedShelf = fetchedResultsController?.object(at: indexPath) {
                let shelfDetailViewController = segue.destination as! ShelfMagazineListViewController
                shelfDetailViewController.shelf = selectedShelf
            }
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setLeftBarButton(editButton, animated: false)
        
        setupResultsController()
    }
    
    // MARK: Properties (Private)
    private var horizontalSwipeToEditMode = false
    private var ignoreUpdates = false
    
    private var fetchedResultsController: NSFetchedResultsController<Shelf>?
    
    // MARK: Properties (IBOutlet)
    @IBOutlet private var doneButton: UIBarButtonItem!
    @IBOutlet private var editButton: UIBarButtonItem!
    @IBOutlet weak private var shelfListTable: UITableView!
}


