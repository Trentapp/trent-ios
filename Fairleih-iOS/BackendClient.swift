//
//  BackendClient.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import Foundation

class BackendClient: ObservableObject {
    static let shared = BackendClient()
    
    let serverPath = "http://localhost:8000/api"
    
    
    func query(keyword: String) -> [Product]{
        do {
            let queryPath = serverPath + "/products?name=" + (keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
            print("Querying: \(queryPath)")
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            print("Server response: \(response)")
            let data = response.data(using: .utf8)!
            let products = try JSONDecoder().decode([Product].self, from: data)
            print(products)
            return products
        } catch {
            print("Error while retrieving status: \(error.localizedDescription)")
            return []
        }
    }
    
//    func checkStatus(){
//        do {
//            let response = try String(contentsOf: server_url)//.appendingPathComponent("status"))
//            status = response
//            print("Server response: \(response)")
//        } catch {
//            print("Error while retrieving status")
//        }
//    }
}
