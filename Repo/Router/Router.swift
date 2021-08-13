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

extension health: EndPointHTTPType, EndPointDownloadType {
    
    var apiVersion: APIVersion {
        .none
    }
    
    
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
        URL(string: "https://dl6.downloadha.com/hosein/animation/June2021/Rick.and.Morty.S05/720p.x265/Rick.and.Morty.S05E01.Mort.Dinner.Rick.Andre.720p.WEBRip.2CH.x265.HEVC-PSA_Downloadha.com_.mkv")!
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
            
            let x6 = try sessionController.dataTask(with: route,
                                                   requestBuilder: builder,
                                                   completionHandler: completion).await(after: 0)
            
            let x8 = try sessionController.dataTask(with: route,
                                                   requestBuilder: builder,
                                                   completionHandler: completion).await(after: 0)
        } catch  {
            print(error)
        }
        return
    }
    
    
}
