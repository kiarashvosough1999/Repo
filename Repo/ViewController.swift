//
//  ViewController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/6/1400 AP.
//

import UIKit

class ViewController: UIViewController {

    var c:Router<health>? = Router<health>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        print("passed")
        c?.request(.foods) { data, resp, error in
            print("400")
            print(String(data: data!, encoding: .utf8)?.prefix(400))
            return
        }
        print("passed7")
        c?.request(.foods) { data, resp, error in
            print("500")
            print(String(data: data!, encoding: .utf8)?.prefix(500))
            return
        }
        c?.request(.foods) { data, resp, error in
            print("200")
            print(String(data: data!, encoding: .utf8)?.prefix(200))
            return
        }
        
    }


}

