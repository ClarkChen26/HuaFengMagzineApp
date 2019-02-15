

import CoreData
import UIKit

class ShelfMagazineListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var doneButton: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var shelf : Shelf!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (shelf.magzine?.allObjects.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesCell", for: indexPath)
        
        if let magazine = shelf.magzine?.allObjects[indexPath.row] as? Magazine {
            cell.textLabel?.text = magazine.magTitle
            cell.detailTextLabel?.text = magazine.magSubtitle
            cell.imageView?.image = UIImage(named: (magazine.magPics)!)
        }

        return cell

    }
    @IBAction func edit(_ sender: Any) {
        navigationItem.setRightBarButton(doneButton, animated: false)
        tableView.setEditing(true, animated: true)
    }
    
    @IBAction func done(_ sender: Any) {
        navigationItem.setRightBarButton(editButton, animated: false)
        tableView.setEditing(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            if let magazine = shelf.magzine?.allObjects[indexPath.row] as? Magazine {
                magazine.removeFromShelf(shelf)
                MagazineService.shared.save()
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SenderSegue" {
            let magazineViewController = segue.destination as! PdfViewController
            let indexPath = tableView.indexPathForSelectedRow
            if let magazine = shelf.magzine?.allObjects[(indexPath?.row)!] as? Magazine  {
                magazineViewController.magazine = magazine
                magazineViewController.title = magazine.magTitle
            }
            
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
    
    override func viewDidLoad() {
        navigationItem.setRightBarButton(editButton, animated: false)
    }
    
}
