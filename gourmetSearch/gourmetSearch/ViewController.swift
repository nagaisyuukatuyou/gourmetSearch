//
//  ViewController.swift
//  gourmetSearch
//
//  Created by 永井拓志 on 2023/06/16.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, XMLParserDelegate, UISearchBarDelegate  {
    
    
    
    //@IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var locationSwitch: UISwitch!
    
    var parser:XMLParser!
    static var items = [Item]()
    var item:Item?
    var currentString = ""
    var tableview = UITableView()
    var nameCounter = 0
    var scounter = 0
    var distance = "3"
    var budget = ""
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        //searchBar.delegate = self //serchbarのプロパティにこのクラスを代入
    }
    
    //検索
    @IBAction func getCurrentLocationTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func locationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            locationManager.requestLocation()
        }else{
            ViewController.items = []
            tableview.reloadData()
        }
    }
    //周辺距離指定
    @IBAction func distanceChange(_ sender: UISlider) {
        
        distanceLabel.text! = "現在地からの距離: "
        
        
        if  sender.value <= 0.2 {
            self.distance = "1"
            distanceLabel.text! += "300"
        }else if sender.value <= 0.4 && sender.value > 0.2{
            self.distance = "2"
            distanceLabel.text! += "500"
            
        }else if sender.value <= 0.6 && sender.value > 0.4{
            self.distance = "3"
            distanceLabel.text! += "1000"
            
        }else if sender.value <= 0.8 && sender.value > 0.6{
            self.distance = "4"
            distanceLabel.text! += "2000"
            
        }else if sender.value <= 1.0 && sender.value > 0.8{
            self.distance = "5"
            distanceLabel.text! += "3000"
            
        }
        
    }
    
    
    @IBAction func budgetSlider(_ sender: UISlider) {
        
        budgetLabel.text! = "予算: "
        let budget = sender.value
        
        if budget == 0 {
            budgetLabel.text! += "指定なし"
            self.budget = ""
        }else if budget <= 0.1 && budget > 0 {
            budgetLabel.text! += "〜1000"
            self.budget = "B009,B010"
        }else if budget <= 0.2 && budget > 0.1 {
            budgetLabel.text! += "1001〜1500"
            self.budget = "B011"
        }else if budget <= 0.3 && budget > 0.2 {
            budgetLabel.text! += "1501〜2000"
            self.budget = "B001"
        }else if budget <= 0.4 && budget > 0.3 {
            budgetLabel.text! += "2001〜3000"
            self.budget = "B002"
        }else if budget <= 0.5 && budget > 0.4 {
            budgetLabel.text! += "3001〜4000"
            self.budget = "B003"
        }else if budget <= 0.6 && budget > 0.5 {
            budgetLabel.text! += "4001〜5000"
            self.budget = "B008"
        }else if budget <= 0.7 && budget > 0.6{
            budgetLabel.text! += "5001〜7000"
            self.budget = "B004"
        }else if budget <= 0.8 && budget > 0.7{
            budgetLabel.text! += "7001〜10000"
            self.budget = "B005"
        }else if budget <= 0.85 && budget > 0.8{
            budgetLabel.text! += "10001〜15000"
            self.budget = "B006"
        }else if budget <= 0.9 && budget > 0.85{
            budgetLabel.text! += "15001〜20000"
            self.budget = "B012"
        }else if budget <= 0.95 && budget > 0.9{
            budgetLabel.text! += "20001〜30000"
            self.budget = "B013"
        }else if budget <= 1.0 && budget > 0.95{
            budgetLabel.text! += "30001〜"
            self.budget = "B014"
          
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                guard let loc = locations.last else { return }
                
                CLGeocoder().reverseGeocodeLocation(loc, completionHandler: {(placemarks, error) in
                    
                    if let error = error {
                        print("reverseGeocodeLocation Failed: \(error.localizedDescription)")
                        return
                    }
                    
                    
                    if (placemarks?[0]) != nil { //nilで現在地取得できたかの確認？
                        
                       
                        //URL先に接続
                        let url = URL(string: "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=b249812cdc3048a2&lat=\(loc.coordinate.latitude)&lng=\(loc.coordinate.longitude)&range=\(self.distance)&budget=\(self.budget)&count=100")!
                      
                       
                            let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response, error) in
                                
                                let parser: XMLParser? = XMLParser(data: data!)
                                parser!.delegate = self
                                parser!.parse() //データ解析
                            })
                            
                            task.resume()
                        
                        
                    }
                })
        }
            
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
                print("error: \(error.localizedDescription)")
        }

        //要素名の開始タグが見つかるごとに実行される
        func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributesDict: [String : String]){
            print("\(self.distance)\(self.budget)")
            self.currentString = ""
            if elementName == "shop"{
                self.item = Item()
                nameCounter = 0
                scounter = 0
            }
        }
        
        //内容を取り出す処理
        func parser(_ parser: XMLParser, foundCharacters string: String){
            self.currentString += string
        }
        
        //終了タグが見つかり、内容を格納していく処理
        func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
            
            switch elementName{
            case "name": if nameCounter == 0{
                self.item?.shopName = currentString
                nameCounter += 1
            }else{
                break
            }
            case "access": self.item?.access = currentString
                
            case "s": if scounter == 0 {
                scounter += 1
            }else{
                self.item?.urls = URL(string: currentString)
            }
            case "l":if scounter == 1 {
                self.item?.urll = URL(string: currentString)
            }
            case "address": self.item?.address = currentString
            case "open": self.item?.open = currentString
            case "budget": self.item?.budget = currentString
            case "card": self.item?.card = currentString
            case "shop": ViewController.items.append(self.item!)
               
            default : break
            }
        }
        
        //データ解析が終わったときに呼び出される処理
        func parserDidEndDocument(_ parser: XMLParser){
            print(ViewController.items.count)
            print("解析終了")
            
            //self.performSegue(withIdentifier: "toSecond", sender: self)
            
            
        }
            
        
        //searchbarで検索したときに実行
        /*func searchBarSearchButtonClicked(_ search: UISearchBar){
            //キーボードを閉じる
            view.endEditing(true)
            
            
            
            if searchbar.text != nil{
                
                let url = URL(string: "http://webservice.recruit.co.jp/hotpepper/gourmet/v1/?key=b249812cdc3048a2&keyword=\(self.searchbar.text)")!
              
               
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data,response, error) in
                        
                        let parser: XMLParser? = XMLParser(data: data!)
                        parser!.delegate = self
                        parser!.parse() //データ解析
                    })
                    
                    task.resume()
                
                //画面遷移
                self.performSegue(withIdentifier: "toSecond", sender: self)
            }
         
        }*/

    

}

