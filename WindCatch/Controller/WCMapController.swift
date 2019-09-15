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

    @IBOutlet weak var introTextView: UITextView!
    @IBOutlet weak var tpMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tpMapView.delegate = self
        tpMapView.showsScale = true;
        weak var weakSelf = self
        
        if let typhoon = typhoon {
            self.title = typhoon.chineseName
            WCHttpRequestManager.shareManager.loadTyphoonDetailWith(id: typhoon.id) { (typhoon, error) in
                if let coordinateArray = typhoon?.coordinateArray {
                    let polyLine = MKPolyline.init(coordinates: coordinateArray, count: coordinateArray.count)
                    weakSelf?.tpMapView.setRegion(MKCoordinateRegion.init(center: coordinateArray.last!, span: MKCoordinateSpan.init(latitudeDelta: 10, longitudeDelta: 10)), animated: true)
                    weakSelf?.tpMapView.addOverlay(polyLine)
                }
                if let details = typhoon?.details {
                    
                    weakSelf?.introTextView.text = "名字: \(typhoon?.name ?? "")\n"
                    weakSelf?.introTextView.text = (weakSelf?.introTextView.text)! + "中文: \(typhoon?.chineseName ?? "")\n"
                    weakSelf?.introTextView.text = (weakSelf?.introTextView.text)! + "来源: \(typhoon?.nameDescription ?? "")"
                    weakSelf?.introTextView.text = (weakSelf?.introTextView.text)! + "编号: \(typhoon?.noString ?? "")\n"
                    weakSelf?.introTextView.text = (weakSelf?.introTextView.text)! + "状态: \(typhoon?.status ?? "")\n"
                    
                    let dateFormat = DateFormatter.init()
                    dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
                    for (index, detail) in details.enumerated() {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2DMake(detail.latitude, detail.longitude)
                        let date = Date.init(timeIntervalSince1970: (Double(detail.ts)/1000.0))
                        annotation.title = dateFormat.string(from: date)
                        annotation.subtitle = "风速:\(detail.windSpeed), 移速:\(detail.moveSpeed), 方向:\(detail.direct)"
                        weakSelf?.tpMapView.addAnnotation(annotation)
                        if index == 0 {
                            dateFormat.dateFormat = "YYYY-MM-dd HH:mm"
                            let date = Date.init(timeIntervalSince1970: (Double(detail.ts)/1000.0))
                            weakSelf?.introTextView.text = (weakSelf?.introTextView.text)! + "开始: \(dateFormat.string(from: date))\n"
                        }
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
