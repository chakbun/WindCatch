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
        tpMapView.showsScale = true;
        weak var weakSelf = self
        
        if let typhoon = typhoon {
            WCHttpRequestManager.shareManager.loadTyphoonDetailWith(id: typhoon.id) { (typhoon, error) in
                if let coordinateArray = typhoon?.coordinateArray {
                    let polyLine = MKPolyline.init(coordinates: coordinateArray, count: coordinateArray.count)
                    weakSelf?.tpMapView.setRegion(MKCoordinateRegion.init(center: coordinateArray.last!, span: MKCoordinateSpan.init(latitudeDelta: 10, longitudeDelta: 10)), animated: true)
                    weakSelf?.tpMapView.addOverlay(polyLine)
                }
                if let details = typhoon?.details {
                    for detail in details {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(detail.latitude, detail.longitude)
                        annotation.title = detail.time
                        weakSelf?.tpMapView .addAnnotation(annotation)
                    }
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
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else {
            return nil
        }
        let identifier = "Annotation"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView!.canShowCallout = true
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }
    
}
