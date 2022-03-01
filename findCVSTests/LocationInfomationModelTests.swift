//
//  LocationInfomationModelTests.swift
//  findCVSTests
//
//  Created by Terry on 2022/03/01.
//

import XCTest
import Nimble

@testable import findCVS

class LocationInfomationModelTests: XCTestCase {

    let stubNetwork = LocaNetworkStub()
    
    var doc: [KLDocument]!
    var model: LocationInfomationModel!
    
    override func setUp() {
        self.model = LocationInfomationModel(localNatwork: stubNetwork)
        self.doc = cvsList
    }
    
    func testDocumentsToCellData(){
        let cellData = model.documentToCellData(doc) //실제 모델의 값
        let placeName = doc.map{$0.placeName} //더미데이터의 값
        let address0 = cellData[1].address // 실제모델에서의 값
        let roadAddress = doc[1].roadAddressName // 더미데이터의 값
        
        expect(cellData.map {$0.placeName}).to(equal(placeName), description: "DetailListCellData의 placeName은 document의 PlaceName이다.")
        
        expect(address0).to(equal(roadAddress), description: "KLDocument의 RoadAddressName이 빈 값이 아닐 경우 roadAddress가 cellData에 전달된다. ")
    }
}
