import UIKit

class DetailViewController: UIViewController {

    var db:DB!
    let URL_DELETE_REVIEW = "http://219.110.98.184/MyWebService/api/deletereview.php"
    
    @IBOutlet weak var store: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var rate: UILabel!
    @IBOutlet weak var comment: UILabel!
    @IBOutlet weak var pass: UITextField!
    @IBOutlet weak var passL: UILabel!
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteButton(_ sender: Any) {
        //テキストフィールドから値の取得
            let password = pass.text
            
            if (password == "") {
                passL.text = "パスワードを入力してください"
            }else {
                
                //created NSURL
                let requestURL = NSURL(string: URL_DELETE_REVIEW)
            
                //creating NSMutableURLRequest
                let request = NSMutableURLRequest(url: requestURL! as URL)
            
                //setting the method to post
                request.httpMethod = "POST"
                //テキストフィールドからキーと値を連結してpostパラメータを生成する
                let postParameters = "num="+db.num+"&password="+password!;
            
                //ボディをリクエストするためのパラメータを追加する
                request.httpBody = postParameters.data(using: String.Encoding.utf8)
            
                //投稿要求を送信するタスクを作成する
                let task =  URLSession.shared.dataTask(with: request as URLRequest){
                    data, response, error in
                
                    if error != nil {
                        print("error is \(String(describing: error))")
                        return;
                    }
                
                    //返ってきたJsonの解析
                    do {
                        //NSDictionaryに変換する
                        let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                    
                        //jsonデータの解析
                        if let parseJSON = myJSON {
                            //jsonからのレスポンスを取得
                            msg = parseJSON["message"] as! String?
                        }
                    }catch{
                        print(error)
                    }
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "mySegue", sender: nil)
                    }
                }
                task.resume()
            }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.store.text = self.db.store
        self.name.text = self.db.name
        self.rate.text = self.db.rate
        self.comment.text = self.db.comment
        var fixedFrame = self.comment.frame
        self.comment.sizeToFit()
        fixedFrame.size.height = self.comment.frame.size.height
        self.comment.frame = fixedFrame
    }
}
