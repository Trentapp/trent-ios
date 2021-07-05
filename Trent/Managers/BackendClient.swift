//
//  BackendClient.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import Foundation

class BackendClient: ObservableObject {
    static let shared = BackendClient()
    
    //    let serverPath = "http://192.168.2.101:8000/api"
    let serverPath = "http://localhost:8000/api"
    
    
    func query(keyword: String) -> [Product]{
        do {
            let queryPath = serverPath + "/products?name=" + (keyword.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
            print("Querying: \(queryPath)")
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            //            print("Server response: \(response)")
            let data = response.data(using: .utf8)!
            let products = try JSONDecoder().decode([Product].self, from: data)
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
                //                print("response: \(response)")
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
            print("id: \(id)")
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
    
    func getInventory(inventory: [String]) -> [Product]{
        var newInventory = [Product]()
        
        for productId in inventory {
            let product = self.getProduct(for: productId)
            if product != nil { newInventory.append(product!) }
        }
        
        return newInventory
    }
    
    func deleteProduct(with id: String) {
        DispatchQueue.global().async {
            let postPath = self.serverPath + "/products/product/delete/" + id
            let postURL = URL(string: postPath)!
            var request = URLRequest(url: postURL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "DELETE"
            
            print(request.description)
            
            let parameters = [
                "uid" : AuthenticationManager.shared.currentUser?.uid ?? ""
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
            } catch let error {
                print(error.localizedDescription)
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      error == nil else{
                    
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    print("HTTP response status code: \(response.statusCode)")
                    //                    print("response: \(response)")
                    print("Deleting product failed")
                    return
                }
                
                print("Deleting product succeeded")
                UserObjectManager.shared.refresh()
            }
            
            task.resume()
            
            UserObjectManager.shared.refresh()
        }
    }
    
    func getUserProfile(for id: String) -> UserProfile? {
        do {
            let queryPath = serverPath + "/users/user-profile/" + id
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            let data = response.data(using: .utf8)!
            let user = try JSONDecoder().decode(UserProfile.self, from: data)
            return user
        } catch {
            print("Error while retrieving user profile: \(error.localizedDescription)")
            return nil
        }
    }
    
    func getUserObject(for uid: String) -> UserObject? {
        do {
            let queryPath = serverPath + "/users/user/" + uid
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
    
    func createNewUser(name: String, mail: String, uid: String) {
        let user: [String : Any] = [
            "name" : name,
            "mail" : mail,
            "uid"  : uid
        ]
        
        let parameters: [String: Any] = [
            "user" : user
        ]
        
        let postPath = serverPath + "/users/create"
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
            //            return false
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else{
                //                return false
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("HTTP response status code: \(response.statusCode)")
                //                print("response: \(response)")
                //                return false
                return
            }
            
            //            return true
            UserObjectManager.shared.refresh()
        }
        
        task.resume()
    }
    
    func updateUserObject(name: String, street: String, houseNumber: String, zipcode: String, city: String, country: String, completionHandler: @escaping (Bool) -> Void) {
        var userObject: [String : Any] = [
            "uid" : AuthenticationManager.shared.currentUser?.uid ?? "",
            "name" : name
        ]
        
        if street != "" || houseNumber != "" || zipcode != "" || city != "" || country != "" {
            let address = Address(street: street, houseNumber: houseNumber, zipcode: zipcode, city: city, country: country)
            do {
                userObject["address"] = try address.asDictionary()
            } catch {
                print("Error while convertig address to dict")
            }
            
        }
        
        let parameters: [String: Any] = [
            "user" : userObject
        ]
        
        let postPath = self.serverPath + "/users/update"
        let postURL = URL(string: postPath)!
        var request = URLRequest(url: postURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "PUT"
        //        request.httpBody = parameters.percentEncoded()!
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
        } catch let error {
            print(error.localizedDescription)
            DispatchQueue.main.async {
                completionHandler(false)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else{
                DispatchQueue.main.async {
                    completionHandler(false)
                }
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("HTTP response status code: \(response.statusCode)")
                //                print("response: \(response)")
                DispatchQueue.main.async {
                    completionHandler(false)
                }
                return
            }
            
            DispatchQueue.main.async {
                completionHandler(true)
                UserObjectManager.shared.refresh()
            }
        }
        
        task.resume()
    }
    
    func deleteUserFromDB(with uid: String) {
        DispatchQueue.global().async {
            let postPath = self.serverPath + "/users/delete"
            let postURL = URL(string: postPath)!
            var request = URLRequest(url: postURL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "DELETE"
            
            let parameters = [
                "uid" : uid
            ]
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
            } catch let error {
                print(error.localizedDescription)
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      error == nil else{
                    
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    print("HTTP response status code: \(response.statusCode)")
                    //                    print("response: \(response)")
                    print("Deleting user failed")
                    return
                }
                
                print("Deleting user succeeded")
                UserObjectManager.shared.refresh()
            }
            
            task.resume()
        }
    }
    
    func addTransaction(item_id: String) {
        let postPath = self.serverPath + "/transactions/add"
        let postURL = URL(string: postPath)!
        var request = URLRequest(url: postURL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        
        let parameters = [
            "user_uid" : AuthenticationManager.shared.currentUser?.uid ?? "",
            "product_id" : item_id
        ]
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
        } catch let error {
            print(error.localizedDescription)
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let response = response as? HTTPURLResponse,
                  error == nil else{
                
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("HTTP response status code: \(response.statusCode)")
                //                print("response: \(response)")
                print("Adding transaction failed")
                return
            }
            
            
            print("Adding transaction succeeded")
            let transaction_id = String(data: data, encoding: .utf8)
            print(transaction_id)
            UserObjectManager.shared.refresh()
        }
        
        task.resume()
    }
    
    
    //    func requestTransaction(transaction_id: String){
    //        DispatchQueue.global().async {
    //            let postPath = self.serverPath + "/transactions/add"
    //            let postURL = URL(string: postPath)!
    //            var request = URLRequest(url: postURL)
    //            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    //            request.addValue("application/json", forHTTPHeaderField: "Accept")
    //            request.httpMethod = "DELETE"
    //
    //            let parameters = [
    //                "user_uid" : AuthenticationManager.shared.currentUser?.uid ?? "",
    //                "product_id" : item_id
    //            ]
    //
    //            do {
    //                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
    //            } catch let error {
    //                print(error.localizedDescription)
    //            }
    //
    //            let task = URLSession.shared.dataTask(with: request) { data, response, error in
    //                guard let data = data,
    //                      let response = response as? HTTPURLResponse,
    //                      error == nil else{
    //
    //                    return
    //                }
    //
    //                guard (200 ... 299) ~= response.statusCode else {
    //                    print("HTTP response status code: \(response.statusCode)")
    //                    print("response: \(response)")
    //                    print("Deleting user failed")
    //                    return
    //                }
    //
    //                print("Deleting user succeeded")
    //                UserObjectManager.shared.refresh()
    //            }
    //
    //            task.resume()
    //        }
    //    }
    
    // Reviews
    func getReviews(user_id: String) -> [Review]? {
        do {
            let queryPath = serverPath + "/reviews/user/" + user_id
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            let data = response.data(using: .utf8)!
            let reviews = try JSONDecoder().decode([Review].self, from: data)
            return reviews
        } catch {
            print("Error while retrieving product: \(error.localizedDescription)")
            return nil
        }
    }
    
    
    // Chats
    func getChats(completionHandler: @escaping (([Chat]) -> Void)) {
        DispatchQueue.global().async {
            //            var chats = [Chat]()
            
            let parameters: [String: Any] = [
                "uid" : AuthenticationManager.shared.currentUser?.uid ?? ""
            ]
            
            let postPath = self.serverPath + "/chats/get"
            let postURL = URL(string: postPath)!
            var request = URLRequest(url: postURL)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            request.httpMethod = "POST"
            //        request.httpBody = parameters.percentEncoded()!
            
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .withoutEscapingSlashes)
            } catch let error {
                completionHandler([])
                print(error.localizedDescription)
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      err == nil else{
                    completionHandler([])
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    completionHandler([])
                    return
                }
                
                do {
                    let chats = try JSONDecoder().decode([Chat].self, from: data)
                    completionHandler(chats)
                } catch {
                    print("Error while decoding chat response: \(error)")
                    completionHandler([])
                }
            }
            
            
            task.resume()
            
        }
        
    }
    
    func sendMessage(chat_id: String, content: String) {
        DispatchQueue.global().async {
            //            var chats = [Chat]()
            
            let parameters: [String: Any] = [
                "user_uid" : AuthenticationManager.shared.currentUser?.uid ?? "",
                "chat_id" : chat_id,
                "content" : content
            ]
            
            let postPath = self.serverPath + "/chats/sendMessage"
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
            }
            
            let task = URLSession.shared.dataTask(with: request) { data, response, err in
                guard let data = data,
                      let response = response as? HTTPURLResponse,
                      err == nil else {
                    return
                }
                
                guard (200 ... 299) ~= response.statusCode else {
                    return
                }
                
//                do {
//                    let chats = try JSONDecoder().decode([Chat].self, from: data)
//                } catch {
//                    print("Error while decoding chat response: \(error)")
//                }
            }
            
            
            task.resume()
            
        }
        
    }
    
    
    // Requests
    func getTransactionsAsLender() -> [Transaction]? {
        do {
            let queryPath = serverPath + "/transactions/findByLender/" + (UserObjectManager.shared.user?._id ?? "")
            print("Querying: \(queryPath)")
            let queryURL = URL(string: queryPath)!
            let response = try String(contentsOf: queryURL)
            let data = response.data(using: .utf8)!
            let transactions = try JSONDecoder().decode([Transaction].self, from: data)
            return transactions
        } catch {
            print("Error while retrieving user: \(error.localizedDescription)")
            return nil
        }
    }
    
}