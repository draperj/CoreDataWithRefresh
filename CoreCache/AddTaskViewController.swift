import UIKit

class AddTaskViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func buttonTapped(_ sender: UIButton) {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate, let navController = navigationController else {
            return
        }
        let context = delegate.persistentContainer.viewContext
        let task = Task(context: context) // Link Task & Context
        task.name = taskTextField.text!
        
        // Save the data to coredata
        delegate.saveContext()
        
        navController.popViewController(animated: true)
    }
}
