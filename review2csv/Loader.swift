//
//  Loader.swift
//  review2csv
//
//  Created by Steffen Matthischke on 15.07.15.
//  Copyright (c) 2015 Steffen Matthischke. All rights reserved.
//

import Foundation

struct Review {
    let title: String
    let content: String
    let version: String
    let rating: String
    let ID: String
    
    func csvLine() -> String {
        let trimmedTitle = title.stringByReplacingOccurrencesOfString("\n", withString: " ")
        let trimmedContent = content.stringByReplacingOccurrencesOfString("\n", withString: " ")

        return "\(ID);\(version);\(rating);\(trimmedTitle);\(trimmedContent)"
    }
    
}

extension Review:  Printable {
    var description: String { return csvLine() }
}

struct Loader {
    
    private let baseURL = "https://itunes.apple.com/de/rss/customerreviews/"
    private let resultsPerPage = 50
    
    func loadReviews(appID: String, maxResults: UInt = 100) -> [Review] {
        
        var reviews = [Review]()

        let maxPages:UInt = UInt(ceil(Double(maxResults) / Double(resultsPerPage)))
        
        for page in 1...maxPages {
            
            let reviewsOfPage = loadReviewsOfPage(appID, page: page)
            
            if (reviewsOfPage.count == 0)
            {
                break
            }
            
            reviews += reviewsOfPage
        }
        
        return reviews
    }
    
    // 50 per page
    private func loadReviewsOfPage(appID: String, page: UInt = 1) -> [Review] {
        
        var reviews = [Review]()

        if let url = NSURL(string: "\(baseURL)id=\(appID)/sortBy=mostRecent/page=\(page)/json") {
            
            let request = NSURLRequest(URL: url)
            var response: NSURLResponse?

            let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: nil, error: nil)
            if let json = NSJSONSerialization.JSONObjectWithData(urlData!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
                
                if let JSONReviews = json["feed"]?["entry"] as? [AnyObject] {
                    
                    for i in 1..<JSONReviews.count {
                        
                        if let review = JSONReviews[i] as? NSDictionary,
                            title = review["title"]?["label"] as? String,
                            content = review["content"]?["label"] as? String,
                            version = review["im:version"]?["label"] as? String,
                            rating = review["im:rating"]?["label"] as? String,
                            reviewID = review["id"]?["label"] as? String
                        {
                            reviews.append(Review(title: title, content: content, version: version, rating: rating, ID: reviewID))
                        }
                    }
                    
                }
            }

        }
        
        return reviews

    }
}
