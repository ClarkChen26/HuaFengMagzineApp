
import UIKit
import CoreData

class WriterListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UISearchBarDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var WriterListView: UITableView!
    @IBOutlet weak var SearchBar: UISearchBar!
    var fetchedResultsController : NSFetchedResultsController<Writer>?
    
    override func viewDidLoad() {
        WriterListView.dataSource = self
        WriterListView.delegate = self
        SearchBar.delegate = self
        
        fetchedResultsController = MagazineService.shared.Writers()
        fetchedResultsController?.delegate = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WriterCell", for: indexPath)
        cell.textLabel?.text = fetchedResultsController?.object(at: indexPath).writername
        cell.detailTextLabel?.text = fetchedResultsController?.object(at: indexPath).writerposition
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "WriterSegue" {
            if let indexPath = WriterListView.indexPathForSelectedRow, let selectedWriter = fetchedResultsController?.object(at: indexPath) {
                let writerDetailViewController = segue.destination as! WriterMagazineListViewController
                writerDetailViewController.writer = selectedWriter
            }
        }
        else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
}
