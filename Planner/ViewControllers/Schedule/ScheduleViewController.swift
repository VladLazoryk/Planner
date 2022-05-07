import UIKit
import FSCalendar
import RealmSwift

class ScheduleViewController: UIViewController {
    
    @IBOutlet var buttonShowHide: UIButton!
    @IBOutlet var calendarFS: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet var tableView: UITableView!
    
    let realm = try! Realm()
    var scheduleArray: Results<ScheduleModel>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendarFS.delegate = self
        calendarFS.dataSource = self
        self.calendarFS.scope = .week
        
        scheduleOnDay(date: calendarFS.today!)
        
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
    
    //MARK: Daily schedule

    func scheduleOnDay(date: Date ) {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: date)
        let weekday: Int = components.weekday!
        
        let dateStart = date
        let dateEnd: Date = {
            let components = DateComponents(day: 1, second: -1)
            return Calendar.current.date(byAdding: components, to: dateStart)!
        }()
        
        let predicate1 = NSPredicate(format: "scheduleWeekday = \(weekday) AND scheduleRepeat = true")
        let predicate2 = NSPredicate(format: "scheduleRepeat = false AND scheduleDate BETWEEN %@", [dateStart, dateEnd])
        let compound = NSCompoundPredicate(type: .or, subpredicates: [predicate1, predicate2])
        scheduleArray = realm.objects(ScheduleModel.self).filter(compound).sorted(byKeyPath: "scheduleTime")
        tableView.reloadData()
        
    }
    
    //MARK: Segway transmission
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let schedule = scheduleArray[indexPath.row]
            let dstVC = segue.destination as! ScheduleOptionTableViewController
            dstVC.editSchedule = schedule
        }
    }
}
//MARK: FSCalendarDataSource + FSCalendarDelegate

extension ScheduleViewController: FSCalendarDataSource, FSCalendarDelegate {
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        scheduleOnDay(date: date)
    }
}

//MARK: UITableViewDataSource + UITableViewDelegate

extension ScheduleViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return scheduleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCellSchedule
        
        let schedule = scheduleArray[indexPath.row]
        cell.configure(with: schedule)

        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let editingRow = scheduleArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Удалить", comment: "Delete cell")) { (_, _, completionHandler) in
            
            try! self.realm.write {
                self.realm.delete(editingRow)
                tableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
