//
//  Pagination.swift
//  swiftSerieTV
//
//  Created by user214957 on 3/16/22.
//

import Foundation

class Pagination: Decodable{
    var page: Int
    var results: [Serie]
    var total_pages: Int
    var total_results: Int
    init(page: Int, results: [Serie], total_pages: Int, total_results: Int){
        self.page = page;
        self.results = results;
        self.total_pages = total_pages;
        self.total_results = total_results
    }
}
