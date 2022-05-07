import UIKit

class ColorTableViewController: UITableViewController {
    
    var color = ""
    var completion: ((String) -> () )?
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 8
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 0:
            color = "FFFFFF"
            prepareSegueColor()
        case 1:
            color = "FF7E79"
            prepareSegueColor()
        case 2:
            color = "FF9300"
            prepareSegueColor()
        case 3:
            color = "FFFC79"
            prepareSegueColor()
        case 4:
            color = "008F00"
            prepareSegueColor()
        case 5:
            color = "0096FF"
            prepareSegueColor()
        case 6:
            color = "011993"
            prepareSegueColor()
        case 7:
            color = "531B93"
            prepareSegueColor()
        default:
            print("color error")
        }
    }
    
    func prepareSegueColor() {
        completion?(color)
        self.navigationController?.popViewController(animated: true)
    }
}
