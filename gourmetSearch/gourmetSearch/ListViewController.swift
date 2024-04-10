//
//  ListViewController.swift
//  gourmetSearch
//
//  Created by 永井拓志 on 2023/06/16.
//

import UIKit

class ListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableview: UITableView!
    
    var tvc = tableviewCell()
    var Items = ViewController()
    var itemclass = Item()
    
    
    override func viewDidLoad(){
        super.viewDidLoad()
        
        //tableview.dataSource = self
        //tableview.delegate = self
        
        tableview.rowHeight = 130
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        print(ViewController.items.count)
        print("テーブルビュー表示")
        //セルに表示する要素数をカウント
        return ViewController.items.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        //セルを再利用する処理
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! tableviewCell
        //cellに配置。indexPath.rowはセル番号
        cell.nameLabel.text = ViewController.items[indexPath.row].shopName
        cell.accessLabel.text = ViewController.items[indexPath.row].access
        cell.thumbnail.image = inputImage(url: ViewController.items[indexPath.row].urls!)
        return cell
    }
    
    //URLから画像データを格納
    func inputImage(url: URL)-> UIImage?{
        
        do{
            let data = try Data(contentsOf: url)
            let image = UIImage(data: data)
            
            return image
            
        }catch let err{
            print("Error: \(err.localizedDescription)")
        }
        
        
        return nil
    }
    
    //データを遷移先に渡す
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "toThird"{
            if let indexPath = tableview.indexPathForSelectedRow {
                guard let destination = segue.destination as? detailViewController else{
                    fatalError("Failed to prepare detilViewController.")
                }
                
                destination.detail = ViewController.items[indexPath.row]
            }
            
            
        }
    }
}
