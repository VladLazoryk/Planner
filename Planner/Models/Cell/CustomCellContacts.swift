import UIKit

class CustomCellContacts: UITableViewCell {

    @IBOutlet weak var imageContacts: UIImageView!
    @IBOutlet weak var nameContactsLabel: UILabel!
    @IBOutlet weak var phoneContactsLabel: UILabel!
    @IBOutlet weak var mailContactsLabel: UILabel!
    @IBOutlet weak var typeContactsLabel: UILabel!
    
     func configure(with contacts: ContactsModel) {
        
        nameContactsLabel.text = contacts.contactsName
        phoneContactsLabel.text = contacts.contactsPhone
        mailContactsLabel.text = contacts.contactsMail
        imageContacts.image = UIImage(data: contacts.contactsImage!)
        imageContacts.layer.cornerRadius = imageContacts.frame.size.height / 2
        imageContacts.clipsToBounds = true
    }
}
