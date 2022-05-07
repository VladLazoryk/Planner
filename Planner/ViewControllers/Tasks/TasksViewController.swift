import UIKit
import FSCalendar
import RealmSwift

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendarFS: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonShowHide: UIButton!
    
    let realm = try! Realm()
    var tasksArray: Results<TasksModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarFS.delegate = self
        calendarFS.dataSource = self
        self.calendarFS.scope = .week
        
        tasksOnDay(date: calendarFS.today!)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: Swipe calendar action
    
    @IBAction func swipeCalendarDown(_ sender: Any) {
        CalendarAction.shared.calendarHide(calendar: calendarFS, button: buttonShowHide)
    }
    
    @IBAction func swipeCalendarUp(_ sender: Any) {
        CalendarAction.shared.calendarOpen(calendar: calendarFS, button: buttonShowHide)
    }
    
    //MARK: Calendar pressed
    
    @IBAction func calendarPressed(_ sender: Any) {
        if self.calendarFS.scope == .month {
            CalendarAction.shared.calendarOpen(calendar: calendarFS, button: buttonShowHide)
        } else {
            CalendarAction.shared.calendarHide(calendar: calendarFS, button: buttonShowHide)
        }
    }
    
    //MARK: Daily tasks
    
    func tasksOnDay(date: Date ) {
        
        let dateStart = date
        let dateEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart)!
        }()
        
        tasksArray = realm.objects(TasksModel.self).filter("taskDate BETWEEN %@", [dateStart, dateEnd])
        tableView.reloadData()
    }
    
    //MARK: Segway transmission
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let tasks = tasksArray[indexPath.row]
            let dstVC = segue.destination as! TasksOptionTableViewController
            dstVC.editTasks = tasks
        }
    }
}

//MARK: FSCalendarDataSource, FSCalendarDelegate

extension TasksViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        tasksOnDay(date: date)
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate

extension TasksViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCellTasks
        
        
        let tasks = tasksArray[indexPath.row]

        cell.configure(with: tasks)
        cell.cellDelegate = self
        cell.index = indexPath
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = tasksArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Удалить", comment: "Delete cell")) { (_, _, completionHandler) in
            
            try! self.realm.write {
                self.realm.delete(editingRow)
                tableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

//MARK: TableViewContent

extension TasksViewController: TableViewContent {
    func clickButtonReady(index: Int) {
        
        let tasks = tasksArray[index]
        if tasks.taskReady == 0 {
            try! self.realm.write {
                tasks.taskReady = 1
                tableView.reloadData()
            }
        } else {
            try! self.realm.write {
                tasks.taskReady = 0
                tableView.reloadData()
            }
        }
    }
}
