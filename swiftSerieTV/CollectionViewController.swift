//
//  CollectionViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/15/22.
//

import UIKit

struct Result : Decodable {
    var page: Int?;
    var results: [Serie]?;
    var total_pages: Int?;
    var total_results: Int?;
}


extension UIImageView {
    
    func dl(from urlString: String){
        guard let url = URL(string: urlString) else {return}
        contentMode = .scaleAspectFill
        // on va aller charger l'img, like APIî
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
class CollectionViewController: UICollectionViewController, UISearchBarDelegate{
    
    //var searchBar: UISearchBar!
    var res: Result?

    var searchBar: UISearchBar!
    //@IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var myCollection: UICollectionView!
    // let searchController = UISearchController()
    
    var tabSeries : [Serie] = [];
    
    var filteredSeries : [Serie] = [];
    
    var resSerie:[Serie]?;

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //searchBar = UIStoryboard(name: "Main", bundle: nil).value(forKey: "searchbar") as! UISearchBar
        getSeries()
        myCollection.dataSource = self
    }
    func updateView() {
        myCollection.reloadData()
    }
    
  
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredSeries = tabSeries
        }else {
            fetchSearchResult(search: searchText)
        }
        myCollection.reloadData()
    }
    
    
    func fetchSearchResult(search: String) {
        let apikey = "d3816181c54e220d8bc669bdc4503396"
        let language = "fr-FR"
        let baseUrl = "https://api.themoviedb.org/3/";
        let url = URL(string: baseUrl + "search/tv" + "?api_key="+apikey+"&language=" + language + "&query=" + search.replacingOccurrences(of: " ", with: "%20"))!
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                debugPrint("Error with fetching post: \(error)")
                return
            }else {
                debugPrint("No error")
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
                      else {
                        // \{id}
                        debugPrint("Error with the response, unexpected status code: \(String(describing: response) )")
                        debugPrint("Error with the response, unexpected status code:" + response.debugDescription)
                        return
                      }
                    // analyse des données
                      if let data = data{
                          DispatchQueue.main.async() {
                              self.res = try! JSONDecoder().decode(Result.self, from: data)
                              var res : [Serie] = []
                              for result in self.res!.results! {
                                  print(result)
                                  if result.backdrop_path != nil {
                                      res.append(Serie( backdrop_path: result.backdrop_path, first_air_date: result.first_air_date, id: result.id , genre_ids: result.genre_ids, name: result.name, origin_country: result.origin_country, original_language: result.original_language, original_name: result.original_name, overview: result.overview, popularity: result.popularity, poster_path: result.poster_path, vote_average: result.vote_average, vote_count: result.vote_count))
                                  }
                              }
                              self.filteredSeries = res
                              self.myCollection.reloadData()
                          }
                      }else{
                        print("no data")
                        return
                      }

                    }).resume()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {

                self.searchBar.showsCancelButton = true

        }

        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

                searchBar.showsCancelButton = false

                searchBar.text = ""

                searchBar.resignFirstResponder()

        //    self.filteredSeries = self.series

            myCollection.reloadData()

        }
    
     override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // obligatoire à redéfinir
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredSeries.count
    }
    
    // peupler les cellules de tables
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         print(tabSeries[indexPath.row])
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviesCell", for: indexPath) as! MyCollectionViewCell
        cell.name?.text = filteredSeries[indexPath.row].name
        cell.imageView?.dl(from: "https://image.tmdb.org/t/p/w500"+filteredSeries[indexPath.row].backdrop_path!)
        cell.mainBackground.layer.cornerRadius = 10
        cell.mainBackground.layer.masksToBounds = true
        return cell
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath as IndexPath)
        return headerView
    }*/
    
    // gérer le click sur une cellule
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         print("je suis selectionné")
        var serieView : SerieDetailsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "serieView")
        serieView.serie = filteredSeries[indexPath.row]
        // show(studentView, sender: self)
        present(serieView, animated: true, completion: nil)
        
    }
    
    override func collectionView(
      _ collectionView: UICollectionView,
      viewForSupplementaryElementOfKind kind: String,
      at indexPath: IndexPath
    ) -> UICollectionReusableView {
      switch kind {
      // 1
      case UICollectionView.elementKindSectionHeader:
        // 2
        let headerView = collectionView.dequeueReusableSupplementaryView(
          ofKind: kind,
          withReuseIdentifier: "header",
          for: indexPath)

        // 3
        guard let typedHeaderView = headerView as? MyHeader
        else { return headerView }

        // 4
          self.searchBar = typedHeaderView.searchBar
          self.searchBar.delegate = self
          return typedHeaderView
      default:
        // 5
        assert(false, "Invalid element type")
      }
    }
    
    func getSeries(){
        print("getSerie")
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
            self.resSerie = pagination.results
            DispatchQueue.main.async() {
                
                self.res = try! JSONDecoder().decode(Result.self, from: data)
                var res: [Serie] = []
                for result in self.res!.results! {
                    print(result)
                                      self.tabSeries.append(Serie(backdrop_path: result.backdrop_path, first_air_date: result.first_air_date, id: result.id, genre_ids: result.genre_ids,  name: result.name, origin_country: result.origin_country, original_language: result.original_language, original_name: result.original_name, overview: result.overview,
                                                popularity: result.popularity, poster_path: result.poster_path, vote_average: result.vote_average, vote_count: result.vote_count))
                }
                print("DispatechedQueue")
                self.filteredSeries = self.tabSeries
                self.myCollection.reloadData()
            }
        }
        task.resume()
    }
}

class MyHeader : UICollectionReusableView{
    @IBOutlet weak var searchBar: UISearchBar!
}

class MyCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var imageView: UIImageView!
}

