import UIKit
import RealmSwift
import Foundation

class ScheduleOptionTableViewController: UITableViewController {
    
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var buildLabel: UILabel!
    @IBOutlet var audLabel: UILabel!
    @IBOutlet var nameTeacherLabel: UILabel!
    @IBOutlet var switchLabel: UISwitch!
    
    var colorCell = UIColor().colorFromHex("#FF7E79")
    
    var numberOfWeekday = Int()
    var colorSchedule = "FF7E79"
    var repeatSchedule = true
    var dateSchedule = NSDate()
    var timeSchedule = NSDate()
    
    let realm = try! Realm()
    var scheduleArray: Results<ScheduleModel>!
    
    var editSchedule: ScheduleModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switchLabel.addTarget(self, action: #selector(switchChange(paramTarget:)), for: .valueChanged)
        
        setupEditScreen()
  
    }
    
    @IBAction func saveObject(_ sender: UIBarButtonItem) {
        
        let value = ScheduleModel(value: [dateSchedule,
                                          timeSchedule,
                                          nameLabel.text!,
                                          typeLabel.text!,
                                          buildLabel.text!,
                                          audLabel.text!,
                                          colorSchedule,
                                          nameTeacherLabel.text!,
                                          repeatSchedule,
                                          numberOfWeekday])

        if editSchedule != nil {
            try! realm.write {
                EditingCell()
            }
            
        } else {
            if nameLabel.text == "Название" || dateLabel.text == "Дата" || timeLabel.text == "Время" {
                alertOk(with: NSLocalizedString("Ошибка", comment: "Alert Error"),
                        and: NSLocalizedString("Введите дату, время и название", comment: "Enter date, time and name"))
            } else {
                try! realm.write {
                    realm.add(value)
                }
                alertOk(with: NSLocalizedString("Успешно!", comment: "Success"),
                        and: NSLocalizedString("Предмет добавлен в расписание", comment: "Lesson add in schedule"))
                refreshCells()
            }
        }
    }
    
    //MARK: Switch
    @objc func switchChange(paramTarget: UISwitch) {
        if paramTarget.isOn {
            repeatSchedule = true
        } else {
            repeatSchedule = false
        }
    }
    
    //MARK: TableView Option
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        colorOfCell()
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 4
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0: 
                alertDateSchedule(label: dateLabel) { (weekdayNumber, date) in
                    self.numberOfWeekday = weekdayNumber
                    self.dateSchedule = date
                }
            case 1:
                alertTimeSchedule(label: timeLabel) { (time) in
                    self.timeSchedule = time
                }
            default:
                print("section 0 error")
            }
        }
        
        if indexPath.section == 1 {
            switch indexPath.row {
            case 0: alertForCell(label: nameLabel, name: NSLocalizedString("Название", comment: "Name alert"),
                                 placeholder: NSLocalizedString("Введите название предмета", comment: "Enter lesson name alert"))
            case 1: alertForCell(label: typeLabel, name: NSLocalizedString("Тип предмета", comment: "Type less alert"),
                                 placeholder: NSLocalizedString("Введите тип предмета", comment: "Enter type less alert"))
            case 2: alertForCell(label: buildLabel, name: NSLocalizedString("Корпус", comment: "Building alert"),
                                 placeholder: NSLocalizedString("Введите корпус", comment: "Enter build alert"))
            case 3: alertForCell(label: audLabel, name: NSLocalizedString("Аудитория", comment: "Aud alert"),
                                 placeholder: NSLocalizedString("Введите аудиторию", comment: "Enter aud alert"))
            default:
                print("section 2 error")
            }
        }
    }
    
    //MARK: Segway transmission
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSelect" {
            if let selectVC = segue.destination as? ColorTableViewController {
                selectVC.completion = { color in
                    self.colorCell = UIColor().colorFromHex("#\(color)")
                    self.colorSchedule = "\(color)"
                    self.colorOfCell()
                }
            }
        }
        
        if segue.identifier == "selectTeacher" {
            if let selectVC = segue.destination as? TeacherTableViewController {
                selectVC.completion = { nameTeacher in
                    self.nameTeacherLabel.text = nameTeacher
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
        dateLabel.text = NSLocalizedString("Дата", comment: "Date")
        timeLabel.text = NSLocalizedString("Время", comment: "Time")
        nameLabel.text = NSLocalizedString("Название", comment: "Name")
        typeLabel.text = NSLocalizedString("Тип", comment: "Type")
        buildLabel.text = NSLocalizedString("Корпус", comment: "Build")
        audLabel.text = NSLocalizedString("Аудитория", comment: "Aud")
        nameTeacherLabel.text = NSLocalizedString("ФИО", comment: "Name")
        switchLabel.isOn = true
        colorCell = UIColor().colorFromHex("#FF7E79")
        colorOfCell()
    }
    
    
    //MARK: Setup Edit Screen
    
    func setupEditScreen() {
        
        if editSchedule != nil {
            
            navigationItem.title = NSLocalizedString("Редактирование", comment: "editing title")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: editSchedule!.scheduleDate as Date)
            dateSchedule = editSchedule!.scheduleDate
            dateLabel.text = dateString
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            let timeString = timeFormatter.string(from: editSchedule!.scheduleTime as Date)
            timeSchedule = editSchedule!.scheduleTime
            timeLabel.text = timeString
            
            
            nameLabel.text = editSchedule?.scheduleName
            typeLabel.text = editSchedule?.scheduleType
            buildLabel.text = editSchedule?.scheduleBuild
            audLabel.text = editSchedule?.scheduleAud
            nameTeacherLabel.text = editSchedule?.scheduleTeacher
            colorCell = UIColor().colorFromHex("#\(String(editSchedule!.scheduleColorCell))")
            colorSchedule = editSchedule!.scheduleColorCell
            
            switchLabel.isOn = (editSchedule?.scheduleRepeat)!
        }
    }
    
    func EditingCell() {
        
        editSchedule?.scheduleDate = dateSchedule
        editSchedule?.scheduleTime = timeSchedule
        editSchedule?.scheduleName = nameLabel.text!
        editSchedule?.scheduleType = typeLabel.text!
        editSchedule?.scheduleBuild = buildLabel.text!
        editSchedule?.scheduleAud = audLabel.text!
        editSchedule?.scheduleColorCell = colorSchedule
        editSchedule?.scheduleTeacher = nameTeacherLabel.text!
        
        if switchLabel.isOn {
            editSchedule?.scheduleRepeat = true
        } else {
            editSchedule?.scheduleRepeat = false
        }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.weekday], from: editSchedule!.scheduleDate as Date)
        numberOfWeekday = components.weekday!
        editSchedule?.scheduleWeekday = numberOfWeekday
        alertOk(with: NSLocalizedString("Успешно!", comment: "Success alert"),
                and: NSLocalizedString("Изменения сохранены", comment: "Changes saved"))
    }
}
