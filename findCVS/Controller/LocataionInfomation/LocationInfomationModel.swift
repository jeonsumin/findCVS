//
//  LocationInfomationModel.swift
//  findCVS
//
//  Created by Terry on 2022/03/01.
//

import Foundation
import RxSwift

struct LocationInfomationModel {
    let localtionNetwork: LocalNetwork
    
    init(localNatwork: LocalNetwork = LocalNetwork()){
        self.localtionNetwork = localNatwork
    }
    
    func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData,URLError>> {
        return localtionNetwork.getLocation(by: mapPoint)
    }
    
    func documentToCellData(_ data: [KLDocument]) -> [DetailListCellData] {
        return data.map {
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = documentToMTmapPoint($0)
            return DetailListCellData(placeName: $0.placeName, address: address, distance: $0.distance, point: point)
        }
    }
    
    func documentToMTmapPoint(_ doc: KLDocument) -> MTMapPoint {
        let latitude = Double(doc.x) ?? .zero
        let longtitude = Double(doc.y) ?? .zero
        
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longtitude))
    }
    
}
