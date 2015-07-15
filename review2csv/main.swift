//
//  main.swift
//  review2csv
//
//  Created by Steffen Matthischke on 15.07.15.
//  Copyright (c) 2015 Steffen Matthischke. All rights reserved.
//

import Foundation

let args = Process.arguments

if (args.count != 3) {
    println("usage: review2csv <app ID> <max results>")
    exit(1)
}

if let maxPages = args[2].toInt() {

    let appID = args[1]

    let reviews = Loader().loadReviews(appID, maxResults: UInt(maxPages))
    
    for review in reviews {
        println(review)
    }
}
