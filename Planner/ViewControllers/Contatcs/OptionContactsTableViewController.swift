import UIKit
import RealmSwift

class OptionContactsTableViewController: UITableViewController {
    
    @IBOutlet weak var nameContactLabel: UILabel!
    @IBOutlet weak var phoneContactLabel: UILabel!
    @IBOutlet weak var mailContactLabel: UILabel!
    @IBOutlet weak var typeContactLabel: UILabel!
    @IBOutlet weak var imageOfContact: UIImageView!
    
    let realm = try! Realm()
    
    var typeContact = ""
    
    var editContacts: ContactsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupEditScreen()
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        let image = imageOfContact.image
        guard let imageData = image?.pngData() else { return }
        
        let value = ContactsModel(value: [nameContactLabel.text!,
                                          phoneContactLabel.text!,
                                          mailContactLabel.text!,
                                          typeContact,
                                          imageData])
        
        if editContacts != nil {
            try! realm.write {
                editingCell()
            }
        } else {
            if nameContactLabel.text == "Имя" || typeContactLabel.text == "Тип контакта" {
                alertOk(with: NSLocalizedString("Ошибка", comment: "Alert Error"),
                        and: NSLocalizedString("Введите имя и тип", comment: "Enter name and type"))
            } else {
                try! realm.write {
                    realm.add(value)
                }
                alertOk(with: NSLocalizedString("Успешно!", comment: "Success"),
                        and: NSLocalizedString("Изменения сохранены", comment: "Changes saved alert"))
                refreshCells()
            }
        }
    }
    
    //MARK: TableView Option
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        switch indexPath.section {
        case 0:
            alertForCell(label: nameContactLabel, name: NSLocalizedString("Имя", comment: "Name alert"),
                         placeholder: NSLocalizedString("Введите имя", comment: "Enter name alert"))
        case 1:
            alertForCell(label: phoneContactLabel, name: NSLocalizedString("Телефон", comment: "Phone alert"),
                         placeholder: NSLocalizedString("Введите телефон", comment: "Enter phone alert"))
        case 2:
            alertForCell(label: mailContactLabel, name: NSLocalizedString("Почта", comment: "email alert"),
                         placeholder: NSLocalizedString("Введите почту", comment: "Enter email alert"))
        case 3:
            alertFriendOrTeacher(label: typeContactLabel) { (type) in
                self.typeContact = type
            }
        case 4:
            alertCameraOrGallery()
            
        default:
            print("error in section")
        }
    }
    
    //MARK: SetupEditScreen
    
    private func setupEditScreen() {
        if editContacts != nil {
            
            navigationItem.title = NSLocalizedString("Редактирование", comment: "editing title")
            
            nameContactLabel.text = editContacts?.contactsName
            phoneContactLabel.text = editContacts?.contactsPhone
            mailContactLabel.text = editContacts?.contactsMail
            typeContactLabel.text = editContacts?.contactsType
            
            guard let data = editContacts?.contactsImage, let image = UIImage(data: data) else { return }
            
            imageOfContact.image = image
            imageOfContact.contentMode = .scaleAspectFill
        }
    }
    
    //MARK: refreshCells
    
    func refreshCells() {
        
        nameContactLabel.text = NSLocalizedString("Имя", comment: "Name")
        phoneContactLabel.text = NSLocalizedString("Телефон", comment: "Phone")
        mailContactLabel.text = NSLocalizedString("Почта", comment: "Mail")
        typeContactLabel.text = NSLocalizedString("Тип контакта", comment: "Type")
        imageOfContact.image = UIImage(systemName: "person.crop.circle.badge.plus")
        imageOfContact.contentMode = .scaleAspectFit
    }
    
    //MARK: EditingCell
    
    func editingCell() {
        
        editContacts?.contactsName = nameContactLabel.text!
        editContacts?.contactsPhone = phoneContactLabel.text!
        editContacts?.contactsMail = mailContactLabel.text!
        editContacts?.contactsType = typeContactLabel.text!
        
        let image = imageOfContact.image
        guard let imageData = image?.pngData() else { return }
        
        editContacts?.contactsImage = imageData
        
        alertOk(with: NSLocalizedString("Успешно!", comment: "Success alert"),
                and: NSLocalizedString("Изменения сохранены", comment: "Changes saved"))
    }
    
    //MARK: AlertCameraOrGallery
    
    func alertCameraOrGallery() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: NSLocalizedString("Камера", comment: "camera alert"), style: .default) { _ in
            self.chooseImagePicker(source: .camera)
        }
        let photo = UIAlertAction (title: NSLocalizedString("Галерея", comment: "galery alert"), style: .default) { _ in
            self.chooseImagePicker(source: .photoLibrary)
        }
        let cancel = UIAlertAction(title: NSLocalizedString("Отмена", comment: "cancel alert"), style: .cancel)
        
        actionSheet.addAction(camera)
        actionSheet.addAction(photo)
        actionSheet.addAction(cancel)
        
        present(actionSheet, animated: true)
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension OptionContactsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageOfContact.image = info[.editedImage] as? UIImage
        imageOfContact.contentMode = .scaleAspectFill
        imageOfContact.clipsToBounds = true
        dismiss(animated: true)
    }
}
