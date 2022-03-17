//
//  SerieDetailsViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/16/22.
//

import UIKit

extension UIImageView {

    func dl(from urlString: String){
        guard let url = URL(string: urlString) else {return}
        contentMode = .scaleAspectFill
        // on va aller charger l'img, like API
        URLSession.shared.dataTask(with: url) { data, response, error in
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                        let data = data, error == nil,
                        let image = UIImage(data: data)
                        else { return }
                    DispatchQueue.main.async() {
                        self.image = image
                    }
                }.resume()
    }
}

class SerieDetailsViewController : UIViewController{
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var overview: UILabel!
    @IBOutlet weak var popularity: UILabel!
    @IBOutlet weak var imgSerie: UIImageView!
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var overviewText: UITextView!
    @IBOutlet weak var voteCountView: UILabel!
    var tabSeries : [Serie] = []
    var serie: Serie?
    var res:Serie?    // quand la vue apparaît, après sa création
    
    @IBOutlet weak var nameSerie: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        getSeries(id: serie?.id)
        overviewText.isEditable = false
       // name.text = serie!.name

    }
    
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
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
            
                
                DispatchQueue.main.async() {
                    let detailSerie: Serie = try! JSONDecoder().decode(Serie.self, from: JsonData)
                    self.res = detailSerie;                    self.nameSerie.text = self.res?.name
                    if(self.res?.overview == ""){
                        self.overviewText.text = "Pas de description"
                    }else{
                        self.overviewText.text = self.res?.overview
                    }
                    print(self.res!.backdrop_path)
                    if(self.res!.vote_count == 0){
                        let count: String = String(format: "%f", self.res!.vote_count ?? "Inconnue")
                        self.voteCountView.text = "Nombre de votants : Inconnue"                    }else{
                            let count: String = String(format: "%f", self.res!.vote_count ?? "Inconnue")
                            self.voteCountView.text = "Nombre de votants : " + count                        }
                    let pop: String = String(format: "%f", self.res!.vote_average ?? "Inconnue")
                    if(self.res!.vote_average == 0){
                        self.popularity.text = "Note inconnue"
                    }else{
                        self.popularity.text = "Note : " + pop
                    }
                    
                    
                    
                    self.imgSerie.dl(from: "https://image.tmdb.org/t/p/w500" + self.res!.backdrop_path!)
                    self.imgPoster.dl(from: "https://image.tmdb.org/t/p/w500" + self.res!.poster_path!)
                    /*self.nameSerie.append(Serie(backdrop_path: self.res?.backdrop_path, first_air_date: self.res?.first_air_date, id: self.res?.id, genre_ids: self.res?.genre_ids, name: self.res?.name, origin_country: self.res?.origin_country, original_language: self.res?.original_language, original_name: self.res?.original_name, overview: self.res?.overview, popularity: self.res?.popularity, poster_path: self.res?.poster_path, vote_average: self.res?.vote_average, vote_count: self.res?.vote_count))*/
                }
                self.nameSerie.reloadInputViews()
            }
            
    
    task.resume()
    }
    
}
