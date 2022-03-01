//
//  LocaNetworkStub.swift
//  findCVSTests
//
//  Created by Terry on 2022/03/01.
//

import Foundation
import RxSwift
import Stubber

@testable import findCVS

class LocaNetworkStub: LocalNetwork {
    override func getLocation(by mapPoint: MTMapPoint) -> Single<Result<LocationData, URLError>> {
        return Stubber.invoke(getLocation, args: mapPoint)
    }
}
