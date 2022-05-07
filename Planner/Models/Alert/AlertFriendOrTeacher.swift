import UIKit

extension UIViewController {
    
    func alertFriendOrTeacher(label: UILabel, completionHandler: @escaping (String) -> Void) {
        
        
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let friends = UIAlertAction(title: NSLocalizedString("Друзья", comment: "type contact alert"), style: .default) { _ in
            label.text = NSLocalizedString("Друг", comment: "type contact alert")
            let typeContact = "friend"
            completionHandler(typeContact)
        }

        let teachers = UIAlertAction (title: NSLocalizedString("Преподаватели", comment: "type contact alert"), style: .default) { _ in
            label.text = NSLocalizedString("Преподаватель", comment: "type contact alert")
            let typeContact = "teacher"
            completionHandler(typeContact)
        }

        let cancel = UIAlertAction(title: NSLocalizedString("Отмена", comment: "cancel alert"), style: .cancel)

        actionSheet.addAction(friends)
        actionSheet.addAction(teachers)
        actionSheet.addAction(cancel)

        present(actionSheet, animated: true)

    }
}





