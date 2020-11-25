import UIKit
var image = [UIImage]()
var imageNum = 1

class DetailContoroller: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var alias: UILabel!
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var address3: UILabel!
    @IBOutlet weak var address4: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var reviewTable: UITableView!
    
    let URL_SELECT_REVIEW = "http://219.110.98.184/MyWebService/api/selectreview.php"
    var dbList:[DB] = []
    var db:DB!
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func pushPhoto1(sender: UIButton){
        imageNum = 0
        //ストーリーボードの名前を指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "imageDetail")
        //popoverを指定する
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        present(vc, animated: true, completion: nil)
        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
    }
    
    @objc func pushPhoto2(sender: UIButton){
        imageNum = 1
        //ストーリーボードの名前を指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "imageDetail")
        //popoverを指定する
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        present(vc, animated: true, completion: nil)
        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
    }
    
    @objc func pushPhoto3(sender: UIButton){
        imageNum = 2
        //ストーリーボードの名前を指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "imageDetail")
        //popoverを指定する
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        present(vc, animated: true, completion: nil)
        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
    }
    
    @IBAction func reviewButton(_ sender: Any) {
        //ストーリーボードの名前を指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "formDetail")
        //popoverを指定する
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        present(vc, animated: true, completion: nil)
        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
    }
    
    //URLを指定して画像を取得
    func getImageByUrl(url: String) -> UIImage{
        let url = URL(string: url)
        do {
            let data = try Data(contentsOf: url!)
            return UIImage(data: data)!
        } catch let err {
            print("Error : \(err.localizedDescription)")
        }
        return UIImage()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        let index = sender as! Int
        vc.db = dbList[index]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dbList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "myCell")
        cell.textLabel?.text = self.dbList[indexPath.row].comment
        cell.textLabel!.font = UIFont(name:"Montserrat-Regular",size:14)
        
        return cell
    }
    
    func onResponse(data:Data?, response:URLResponse?, error:Error?){
        guard let data = data else {
            print("データなし")
            return
        }
        if(data.count <= 500) {
            print("データなし")
            return
        }
        guard let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
            return
        }
        self.parseData(src: jsonData)
    }
    
    func parseData(src:[String: Any]) {
        self.dbList = []
        for val in src["review"] as! [Any]{
            let review = val as! [String: Any]
            let db = DB()
            db.store = review["store"] as! String
            db.num = review["num"] as! String
            db.name = review["name"] as! String
            db.comment = review["comment"] as! String
            db.rate = review["rate"] as! String
            db.pass = review["pass"] as! String            
            self.dbList.append(db)
        }
        DispatchQueue.main.async {
            self.reviewTable.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reviewTable.dataSource = self
        reviewTable.delegate = self
        
        alias.text = item.alias[num][0]
        phone.text = item.phone[num][0]
        
        let image1 = getImageByUrl(url:item.photo[num][0])
        let image2 = getImageByUrl(url:item.photo[num][1])
        let image3 = getImageByUrl(url:item.photo[num][2])
        image = [image1, image2, image3]
        
        
        let photo1:UIButton = UIButton(frame: CGRect(x: 20, y: 92, width: 184, height: 155))
        photo1.setImage(image1, for: .normal)
        photo1.addTarget(self, action: #selector(pushPhoto1), for: .touchUpInside)
        self.view.addSubview(photo1)
        let photo2:UIButton = UIButton(frame: CGRect(x: 212, y: 92, width: 147, height: 73))
        photo2.setImage(image2, for: .normal)
        photo2.addTarget(self, action: #selector(pushPhoto2), for: .touchUpInside)
        self.view.addSubview(photo2)
        let photo3:UIButton = UIButton(frame: CGRect(x: 212, y: 174, width: 147, height: 73))
        photo3.setImage(image3, for: .normal)
        photo3.addTarget(self, action: #selector(pushPhoto3), for: .touchUpInside)
        self.view.addSubview(photo3)
        
        address1.text = item.address[num][0]
        address2.text = item.address[num][1]
        address3.text = item.address[num][2]
        address4.text = item.address[num][3]
        
        //created NSURL
        let requestURL = NSURL(string: URL_SELECT_REVIEW)
        //creating NSMutableURLRequest
        let request = NSMutableURLRequest(url: requestURL! as URL)
        //setting the method to post
        request.httpMethod = "POST"
        //テキストフィールドから値の取得
        let store = alias.text
        //テキストフィールドからキーと値を連結してpostパラメータを生成する
        let postParameters = "store="+store!;
        //ボディをリクエストするためのパラメータを追加する
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        //投稿要求を送信するタスクを作成する
        let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: self.onResponse)
            task.resume()
    }
}
