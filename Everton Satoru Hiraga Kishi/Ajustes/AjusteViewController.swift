
import UIKit
import CoreData

enum StateType {
    case add
    case edit
}
class AjusteViewController : UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let formatter: NumberFormatter = NumberFormatter()
    
    // MARK: - Properties
    var dataSource: [State] = []
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        loadStates()
    }
    
    // MARK: - Methods
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: StateType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome do estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Imposto"
            textField.keyboardType = UIKeyboardType.decimalPad
            if let tax = state?.tax {
                textField.text = String(tax)
            }
        }
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            let category = state ?? State(context: self.context)
            category.name = alert.textFields?.first?.text
            do {
                try self.context.save()
                self.loadStates()
            } catch {
                print(error.localizedDescription)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func AdicionarEstado(_ sender: UIButton) {
        showAlert(type: .add, state: nil)
    }
}

// MARK: - UITableViewDelegate
extension AjusteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = dataSource[indexPath.row]
        let cell = tableView.cellForRow(at: indexPath)!
        if cell.accessoryType == .none {
            cell.accessoryType = .checkmark
            product.addToStates(state)
        } else {
            cell.accessoryType = .none
            product.removeFromStates(state)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, state: state)
        }
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
    }
}

// MARK: - UITableViewDelegate
extension AjusteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.accessoryType = .none
        if product != nil {
            if let states = product.states, states.contains(state) {
                cell.accessoryType = .checkmark
            }
        }
        return cell
    }
}
