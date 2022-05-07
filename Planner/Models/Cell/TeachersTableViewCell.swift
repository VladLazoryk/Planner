import UIKit

class TeachersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teacherImageLabel: UIImageView!
    @IBOutlet weak var teacherNameLabel: UILabel!
    @IBOutlet weak var teacherPhoneLabel: UILabel!
    @IBOutlet weak var teacherMailLabel: UILabel!
    
    func configure(with teachers: ContactsModel) {

        self.teacherImageLabel.image = UIImage(data: teachers.contactsImage!)
        self.teacherImageLabel.layer.cornerRadius = teacherImageLabel.frame.size.height / 2
        self.teacherImageLabel.clipsToBounds = true
        
        self.teacherNameLabel.text = teachers.contactsName
        self.teacherPhoneLabel.text = teachers.contactsPhone
        self.teacherMailLabel.text = teachers.contactsMail
           
       }
}
