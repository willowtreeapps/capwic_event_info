//
//  FirebaseClient.swift
//  rubegoldbergmachine
//
//  Created by WillowTree Inc. on 3/7/19.
//
// This file is complete (there are no TODOs). It is a utility
// that will help you read and write data from/to Firebase.

import Foundation

class FirebaseClient: NSObject {
    let baseUrl = "https://capwic-jmu-2019.firebaseio.com/capwic-jmu-2019/teamdata"
    let session: URLSession
    
    enum FirebaseClientError: Error {
        case decodeError(err: Error?)
        case encodeError(err: Error?)
        case httpError(status: Int)
        case networkError(err: Error)
        case noDataError
    }
    
    override init() {
        self.session = URLSession(configuration: .ephemeral)
        super.init()
    }
    
    // Use this method to get the contents of a file in firebase (to see if we've been triggered)
    func get(doc: String, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(doc)") else {
            return
        }
        
        self.session.dataTask(with: url) { (data, response, err) in
            // check error
            if let err = err {
                completion(nil, FirebaseClientError.networkError(err: err))
                return
            }
            
            // check response code
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(nil, FirebaseClientError.httpError(status: httpResponse.statusCode))
                return
            }
            
            guard let data = data else {
                completion(nil, FirebaseClientError.noDataError)
                return
            }
            
            do {
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dict = jsonObject as? [String: Any] {
                    completion(dict, nil)
                } else {
                    completion(nil, FirebaseClientError.decodeError(err: nil))
                }
            } catch {
                completion(nil, FirebaseClientError.decodeError(err: error))
                return
            }
        }.resume()
    }
    
    // Use this method to write a file to firebase (to trigger the next team in line)
    func send(doc: String, data: [String: Any], completion: @escaping (Error?) -> Void) {
        guard let url = URL(string: "\(baseUrl)/\(doc)") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: data, options: .sortedKeys)
        } catch {
            completion(FirebaseClientError.encodeError(err: error))
            return
        }
        
        
        self.session.dataTask(with: request) { (_, resp, err) in
            // check error
            if let err = err {
                completion(FirebaseClientError.networkError(err: err))
                return
            }
            
            // check response code
            if let httpResponse = resp as? HTTPURLResponse, httpResponse.statusCode != 200 {
                completion(FirebaseClientError.httpError(status: httpResponse.statusCode))
                return
            }
            
            // success!
            completion(nil)
        }.resume()
    }
}
