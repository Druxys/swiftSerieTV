//
//  CollectionViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/15/22.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var tabSeries : [Serie] = [];

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabSeries.append(Serie(name: "Test"))
        self.tabSeries.append(Serie(name: "Test2"))
        self.tabSeries.append(Serie(name: "Test3"))
        self.tabSeries.append(Serie(name: "Test4"))
        self.tabSeries.append(Serie(name: "Test5"))
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
}

class MyCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var name: UILabel!
}

