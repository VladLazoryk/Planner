import UIKit

extension UIViewController {
 
    func alertDescription(label: UILabel, name: String, placeholder: String, textView: UITextView) {
        
        
        let alertController = UIAlertController(title: NSLocalizedString("Введите задание \n\n\n\n\n", comment: "cancel alert"), message: nil, preferredStyle: .alert)
              
              let cancelAction = UIAlertAction.init(title: NSLocalizedString("Отмена", comment: "cancel alert"), style: .default) { (action) in
                  alertController.view.removeObserver(self, forKeyPath: "bounds")
              }
              
              let saveAction = UIAlertAction(title: "OK", style: .default) { (action) in
                  
                  let tfname = textView.text
                  
                  guard tfname != "" else { return }
                  label.text = tfname
    
                  alertController.view.removeObserver(self, forKeyPath: "bounds")
                  
              }
              alertController.addAction(saveAction)
              alertController.addAction(cancelAction)
              
              alertController.view.addObserver(self, forKeyPath: "bounds", options: NSKeyValueObservingOptions.new, context: nil)
              
              textView.layer.cornerRadius = 10
              textView.textContainerInset = UIEdgeInsets.init(top: 8, left: 5, bottom: 8, right: 5)
              alertController.view.addSubview(textView)
              
              self.present(alertController, animated: true, completion: nil)
          }
    }
    
