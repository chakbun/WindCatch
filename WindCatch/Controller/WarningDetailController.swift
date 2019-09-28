//
//  WarningDetailController.swift
//  WindCatch
//
//  Created by jaben on 2019/9/28.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit
import MapKit

class WarningDetailController: UIViewController {

    @IBOutlet weak var provincenLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var detailMapView: MKMapView!
    
    let weather: Weather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weather = weather {
            provincenLabel.text = "\(weather.province) \(weather.city) [\(weather.name)]"
            dateLabel.text = weather.timeMsg
            infoLabel.text = weather.info
        }
    }

}
