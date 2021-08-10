//
//  Router.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/9/1400 AP.
//

import Foundation

enum health {
    case foods
    case act
}

extension health: EndPointHTTPType {
    
    var task: HTTPTask {
        .request
    }
    
    var headers: HTTPHeaders? {
        nil
    }
    
    var baseURL: URL {
        URL(string: "https://api.healthclub.center/")!
    }
    
    var path: String {
        "v2/food"
    }
    
    var httpMethod: Method {
        .get
    }
    
    var url: URL {
        URL(string: "")!
    }
    
}

struct b:Decodable {
}

class Router<EndPoint:EndPointHTTPType>: NetworkRouter  {
    
    typealias EndPoint = EndPoint
    
    @WebSocketSession(identifier: .simple) var sessionController = SessionController<EndPoint>()
    
    func request(_ route: EndPoint,
                 completion: @escaping NetworkRouterCompletion) {
        let builder = URLHTTPRequestBuilder<EndPoint>()
        
        do {
            let x = try sessionController.startDataTask(with: route,
                                                        requestBuilder: builder,
                                                        completionHandler: completion).await()
        } catch  {
            print(error)
        }
        return
    }
    
    
}
