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
    
    func postNewItem(parameters: [String : Any], completionHandler: @escaping (Bool) -> Void) {
        let postPath = serverPath + "/products/create"
        let postURL = URL(string: postPath)!
        var request = URLRequest(url: postURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
//        request.httpBody = parameters.percentEncoded()!
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
        } catch let error {
            print(error.localizedDescription)
            completionHandler(false)
        }
        
        print(request.description)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else{
                completionHandler(false)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("HTTP response status code: \(response.statusCode)")
                print("response: \(response)")
                completionHandler(false)
                return
            }
            
            completionHandler(true)
            let responseString = String(data: data, encoding: .utf8)
            print("responseString: \(responseString)")
        }
        
        task.resume()
    }
}
