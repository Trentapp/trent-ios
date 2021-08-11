//
//  BackendClient.swift
//  Fairleih-iOS
//
//  Created by Fynn Kiwitt on 11.05.21.
//

import Foundation
import MapKit
import Alamofire

class BackendClient: ObservableObject {
    static let shared = BackendClient()
    
    let serverPath = serverBaseURL + "/api"
    
    // Overview: Backendclient
    //
    // I.   Products
    // II.  User
    // III. Transactions
    // IV.  Chats
    // V.   Reviews
    // VI.  Payment
    
    
    // I.   Products
    //
    // I.1  query
    // I.2  postNewItem
    // I.3  getProduct
    // I.4  deleteProduct
    
    func query(keyword: String, location: CLLocationCoordinate2D, maxDistance: Int, completionHandler: @escaping ([Product]?, Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/products"
            let parameters : [String: Any] = [
                "name" : keyword,
                "lat" : location.latitude,
                "lng" : location.longitude,
                "maxDistance" : maxDistance
            ]
            
            AF.request(url, parameters: parameters)
                .validate()
                .responseData { response in
                    DispatchQueue.main.async {
                        if response.data == nil {
                            completionHandler(nil, false)
                            return
                        }
                        
                        do {
                            let products = try JSONDecoder().decode([Product].self, from: response.data!)
                            completionHandler(products, response.error == nil)
                        } catch {
                            print("Error while retrieving products")
                            
                            completionHandler(nil, false)
                            
                        }
                    }
                }
        }
    }
    
    func postNewItem(parameters: [String : Any], photos: [UIImage] = [], completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            
            let body: [String : Any] = [
                "product" : parameters,
                "uid" : uid
            ]
            
            let bodyData = ((try? JSONSerialization.data(withJSONObject: body, options: [])) ?? Data())
            
            var photosData: [Data] = []
            
            for photo in photos {
                let photoData = photo.jpegData(compressionQuality: 0)
                if photoData == nil { continue }
                photosData.append(photoData!)
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                for photo in photosData {
                    multipartFormData.append(photo, withName: "image", fileName: "image")
                }
                
                multipartFormData.append(bodyData, withName: "product", fileName: "product")
            }, to: serverBaseURL + "/api/products/create")
            .validate()
            .response { dataResponse in
                DispatchQueue.main.async {
                    completionHandler(dataResponse.error == nil)
                    UserObjectManager.shared.refresh()
                }
            }
        }
    }
    
    func getProduct(for id: String, completionHandler: @escaping (Product?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/products/product/" + id
            
            AF.request(url)
                .validate()
                .responseData { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let product = try JSONDecoder().decode(Product.self, from: response.data!)
                            completionHandler(product)
                        } catch {
                            completionHandler(nil)
                            print("Error while retrieving product")
                        }
                    }
                }
        }
    }
    
    //    func getInventory(inventory: [String]) -> [Product]{
    //        var newInventory = [Product]()
    //
    //        for productId in inventory {
    //            let product = self.getProduct(for: productId)
    //            if product != nil { newInventory.append(product!) }
    //        }
    //
    //        return newInventory
    //    }
    
    func deleteProduct(with id: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/products/products/delete/" + id
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = ["uid" : uid]
            
            AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    
    
    
    // II.  User
    //
    // II.1 getUserProfile
    // II.2 getUserObject
    // II.3 createNewUser
    // II.4 uploadNewProfilePicture
    // II.5 updateUserObject
    // II.6 deleteUserFromDB
    // II.7 addAPNToken
    
    func getUserProfile(for id: String, completionHandler: @escaping (UserProfile?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/user-profile/" + id
            
            AF.request(url)
                .validate()
                .responseData { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let profile = try JSONDecoder().decode(UserProfile.self, from: response.data!)
                            
                            completionHandler(profile)
                        } catch {
                            print("Error while retrieving user profile")
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func getUserObject(completionHandler: @escaping (UserObject?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/user"
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = ["uid" : uid]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseData { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let user = try JSONDecoder().decode(UserObject.self, from: response.data!)
                            
                            completionHandler(user)
                        } catch {
                            print("Error while retrieving user profile")
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func createNewUser(firstName: String, lastName: String,mail: String, uid: String, completionHandler: @escaping (UserObject?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/create"
            
            let user: [String : Any] = [
                "firstName" : firstName,
                "lastName" : lastName,
                "mail" : mail,
                "uid"  : uid
            ]
            
            let parameters: [String: Any] = [
                "user" : user
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .responseData { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let user = try JSONDecoder().decode(UserObject.self, from: response.data!)
                            
                            completionHandler(user)
                        } catch {
                            print("Error while retrieving user profile")
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func uploadNewProfilePicture(photo: UIImage, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            
            let body: [String : Any] = [
                "uid" : uid
            ]
            
            let bodyData = ((try? JSONSerialization.data(withJSONObject: body, options: [])) ?? Data())
            guard let photoData = photo.jpegData(compressionQuality: 0) else {
                completionHandler(false)
                return
            }
            
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(photoData, withName: "image", fileName: "image")
                multipartFormData.append(bodyData, withName: "parameters", fileName: "parameters")
            }, to: serverBaseURL + "/api/users/uploadPicture")
            .validate()
            .response { dataResponse in
                DispatchQueue.main.async {
                    completionHandler(dataResponse.error == nil)
                    UserObjectManager.shared.refresh()
                }
            }
        }
    }
    
    func deleteProfilePicture(completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/deleteProfilePicture"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [ "uid" : uid ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        UserObjectManager.shared.refresh()
                        completionHandler(response.error != nil)
                    }
                }
        }
    }
    
    func updateUserObject(firstName: String, lastName: String, streetWithNr: String, zipcode: String, city: String, country: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/update"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            var userObject: [String : Any] = [
                "uid" : uid,
                "firstName" : firstName,
                "lastName" : lastName
            ]
            
            if streetWithNr != "" || zipcode != "" || city != "" || country != "" {
                let address = Address(streetWithNr: streetWithNr, zipcode: zipcode, city: city, country: country)
                do {
                    userObject["address"] = try address.asDictionary()
                } catch {
                    print("Error while convertig address to dict")
                }
                
            }
            
            let parameters: [String: Any] = [
                "user" : userObject
            ]
            
            AF.request(url, method: .put, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        UserObjectManager.shared.refresh()
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func deleteUserFromDB(completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/delete"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = ["uid": uid]
            
            AF.request(url, method: .delete, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        UserObjectManager.shared.refresh()
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func addAPNToken(token: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/users/addAPNToken"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters: [String : Any] = [
                "uid" : uid,
                "token" : token
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    
    
    // III.     Transactions
    //
    // III.1    addTransaction
    // III.2    getTransactionsAsLender
    // III.3    setTransactionStatus
    // III.4    getTransactions
    // III.5    getTransaction
    // III.6    getPastTransactions
    
    func addTransaction(item_id: String, startDate: Date, endDate: Date, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/transactions/createTransaction"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid,
                "productId" : item_id,
                "startDate" : startDate.iso8601,
                "endDate" : endDate.iso8601
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                        UserObjectManager.shared.refresh()
                    }
                }
        }
    }
    
    func getTransactionsAsLender(completionHandler: @escaping ([Transaction]?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/transactions/findByLender"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let transactions = try JSONDecoder().decode([Transaction].self, from: response.data!)
                            completionHandler(transactions)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func setTransactionStatus(transactionId: String, transactionStatus: Int, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/transactions/setTransactionStatus/" + transactionId
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters : [ String : Any ] = [
                "uid" : uid,
                "status" : transactionStatus
            ]
            
            AF.request(url, method: .patch, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error != nil)
                    }
                }
        }
    }
    
    func getTransactions(completionHandler: @escaping ([Transaction]?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/transactions/all"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let transactions = try JSONDecoder().decode([Transaction].self, from: response.data!)
                            completionHandler(transactions)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func getTransaction(transactionId: String, completionHandler: @escaping (Transaction?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/transactions/transaction/" + transactionId
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let transaction = try JSONDecoder().decode(Transaction.self, from: response.data!)
                            completionHandler(transaction)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func getPastTransactions(completionHandler: @escaping ([Transaction]?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/transactions/findPastTransactions"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let transactions = try JSONDecoder().decode([Transaction].self, from: response.data!)
                            completionHandler(transactions)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    
    
    // IV.     Reviews
    //
    // IV.1     getReviews
    func getReviews(user_id: String, completionHandler: @escaping ([Review]?) -> Void){
        DispatchQueue.global().async {
            let url = self.serverPath + "/reviews/user" + user_id
            
            AF.request(url)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        if response.data == nil {
                            completionHandler(nil)
                            return
                        }
                        do {
                            let reviews = try JSONDecoder().decode([Review].self, from: response.data!)
                            completionHandler(reviews)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }    }
    
    
    // V.     Chats
    //
    // V.1    getChats
    // V.2    sendMessage
    // V.3    getChat
    func getChats(completionHandler: @escaping ([Chat]?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/chats/getChatsOfUser"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = ["uid" : uid]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let chats = try JSONDecoder().decode([Chat].self, from: response.data!)
                            completionHandler(chats)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    func sendMessage(chat_id: String, content: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/chats/sendMessage"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid,
                "chatId" : chat_id,
                "content" : content
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func sendMessage(product_id: String, content: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/chats/sendMessage"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = [
                "uid" : uid,
                "productId" : product_id,
                "content" : content
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func getChat(chatId: String, completionHandler: @escaping (Chat?) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/chats/chat/" + chatId
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters = ["uid" : uid]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        do {
                            if response.data == nil {
                                completionHandler(nil)
                                return
                            }
                            let chat = try JSONDecoder().decode(Chat.self, from: response.data!)
                            completionHandler(chat)
                        } catch {
                            completionHandler(nil)
                        }
                    }
                }
        }
    }
    
    
    // VI.      Payment
    //
    // VI.1     createMangopayUser
    // VI.2     createCardRegistration
    // VI.3     updateCardRegistration
    // VI.4     payIn
    
    func createMangopayUser(birthday: Int, nationality: String, countryOfResidence: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/payment/createMangopayUser"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters : [String : Any] = [
                "uid" : uid,
                "birthday" : birthday,
                "nationality" : nationality,
                "countryOfResidence":countryOfResidence
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func createCardRegistration(completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/payment/createCardRegistration"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters : [String : Any] = [
                "uid" : uid
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func updateCardRegistration(registrationData: String, registrationId: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/payment/updateCardRegistration"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters : [String : Any] = [
                "uid" : uid,
                "registrationData": registrationData,
                "registrationId":registrationId
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
    
    func payIn(transactionId: String, cardId: String, completionHandler: @escaping (Bool) -> Void) {
        DispatchQueue.global().async {
            let url = self.serverPath + "/payment/payIn"
            
            let uid = FirebaseAuthClient.shared.currentUser?.uid ?? ""
            let parameters : [String : Any] = [
                "uid" : uid,
                "transactionId": transactionId,
                "cardId":cardId
            ]
            
            AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
                .validate()
                .response { response in
                    DispatchQueue.main.async {
                        completionHandler(response.error == nil)
                    }
                }
        }
    }
}
