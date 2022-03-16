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
    var serie : Serie?
    // quand la vue apparaît, après sa création
    override func viewDidLoad() {
        super.viewDidLoad();
       // name.text = serie!.name

    }
}
