//
//  WCMapController.swift
//  WindCatch
//
//  Created by jaben on 2019/9/7.
//  Copyright © 2019 Jaben. All rights reserved.
//

import UIKit
import MapKit

class WCMapController: UIViewController {
    
    var typhoon: WCTyphoon?

    @IBOutlet weak var tpMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tpMapView.delegate = self
        weak var weakSelf = self
        
        if let typhoon = typhoon {
            WCHttpRequestManager.shareManager.loadTyphoonDetailWith(id: typhoon.id) { (typhoon, error) in
                if let coordinateArray = typhoon?.coordinateArray {
                    let polyLine = MKPolyline.init(coordinates: coordinateArray, count: coordinateArray.count)
                    weakSelf?.tpMapView.setRegion(MKCoordinateRegion.init(center: coordinateArray.last!, span: MKCoordinateSpan.init(latitudeDelta: 10, longitudeDelta: 10)), animated: true)
                    weakSelf?.tpMapView.addOverlay(polyLine)
                }
            }
        }
    }
}

extension WCMapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer.init(overlay: overlay)
        render.lineWidth = 2.0
        render.strokeColor = .red
        return render
    }
    
}
