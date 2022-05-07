import UIKit
import RealmSwift

class TasksOptionTableViewController: UITableViewController {
    
    @IBOutlet weak var dateTaskLabel: UILabel!
    @IBOutlet weak var nameTaskLabel: UILabel!
    @IBOutlet weak var discriptionTaskLabel: UILabel!
    
    let realm = try! Realm()
    
    var dateTask = NSDate()
    var colorTask = "FF7E79"
    var readyTask = 0
    
    var colorCell = UIColor().colorFromHex("#FF7E79")
    
    var editTasks: TasksModel?
    
    let textView = UITextView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        
        setupEditScreen()
        
    }
    
    @IBAction func saveTask(_ sender: Any) {
        
        let value = TasksModel(value: [dateTask,
                                       nameTaskLabel.text!,
                                       discriptionTaskLabel.text!,
                                       colorTask,
                                       readyTask])
        
        if editTasks != nil {
            try! realm.write {
                
                EditingCell()
            }
            
        } else {
            
            if nameTaskLabel.text == "Название" || dateTaskLabel.text == "Дата" {
                alertOk(with: NSLocalizedString("Ошибка", comment: "Error alert"),
                        and: NSLocalizedString("Введите дату и название", comment: "Enter date and name alert"))
            } else {
                try! realm.write {
                    realm.add(value)
                }
                alertOk(with: NSLocalizedString("Успешно!", comment: "Sussess alert"),
                        and: NSLocalizedString("Задание добавлено в расписание", comment: "Task add alert"))
                refreshCells()
            }
        }
        
        let alertController = UIAlertController(title: NSLocalizedString("Изменения сохранены", comment: "Changes saved"), message: nil, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "ОК", style: .default) { _ in
            
            self.refreshCells()
            
            
        }
        alertController.addAction(alertOk)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    //MARK: TableView Option
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        colorOfCell()
        
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            alertDateSchedule(label: dateTaskLabel) { (_, date) in
                self.dateTask = date
            }
        case 1:
            alertForCell(label: nameTaskLabel, name: NSLocalizedString("Название", comment: "Name alert"),
                         placeholder: NSLocalizedString("Введите название задания", comment: "Enter task name alert"))
        case 2:
            alertDescription(label: discriptionTaskLabel, name: NSLocalizedString("Введите задание \n\n\n\n\n", comment: "Enter task"),
                             placeholder: NSLocalizedString("Введите задание", comment: "Enter task alert"),
                             textView: textView)
        default: print("error sections")
        }
    }
    
    //MARK: Segway transmission
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tasksToSelect" {
            if let selectVC = segue.destination as? TasksColorTableViewController {
                selectVC.completion = { color in
                    self.colorCell = UIColor().colorFromHex("#\(color)")
                    self.colorTask = "\(color)"
                    self.colorOfCell()
                }
            }
        }
    }
    
    //MARK: ColorForCell
    
    func colorOfCell() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 3))
        cell?.backgroundColor = colorCell
    }
    
    //MARK: Refresh Cell
    
    func refreshCells() {
        dateTaskLabel.text = NSLocalizedString("Дата", comment: "Save task date")
        nameTaskLabel.text = NSLocalizedString("Название", comment: "Save task name")
        discriptionTaskLabel.text = NSLocalizedString("Задание", comment: "Save task description")
        colorCell = UIColor().colorFromHex("#FF7E79")
        colorOfCell()
        editTasks = nil
        readyTask = 0
    }
    
    //MARK: Setup Edit Screen
    
    private func setupEditScreen() {
        if editTasks != nil {
            
            navigationItem.title = NSLocalizedString("Редактирование", comment: "editing title")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: editTasks!.taskDate as Date)
            dateTask = editTasks!.taskDate
            dateTaskLabel.text = dateString
            nameTaskLabel.text = editTasks?.taskName
            discriptionTaskLabel.text = editTasks?.taskDescription
            colorCell = UIColor().colorFromHex("#\(String(editTasks!.taskColorCell))")
            colorTask = editTasks!.taskColorCell
        }
    }
    
    func EditingCell() {
        editTasks?.taskDate = dateTask
        editTasks?.taskName = nameTaskLabel.text!
        editTasks?.taskDescription = discriptionTaskLabel.text!
        editTasks?.taskColorCell = colorTask
        editTasks?.taskReady = readyTask
        alertOk(with: NSLocalizedString("Успешно!", comment: "Success alert"),
                and: NSLocalizedString("Изменения сохранены", comment: "Changes saved alert"))
    }
    
    //MARK: Description TextField
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "bounds"{
            if let rect = (change?[NSKeyValueChangeKey.newKey] as? NSValue)?.cgRectValue {
                let margin: CGFloat = 8
                let xPos = rect.origin.x + margin
                let yPos = rect.origin.y + 54
                let width = rect.width - 2 * margin
                let height: CGFloat = 90
                
                textView.frame = CGRect.init(x: xPos, y: yPos, width: width, height: height)
            }
        }
    }
}

//MARK: UITextViewDelegate

extension TasksOptionTableViewController: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        return changedText.count <= 150
    }
}

