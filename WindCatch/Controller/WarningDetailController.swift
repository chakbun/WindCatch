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
    
    var weather: Weather? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let weather = weather {
            provincenLabel.text = "\(weather.province) \(weather.city) [\(weather.name)]"
            dateLabel.text = weather.timeMsg
            infoLabel.text = weather.info
            
            let center = CLLocationCoordinate2DMake(weather.latitude, weather.longitude)
            detailMapView.setRegion(MKCoordinateRegion.init(center: center, span: MKCoordinateSpan.init(latitudeDelta: 5, longitudeDelta: 5)), animated: true)

            if weather.latitude != -999.0 && weather.longitude != -999.0 {
                let annotation = WCPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2DMake(weather.latitude, weather.longitude)
                annotation.title = weather.city
                detailMapView.addAnnotation(annotation)
            }
        }
    }

}
