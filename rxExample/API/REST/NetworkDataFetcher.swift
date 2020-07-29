//
//  NetworkDataFetcher.swift
//  rxExample
//
//  Created by Vladislav on 06.07.2020.
//  Copyright © 2020 VladislavNegoda. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

class NetworkDataFetcher {
    
    static let shared = NetworkDataFetcher()
    
    private let manager = Session.default
    
    typealias JSONObject = [String: Any]
    typealias JSONObjectsCollection = [[String: Any]]
    
    private init() { }
    
    func request(_ endpoint: EndPoint, method: HTTPMethod, parameters: [String: Any] = [:], encoding: ParameterEncoding = URLEncoding.default) -> Observable<JSONObject> {
        return manager.rx
            .responseJSON(method, endpoint.urlString, parameters: parameters, encoding: encoding)
            .map({ (response, json) -> JSONObject in
                if let json = json as? JSONObjectsCollection { return ["data": json] }
                return json as? JSONObject ?? [:]
            })
            .observeOn(MainScheduler.instance)
            .share(replay: 1)
        
    }
}
