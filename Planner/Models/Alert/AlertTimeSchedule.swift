import UIKit

extension UIViewController {
    
    func alertTimeSchedule(label: UILabel, completionHandler: @escaping (NSDate) -> Void) {
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        
        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        alert.view.addSubview(datePicker)
        datePicker.locale = Locale.init(identifier: "ru")
        
        let ok = UIAlertAction(title: NSLocalizedString("Выбрать", comment: "choose alert"), style: .default) { (action) in

            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let timeString = dateFormatter.string(from: datePicker.date)
            let timeSchedule = datePicker.date as NSDate
            completionHandler(timeSchedule)
            
            label.text = "\(timeString)"
        }
        
        let cancel = UIAlertAction(title: NSLocalizedString("Отмена", comment: "cancel alert"), style: .default, handler: nil)
        
        alert.addAction(ok)
        alert.addAction(cancel)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.widthAnchor.constraint(equalTo: alert.view.widthAnchor).isActive = true
        alert.view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        datePicker.heightAnchor.constraint(equalToConstant: 160).isActive = true
        datePicker.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 20).isActive = true
        
        present(alert, animated: true, completion: nil)
   
    } 
}






