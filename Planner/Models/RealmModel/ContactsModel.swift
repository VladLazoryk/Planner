import RealmSwift

class ContactsModel: Object {
    
    @objc dynamic var contactsName = ""
    @objc dynamic var contactsPhone = ""
    @objc dynamic var contactsMail = ""
    @objc dynamic var contactsType = ""
    @objc dynamic var contactsImage: Data?
}
