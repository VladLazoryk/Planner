import UIKit
import RealmSwift

class ContactsViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    let realm = try! Realm()
    
    var contactsArray: Results<ContactsModel>!
    var filtredContacts: Results<ContactsModel>!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsArray = realm.objects(ContactsModel.self).filter("contactsType = 'friend'")

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.hidesSearchBarWhenScrolling = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    //MARK: Sorted contacts

    @IBAction func sortedTypeContacts(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            contactsArray = realm.objects(ContactsModel.self).filter("contactsType = 'friend'")
            tableView.reloadData()
        } else {
            contactsArray = realm.objects(ContactsModel.self).filter("contactsType = 'teacher'")
            tableView.reloadData()
        }
    }
    
    //MARK: Segway transmission
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            
            let contacts: ContactsModel
            if isFiltering {
                contacts = filtredContacts[indexPath.row]
            } else {
                contacts = contactsArray[indexPath.row]
            }
            let dstVC = segue.destination as! OptionContactsTableViewController
            dstVC.editContacts = contacts
        }
    }
}

//MARK:UITableViewDataSource, UITableViewDelegate

extension ContactsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            return filtredContacts.count
        }
        return contactsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCellContacts
        
        var contacts = contactsArray[indexPath.row]
        cell.configure(with: contacts)
        
        if isFiltering {
            contacts = filtredContacts[indexPath.row]
        } else {
            contacts = contactsArray[indexPath.row]
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = contactsArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Удалить", comment: "Delete cell")) { (_, _, completionHandler) in
            
            try! self.realm.write {
                self.realm.delete(editingRow)
                tableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: UISearchResultsUpdating

extension ContactsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        filterContentForSearchText(searchController.searchBar.text!)
        
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filtredContacts = contactsArray.filter("contactsName CONTAINS[c] %@", searchText)
        tableView.reloadData()
    }
}
