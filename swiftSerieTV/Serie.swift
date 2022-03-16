//
//  Serie.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/16/22.
//

import Foundation
class Serie: Decodable{
    var backdrop_path : String?
    var first_air_date : String?
    var id : Int?
    var genre_ids : [Int]?
    var name : String?
    var origin_country : [String]?
    var original_language : String?
    var original_name : String?
    var overview : String?
    var popularity : Double?
    var poster_path : String?
    var vote_average: Double?
    var vote_count: Int?
    init(backdrop_path: String?, first_air_date: String?, id: Int?, genre_ids: [Int]?, name: String?, origin_country: [String]?, original_language: String?, original_name: String?, overview: String?, popularity: Double?, poster_path: String?, vote_average: Double?, vote_count: Int?){
        self.backdrop_path = backdrop_path; self.first_air_date = first_air_date; self.id = id; self.genre_ids = genre_ids; self.name = name; self.origin_country = origin_country; self.original_language = original_language; self.original_name = original_name; self.overview = overview; self.popularity = popularity; self.poster_path = poster_path; self.vote_average = vote_average; self.vote_count = vote_count
        
        
    }
}
