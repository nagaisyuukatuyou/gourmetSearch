//
//  detailViewController.swift
//  gourmetSearch
//
//  Created by 永井拓志 on 2023/06/18.
//

import UIKit

class detailViewController: UIViewController{
    
    @IBOutlet weak var imageview: UIImageView!
    @IBOutlet weak var shopNameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    var detail:Item!
    
    override func viewDidLoad() {
        
        //サムネイル画像表示
        do{
            let data = try Data(contentsOf: detail.urll!)
            imageview.image = UIImage(data: data)
            
        }catch let err{
            print("Error: \(err.localizedDescription)")
        }
        
        shopNameLabel.text = detail.shopName
        addressLabel.text = detail.address
        openLabel.text = "営業時間\(detail.open)"
        budgetLabel.text = "予算: \(detail.budget)"
        cardLabel.text = "カード\(detail.card)"
    }
    
    
    
}
