import UIKit

extension UIViewController {
    
    func alertDateSchedule(label: UILabel, completionHandler: @escaping (Int, NSDate) -> Void) {

        let alert = UIAlertController(title: "\n\n\n\n\n\n\n\n\n\n\n", message: nil, preferredStyle: .actionSheet)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date

        alert.view.addSubview(datePicker)
        
        datePicker.locale = Locale.init(identifier: "ru")
        let locale = NSLocale.preferredLanguages.first
        
        switch locale {
        case "az": datePicker.locale = Locale.init(identifier: "ru")
        case "hy": datePicker.locale = Locale.init(identifier: "ru")
        case "be": datePicker.locale = Locale.init(identifier: "ru")
        case "ky": datePicker.locale = Locale.init(identifier: "ru")
        case "uk": datePicker.locale = Locale.init(identifier: "ru")
        case "tg": datePicker.locale = Locale.init(identifier: "ru")
        case "tk": datePicker.locale = Locale.init(identifier: "ru")
        case "uz": datePicker.locale = Locale.init(identifier: "ru")
            
        default: datePicker.locale = Locale.init(identifier: "en")
        }
        
        let ok = UIAlertAction(title: NSLocalizedString("Выбрать", comment: "choose alert"), style: .default) { (action) in
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy"
            let dateString = dateFormatter.string(from: datePicker.date)
            
            let calendar = Calendar.current
            let components = calendar.dateComponents([.weekday], from: datePicker.date as Date)
            let numberWeekday = components.weekday!
            let date = datePicker.date as NSDate
            completionHandler(numberWeekday, date)

            label.text = "\(dateString)"
 
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


