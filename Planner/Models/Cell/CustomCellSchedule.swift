import UIKit

class CustomCellSchedule: UITableViewCell {

    @IBOutlet var lessonNameLabel: UILabel!
    @IBOutlet var timeStartLessonLabel: UILabel!
    @IBOutlet var teacherNameLabel: UILabel!
    @IBOutlet var typeLessonLabel: UILabel!
    @IBOutlet var numberOfBuildingLabel: UILabel!
    @IBOutlet var numberOfClassLabel: UILabel!
    
    func configure(with schedule: ScheduleModel) {
        
         let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        self.lessonNameLabel.text = schedule.scheduleName
        self.timeStartLessonLabel.text = dateFormatter.string(from: schedule.scheduleTime as Date)
        self.teacherNameLabel.text = schedule.scheduleTeacher
        self.typeLessonLabel.text = schedule.scheduleType
        self.numberOfBuildingLabel.text = schedule.scheduleBuild
        self.numberOfClassLabel.text = schedule.scheduleAud
        self.backgroundColor = UIColor().colorFromHex("#\(schedule.scheduleColorCell)")
    }
}
