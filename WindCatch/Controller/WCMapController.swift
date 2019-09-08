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
        
        if let tp = typhoon {
            WCHttpRequestManager.shareManager.loadTyphoonDetailWith(id: tp.id) { (typhoon, error) in
                
            }
        }
    }

}
