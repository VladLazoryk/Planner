import RealmSwift

class ScheduleModel: Object {
    
    @objc dynamic var scheduleDate = NSDate()
    @objc dynamic var scheduleTime = NSDate()
    @objc dynamic var scheduleName = ""
    @objc dynamic var scheduleType = ""
    @objc dynamic var scheduleBuild = ""
    @objc dynamic var scheduleAud = ""
    @objc dynamic var scheduleColorCell = ""
    @objc dynamic var scheduleTeacher = ""
    @objc dynamic var scheduleRepeat = true
    @objc dynamic var scheduleWeekday: Int = 1
}

