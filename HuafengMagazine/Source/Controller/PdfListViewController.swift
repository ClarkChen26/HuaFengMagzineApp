
import CoreData
import UIKit

class PDfListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    var fetchedResultsController : NSFetchedResultsController<Magazine>?
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        SearchBar.delegate = self
        
        fetchedResultsController = MagazineService.shared.Magzines()
        fetchedResultsController?.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MagCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController?.object(at: indexPath).magTitle
        cell.detailTextLabel?.text = fetchedResultsController?.object(at: indexPath).magSubtitle
        cell.imageView?.image = UIImage(named: (fetchedResultsController?.object(at: indexPath).magPics)!)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBOutlet weak var SearchBar: UISearchBar!
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // MARK: sender
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SenderSegue" {
            let magazineViewController = segue.destination as! PdfViewController
            let indexPath = tableView.indexPathForSelectedRow
            if let magazine = fetchedResultsController?.object(at: indexPath!) {
                magazineViewController.magazine = magazine
                magazineViewController.title = magazine.magTitle
            }
            
        }else{
            super.prepare(for: segue, sender: sender)
        }
    }
}
