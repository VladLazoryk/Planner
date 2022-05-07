import UIKit
import FSCalendar

struct CalendarAction {
    
    static let shared = CalendarAction()

    func calendarHide(calendar: FSCalendar, button: UIButton) {
        
        calendar.setScope(.month, animated: true)
        button.setTitle(NSLocalizedString("Скрыть календарь", comment: "hide calendar"), for: .normal)
        
    }
    
    func calendarOpen(calendar: FSCalendar, button: UIButton) {
        
        calendar.setScope(.week, animated: true)
        button.setTitle(NSLocalizedString("Открыть календарь", comment: "open calendar"), for: .normal)
    }
}
