//
//  SerieDetailsViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/16/22.
//

import UIKit


class SerieDetailsViewController : UIViewController{
    @IBOutlet weak var name: UILabel!
    var tabSeries : [Serie] = []
    var serie: Serie?
    var res:Serie?    // quand la vue apparaît, après sa création
    
    @IBOutlet weak var nameSerie: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        getSeries(id: serie?.id)
       // name.text = serie!.name

    }
    
    
    func getSeries(id:Int?){
        var jsonDataString: String = ""
        let idString: String = String(id ?? 0)
        print(idString)
        let url = URL(string: "https://api.themoviedb.org/3/tv/" + idString + "?api_key=d3816181c54e220d8bc669bdc4503396&language=fr-FR")!

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
                
                let detailSerie: Serie = try! JSONDecoder().decode(Serie.self, from: JsonData)
                self.res = detailSerie
                self.nameSerie.text = self.res?.name
                DispatchQueue.main.async() {
                    self.nameSerie.text = self.res?.name
                    /*self.nameSerie.append(Serie(backdrop_path: self.res?.backdrop_path, first_air_date: self.res?.first_air_date, id: self.res?.id, genre_ids: self.res?.genre_ids, name: self.res?.name, origin_country: self.res?.origin_country, original_language: self.res?.original_language, original_name: self.res?.original_name, overview: self.res?.overview, popularity: self.res?.popularity, poster_path: self.res?.poster_path, vote_average: self.res?.vote_average, vote_count: self.res?.vote_count))*/
                }
                self.nameSerie.reloadInputViews()
            }
            
    
    task.resume()
    }
    
}
