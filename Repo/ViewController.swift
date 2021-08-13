//
//  ViewController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/6/1400 AP.
//

import UIKit

class ViewController: UIViewController {
    
    @OpenSession(2) var sessionController = SessionController<health>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let builder = URLHTTPRequestBuilder<health>()
        print("here")
        do {
            let x = try sessionController.downloadTask(with: .act, completionHandler: { url, _, _ in
                print(url)
            }).changeOperationConfig({
                $0.identifierGenerator = { .download }
            }).await(after: 0)
            
            let x6 = try sessionController.dataTask(with: .foods,
                                                    requestBuilder: builder,
                                                    completionHandler: { data,_,_ in
                                                        print(100)
                                                        print(String(data: data!, encoding: .utf8)?.prefix(100))
                                                        do {
                                                            try x.suspend(after: 5)
                                                        }catch {
                                                            print(error)
                                                        }
                                                    }).await(after: 0)
            
            let x8 = try sessionController.dataTask(with: .foods,
                                                    requestBuilder: builder,
                                                    completionHandler: {data,_,_ in
                                                        print(200)
                                                        print(String(data: data!, encoding: .utf8)?.prefix(200))
                                                        do {
                                                            try x.await(after: 13)
                                                        }catch {
                                                            print(error)
                                                        }
                                                    })
                .await(after: 0)
            
        }catch {
            print(error)
        }
        
    }
    
    
}

