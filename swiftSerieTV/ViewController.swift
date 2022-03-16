//
//  ViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/15/22.
//

import UIKit

class SerieViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var jsonDataString: String = ""
        let url = URL(string: "https://api.themoviedb.org/3/tv/airing_today?api_key=d3816181c54e220d8bc669bdc4503396&language=fr-FR")!

            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    error == nil,
                    let data = data,
                    let jsonDataToString = String(data: data, encoding: .utf8)
                else {
                    print(error ?? "Unknown error")
                    return
                }

                /*print(jsonDataToString)
                print(data)*/
                jsonDataString = jsonDataToString
                
                let JsonData = jsonDataString.data(using: .utf8)!
                
                let pagination: Pagination = try! JSONDecoder().decode(Pagination.self, from: JsonData)
                let result:[Serie] = pagination.results
                for i in result{
                    print(i.name)
                }
            }
            task.resume()
    }
    
    
    struct Pagination: Decodable{
        var page: Int
        var results: [Serie]
        var total_pages: Int
        var total_results: Int
    }
    
    struct Serie: Decodable {
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
        var vote_count: Int?    }

}
