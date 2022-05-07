import Foundation

import RealmSwift

class TasksModel: Object {
    
    @objc dynamic var taskDate = NSDate()
    @objc dynamic var taskName = ""
    @objc dynamic var taskDescription = ""
    @objc dynamic var taskColorCell = ""
    @objc dynamic var taskReady: Int = 1
}
