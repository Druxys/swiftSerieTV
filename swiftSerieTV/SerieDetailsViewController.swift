//
//  SerieDetailsViewController.swift
//  swiftSerieTV
//
//  Created by user214994 on 3/16/22.
//

import UIKit
class Serie{
    var name : String
    init(name : String){
        self.name = name
    }
}

class SerieDetailsViewController : UIViewController{
    @IBOutlet weak var name: UILabel!
    var tabSeries : [Serie] = [];
    var serie : Serie?
    // quand la vue apparaît, après sa création
    override func viewDidLoad() {
        super.viewDidLoad();
       // name.text = serie!.name
        self.tabSeries.append(Serie(name: "Test"))
        self.tabSeries.append(Serie(name: "Test2"))
        self.tabSeries.append(Serie(name: "Test3"))
        self.tabSeries.append(Serie(name: "Test4"))
        self.tabSeries.append(Serie(name: "Test5"))
    }
}
