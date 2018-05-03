//
//  NetworkManager.swift
//  HomeDepotAssignment
//
//  Created by Swagat Mishra on 5/2/18.
//  Copyright © 2018 Swagat Mishra. All rights reserved.
//

import Foundation

class NetworkManager {
    
    var domainUrlString = "https://api.github.com/users/repos"
    var repoName: String? {
        didSet {
            self.domainUrlString = "https://api.github.com/users/" + repoName! + "/repos"
        }
    }
    private var page = 1
    private var perPage = 10
    
    let session = URLSession.shared
    
    func fetchRepos(page: Int, completion: @escaping ([Repo]?) -> Void) {
        self.page = page
        var urlComponents = URLComponents(string: domainUrlString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: "\(self.page)"),
            URLQueryItem(name: "per_page", value: "\(String(describing: perPage))")
        ]
        urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            //Process response data
            do {
            var responseData = String(data: data!, encoding: String.Encoding.utf8)
            responseData = responseData?.replacingOccurrences(of: "\n", with: "\\n")
            let newData = responseData?.data(using: String.Encoding.utf8)
            
            print(response?.description ?? "no response")
                let repos = try JSONDecoder().decode([Repo].self, from: newData!)
                completion(repos)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
}
