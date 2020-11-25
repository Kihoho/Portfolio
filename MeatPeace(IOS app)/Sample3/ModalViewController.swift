import UIKit

class ModalViewController: UIViewController {
    
    @IBOutlet weak var message: UILabel!
    @IBAction func close(_ sender: Any) {
        print("1\(msg)")
        if (msg == "レビューを投稿しました。" || msg == "レビューを削除しました。") {
            self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        message.text = msg
        print("2\(msg)")
    }
}
