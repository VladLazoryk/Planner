import UIKit
import RealmSwift

class TeacherTableViewController: UITableViewController {
    
    let realm = try! Realm()
    var teacherArray: Results<ContactsModel>!
    
    var nameTeacher = ""
    var completion: ((String) -> () )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        teacherArray = realm.objects(ContactsModel.self).filter("contactsType = 'teacher'")
    }
    
    //MARK: TableView Option
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return teacherArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TeachersTableViewCell
        
        let teachers = teacherArray[indexPath.row]
        cell.configure(with: teachers)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let teachers = teacherArray[indexPath.row]
        nameTeacher = teachers.contactsName
        prepareSegueTeacher()
    }
    
    //MARK: Completion data
    func prepareSegueTeacher() {
        completion?(nameTeacher)
        self.navigationController?.popViewController(animated: true)
    }
}
