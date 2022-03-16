//
//  SerieDetailsViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/16/22.
//

import UIKit


class SerieDetailsViewController : UIViewController{
    @IBOutlet weak var name: UILabel!
    var tabSeries : [Serie] = [];
    var res: Serie?
    var serie : Serie?
    // quand la vue apparaît, après sa création
    override func viewDidLoad() {
        super.viewDidLoad();
       // name.text = serie!.name

    }
    
    
    func getSeries(id:Int){
        var jsonDataString: String = ""
        var idString: String = String(id)
        let url = URL(string: "https://api.themoviedb.org/3/tv/" + idString)!

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
                DispatchQueue.main.async() {
                                              
                                              self.collectionView.reloadData();
                                          }
                }
    
    task.resume()
    }}
