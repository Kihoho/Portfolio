import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myScrollView.delegate = self as UIScrollViewDelegate
        // 縦方向と、横方向のインディケータを非表示にする.
        myScrollView.showsHorizontalScrollIndicator = false;
        myScrollView.showsVerticalScrollIndicator = false
        myImageView.isUserInteractionEnabled = true
        myScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * 3, height: 0)
        
        // 1枚目の画像
        let firstImageView = UIImageView(image: image[0])
        firstImageView.frame = CGRect(x: UIScreen.main.bounds.width * 0.0, y: -65.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        firstImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myScrollView.addSubview(firstImageView)

        // 2枚目の画像
        let secondImageView = UIImageView(image: image[1])
        secondImageView.frame = CGRect(x: UIScreen.main.bounds.width * 1.0, y: -65.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        secondImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myScrollView.addSubview(secondImageView)

        // 3枚目の画像
        let thirdImageView = UIImageView(image: image[2])
        thirdImageView.frame = CGRect(x: UIScreen.main.bounds.width * 2.0, y: -65.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        thirdImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myScrollView.addSubview(thirdImageView)
        
        if (imageNum == 0) {
        }else if (imageNum == 1) {
            myScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 1.0, y: 0);
        }else {
            myScrollView.contentOffset = CGPoint(x: UIScreen.main.bounds.width * 2.0, y: 0);
        }
    }
}
