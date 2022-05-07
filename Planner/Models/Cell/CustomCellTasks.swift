import UIKit

class CustomCellTasks: UITableViewCell {

    @IBOutlet weak var nameTaskLabel: UILabel!
    @IBOutlet weak var discriptionTaskLabel: UILabel!
    @IBOutlet var buttonReady: UIButton!
    
    var cellDelegate: TableViewContent?
    var index: IndexPath?
  
    @IBAction func pressReady(_ sender: Any) {
        cellDelegate?.clickButtonReady(index: (index?.row)!)
    }
    
    func configure(with tasks: TasksModel) {
    
        self.nameTaskLabel.text = tasks.taskName
           self.discriptionTaskLabel.text = tasks.taskDescription
        self.backgroundColor = UIColor().colorFromHex("#\(tasks.taskColorCell)")
        
        if tasks.taskReady == 0 {
            self.buttonReady.setBackgroundImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        } else {
            self.buttonReady.setBackgroundImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
        }
        
    }
}
