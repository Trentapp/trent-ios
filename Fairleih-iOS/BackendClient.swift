//
//  BackendClient.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import Foundation

class BackendClient: ObservableObject {
    static let shared = BackendClient()
    
    let serverPath = "http://192.168.2.101:8000/api"
//    let serverPath = "http://localhost:8000/api"
    
    
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
            UserObjectManager.shared.refresh()
        }
        
        task.resume()
    }
    
    func getProduct(for id: String) -> Product?{
        do {
            let queryPath = serverPath + "/products/product/" + id
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            let data = response.data(using: .utf8)!
            let product = try JSONDecoder().decode(Product.self, from: data)
            return product
        } catch {
            print("Error while retrieving product: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getUserObject(for id: String) -> UserObject? {
        do {
            let queryPath = serverPath + "/users/user/" + id
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            let data = response.data(using: .utf8)!
            let user = try JSONDecoder().decode(UserObject.self, from: data)
            return user
        } catch {
            print("Error while retrieving user: \(error.localizedDescription)")
            return nil
        }
    }
}
