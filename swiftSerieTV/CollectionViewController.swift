//
//  CollectionViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/15/22.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var tabSeries : [Serie] = [];
    var res:[Serie]?;

    override func viewDidLoad() {
        super.viewDidLoad()
        getSeries()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // obligatoire à redéfinir
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tabSeries.count
    }

    // peupler les cellules de tables
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! MyCollectionViewCell
        cell.name?.text = tabSeries[indexPath.row].name
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath)
            return headerView
        }
    
    // gérer le click sur une cellule
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var serieView : SerieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "serieView")
        serieView.serie = tabSeries[indexPath.row]
       // show(studentView, sender: self)
        present(serieView, animated: false, completion: nil)
        
    }
    
    func getSeries(){
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
                self.res = pagination.results
                DispatchQueue.main.async() {
                                              for result in self.res! {
                                                  self.tabSeries.append(Serie(backdrop_path: result.backdrop_path, first_air_date: result.first_air_date, id: result.id, genre_ids: result.genre_ids,  name: result.name, origin_country: result.origin_country, original_language: result.original_language, original_name: result.original_name, overview: result.overview,
                                                popularity: result.popularity, poster_path: result.poster_path, vote_average: result.vote_average, vote_count: result.vote_count))
                                              }
                                              self.collectionView.reloadData();
                                          }
                }
    
    task.resume()
    }
}


class MyCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var name: UILabel!
}

