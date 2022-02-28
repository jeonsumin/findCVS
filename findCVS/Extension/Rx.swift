//
//  Rx.swift
//  findCVS
//
//  Created by Terry on 2022/02/28.
//

import RxSwift
import RxCocoa



//MARK: - RX Extension
extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}
extension Reactive where Base: LocationInfomation {
    var presentAlert: Binder<String> {
        return Binder(base) { base, message in
            let alertController = UIAlertController(title: "문제가 발생했습니다",
                                                    message: message,
                                                    preferredStyle: .alert)
            
            let action = UIAlertAction(title: "확인",
                                       style: .default,
                                       handler: nil)
            alertController.addAction(action)
            
            base.present(alertController,
                         animated: true,
                         completion: nil)
        }
    }
    
    var showSelectedLocation: Binder<Int>{
        return Binder(base) { base, row in
            let indexPath = IndexPath(row: row, section: 0)
            base.detailList.selectRow(at: indexPath,
                                      animated: true,
                                      scrollPosition: .top)
        }
    }
    var addPOIItems: Binder<[MTMapPoint]> {
        return Binder(base) { base, points in
            let items = points
                .enumerated()
                .map {offset, point -> MTMapPOIItem in
                    let mapPOIItem = MTMapPOIItem()
                    
                    mapPOIItem.mapPoint = point
                    mapPOIItem.markerType = .redPin
                    mapPOIItem.showAnimationType = .springFromGround
                    mapPOIItem.tag = offset
                    
                    return mapPOIItem
                }
            base.mapView.removeAllPOIItems()
            base.mapView.addPOIItems(items)
        }
    }
}
