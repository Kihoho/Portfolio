import UIKit
import MapKit
import CoreLocation
var item = Item()
var num = 0
var msg:String!

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UIPopoverControllerDelegate {
    
    @IBOutlet weak var mapV: MKMapView!
    @IBOutlet weak var textV: UITextField!
    var annotationArray: [MKAnnotation] = []
    var from:CLLocationCoordinate2D! = nil
    var fromPin:MKPointAnnotation! = nil
    var locationManager: CLLocationManager!
    var latitude = 0.0
    var longitude = 0.0
    let URL_yelp = "http://172.20.10.9/MyWebService/api/yelp.php"
    
    //位置情報の許可を取得
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:  /* 初期状態 */
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            break
        case .authorizedAlways, .authorizedWhenInUse:
            break
        default:
            print("エラー")
        }
    }
    
    func getRegion() {
        let initialCoordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude)
        // 表示する範囲を指定
        let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
        // 領域を作成
        let region = MKCoordinateRegion(center: initialCoordinate, span: span)
        // 領域をmapViewに設定
        self.mapV.setRegion(region, animated:true)
    }
    
    //現在地を取得
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if let newLocation = locations.last{
            let mapView = MKMapView()
            mapView.delegate = self
            latitude = newLocation.coordinate.latitude
            longitude = newLocation.coordinate.longitude
            from = CLLocationCoordinate2DMake(latitude, longitude)
            fromPin = MKPointAnnotation()
            fromPin.coordinate = from
            mapV.addAnnotation(fromPin)
            getRegion()
        }
    }
    
    //検索ボタン
    @IBAction func button(_ sender: Any) {
        mapV.delegate = self
        self.mapV.removeAnnotations(annotationArray)
        guard let word = textV.text else{
            return
        }
        let session = URLSession.shared
        let urlStr = "https://maps.googleapis.com/maps/api/geocode/json?address=\(word)&key=AIzaSyAiGMTOLz5Zdg7ud0Ry7ZO-CU0XR289TsQ"
        let decodedUrlStr = urlStr.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let url = URL(string: decodedUrlStr!){
            let request = URLRequest(url: url)
            let task = session.dataTask(with: request, completionHandler: self.onResponse)
            task.resume()
        }
    }
    
    func onResponse(data:Data?, response:URLResponse?, error:Error?){
        guard let data = data else {
            print("データなし")
            return
        }
        guard let jsonData = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] else {
            return
        }
        self.parseData(src: jsonData)
    }
    
    func parseData(src:[String: Any]) {
        for val in src["results"] as! [Any]{
            let results = val as! [String:Any]
            let geometry = results["geometry"] as! [String:Any]
            let location = geometry["location"] as! [String:Any]
            latitude = location["lat"] as! Double
            longitude = location["lng"] as! Double
        }
        DispatchQueue.main.async {
            //created NSURL
            let requestURL = NSURL(string: self.URL_yelp)
            //creating NSMutableURLRequest
            let request = NSMutableURLRequest(url: requestURL! as URL)
            //setting the method to post
            request.httpMethod = "POST"
            //テキストフィールドからキーと値を連結してpostパラメータを生成する
            let postParameters = "latitude="+String(self.latitude)+"&longitude="+String(self.longitude);
            //ボディをリクエストするためのパラメータを追加する
            request.httpBody = postParameters.data(using: String.Encoding.utf8)
            //投稿要求を送信するタスクを作成する
            let task =  URLSession.shared.dataTask(with: request as URLRequest, completionHandler: self.onResponse2)
                task.resume()
        }
    }
    
    func onResponse2(data:Data?, response:URLResponse?, error:Error?){
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
        self.parseData2(src: jsonData)
    }
    
    func parseData2(src:[String: Any]) {
        item = Item()
        var f = 0;
        for val in src["result"] as! [Any] {
            let result = val as! [String: Any]
            item.alias[f][0] = result["alias"] as! String
            item.phone[f][0] = result["display_phone"] as! String
            let photos = result["photos"] as! [Any]
            for i in 0...2 {
                item.photo[f][i] = photos[i] as! String
            }
            let location = result["location"] as! [String: Any]
            let address = location["display_address"] as! [Any]
            for i in 0...address.count - 1 {
            item.address[f][i] = address[i] as! String
            }
            let coordinates = result["coordinates"] as! [String: Any]
            let lat = coordinates["latitude"] as! Double
            let lng = coordinates["longitude"] as! Double
            addAnnotation(lat:lat, lng:lng, alias:item.alias[f][0])
            f += 1
        }
        
        DispatchQueue.main.async {
            self.getRegion()
            // mapViewに追加
            self.mapV.addAnnotations(self.annotationArray)
        }
    }
    
    //取得した店舗のピンを表示
    func addAnnotation(lat: CLLocationDegrees, lng: CLLocationDegrees, alias:String) {
        // ピンの生成
        let annotation = MKPointAnnotation()
        // 緯度経度を指定
        annotation.coordinate = CLLocationCoordinate2DMake(lat, lng)
        // タイトル、サブタイトルを設定
        annotation.title = alias
        annotationArray.append(annotation)
    }
    
    //アノテーションビューを返すメソッド
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //アノテーションビューを作成する。
        let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
        //吹き出しを表示可能に。
        pinView.canShowCallout = true
        let button:UIButton = UIButton(type: UIButton.ButtonType.infoLight)
        pinView.rightCalloutAccessoryView = button
        pinView.canShowCallout = true
        //右側にボタンを追加
        pinView.rightCalloutAccessoryView = button
        return pinView
    }
    
    //ボタン押下時の処理
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let title = view.annotation?.title
        for i in 0...item.alias.count - 1 {
            if title ==  item.alias[i][0] {
                num = i
                break;
            }
        }
        //ストーリーボードの名前を指定
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //viewにつけた名前を指定
        let vc = storyboard.instantiateViewController(withIdentifier: "locationDetail")
        //popoverを指定する
        vc.modalPresentationStyle = UIModalPresentationStyle.popover
        present(vc, animated: true, completion: nil)
        let popoverPresentationController = vc.popoverPresentationController
        popoverPresentationController?.sourceView = view
        popoverPresentationController?.sourceRect = view.bounds
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = "MEATPEACE"
        
        textV.layer.shadowOffset = CGSize(width: 0, height: 3)
        textV.layer.shadowColor = UIColor.black.cgColor
        textV.layer.shadowOpacity = 0.3
        textV.layer.shadowRadius = 6
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.startUpdatingLocation()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if CLLocationManager.locationServicesEnabled(){
            locationManager.stopUpdatingLocation()
        }
    }
}
