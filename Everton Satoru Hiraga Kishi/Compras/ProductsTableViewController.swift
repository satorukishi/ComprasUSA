import UIKit
import CoreData

class ProductsTableViewController: UITableViewController {
    
    var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
    //var fetchedResultController: NSFetchedResultsController<Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 106
        tableView.rowHeight = UITableViewAutomaticDimension
        label.text = "Sua lista está vazia"
        label.textAlignment = .center
        
        loadProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let vc = segue.destination as? CompraViewController {
//            vc.movie = fetchedResultController.object(at: tableView.indexPathForSelectedRow!)
//        }
    }
    
    func loadProducts() {
//        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
//        fetchRequest.sortDescriptors = NSSortDescriptor(key: "name", ascending: true)
//        fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        fetchedResultController.delegate = self
//        do {
//            try fetchedResultController.performFetch()
//        } catch {
//            print(error.localizedDescription)
//        }
    }
}
