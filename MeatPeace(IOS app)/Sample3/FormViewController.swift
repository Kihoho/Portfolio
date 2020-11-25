import UIKit

class FormViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    //URL to our web service
    let URL_CREATE_REVIEW = "http://219.110.98.184/MyWebService/api/createreview.php"
    var db:DB!
    
    @IBOutlet weak var storeL: UILabel!
    @IBOutlet weak var nameT: UITextField!
    @IBOutlet weak var rateT: UITextField!
    @IBOutlet weak var passT: UITextField!
    @IBOutlet weak var nameL: UILabel!
    @IBOutlet weak var rateL: UILabel!
    @IBOutlet weak var commentL: UILabel!
    @IBOutlet weak var passL: UILabel!
    @IBOutlet weak var commentT: UITextView!
    
    var pickerView: UIPickerView = UIPickerView()
    let list = ["", "1", "2", "3", "4", "5"]
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return list.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return list[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.rateT.text = list[row]
    }
    
    func cancel() {
        self.rateT.text = ""
        self.rateT.endEditing(true)
    }

    @objc func done() {
        self.rateT.endEditing(true)
    }

    func CGRectMake(_ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, width: width, height: height)
    }
    
    @IBAction func createButton(_ sender: Any) {
        //テキストフィールドから値の取得
        let store = storeL.text
        let name = nameT.text
        let rate = rateT.text
        let comment = commentT.text
        let pass = passT.text
        
        if (name == "") {
            nameL.text = "名前を入力してください"
        }else {
            nameL.text = ""
        }
        if (rate == "") {
            rateL.text = "評価を入力してください"
        }else {
            rateL.text = ""
        }
        if (comment == "") {
            commentL.text = "コメントを入力してください"
        }else {
            commentL.text = ""
        }
        if (pass == "") {
            passL.text = "パスワードを入力してください"
        }else {
            passL.text = ""
        }
        if (nameT.text != "" && rateT.text != "" && commentT.text != "" && passT.text != "") {
            //created NSURL
            let requestURL = NSURL(string: URL_CREATE_REVIEW)
        
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
        
            //setting the method to post
            request.httpMethod = "POST"
        
            //テキストフィールドからキーと値を連結してpostパラメータを生成する
            let postParameters = "store="+store!+"&name="+name!+"&comment="+comment!+"&rate="+rate!+"&pass="+pass!;
        
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
                    self.performSegue(withIdentifier: "mySegue2", sender: nil)
                }
            }
            task.resume()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        commentT.layer.borderWidth = 1
        commentT.layer.borderColor = UIColor.lightGray.cgColor
        
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.showsSelectionIndicator = true
        let toolbar = UIToolbar(frame: CGRectMake(0, 0, 0, 35))
        let doneItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(FormViewController.done))
        toolbar.setItems([doneItem], animated: true)

        self.rateT.inputView = pickerView
        self.rateT.inputAccessoryView = toolbar
        self.rateT.text = list[0]
        
        storeL.text = item.alias[num][0]
    }
}
