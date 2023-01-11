//
//  ViewController.swift
//  socketDemo
//
//  Created by Samet Ronaer on 9.01.2023.
//

import UIKit
import SocketIO

class ViewController: UIViewController {

    @IBOutlet weak var priceLabel : UILabel!
    
    @IBAction func  tapped(sender:Any){
        print("Tapped")
        SocketService.shared.emit(emitterName: "ios", params: ["Emit":"ios"])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //sendRequest()
        SocketService.shared.connectSocket { (success) in
            print("Connect successfully!!!")
            SocketService.shared.listen("StockChange") { data in
           
                print(data)
                let listData : [Any] = data as! [Any]
                let stockElement = listData.first  as! Dictionary<String, AnyObject>
                print(stockElement["price"]!)
                self.priceLabel.text =  "\(stockElement["price"]!)"
            }
            SocketService.shared.listen("stockCount") { data in
           
                print(data)
             
            }
        }
        // Do any additional setup after loading the view.
    }


   
   

    

}

