//
//  LocationInfomation.swift
//  findCVS
//
//  Created by Terry on 2022/02/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import CoreLocation


class LocationInfomation: BaseViewController {
    
    let locationManager = CLLocationManager()
    let mapView = MTMapView()
    let currentLocationButton = UIButton()
    let detailList = UITableView()
    let viewModel = LocationInfomationViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    func bind(_ viewModel: LocationInfomationViewModel) {
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMassage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    
    override func attribute() {
        title = "내 주변 편의점 찾기"
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
    }
    override func layout() {
        [mapView, currentLocationButton, detailList].forEach{view.addSubview($0)}
        
        mapView.snp.makeConstraints{
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view.snp.centerY).offset(100)
        }
        
        currentLocationButton.snp.makeConstraints{
            $0.bottom.equalTo(detailList.snp.top).offset(-12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.height.equalTo(40)
        }
        
        detailList.snp.makeConstraints{
            $0.centerX.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.top.equalTo(mapView.snp.bottom)
        }
    }
    
}

//MARK: - CLLocationManagerDelegate
extension LocationInfomation: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,
             .authorizedWhenInUse,
             .notDetermined :
            return
        default:
            viewModel.mapViewError.accept(MTMapViewError.locationAuthorizationDenied.errorDescroption)
            return
        }
    }
}


//MARK: - MTMapViewDelegate
extension LocationInfomation: MTMapViewDelegate {
    /*
     현재위치를 업데이트 해주는 델리게이트
     현재위치를 사용할 경우 시뮬레이터에서 테스트 불가(현재위치를 정상적으로 받아올 수 없다.)
     디버그 모드일때랑 아닐때가 임의의 좌표값을 입력해주어야 한다.
     */
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
        viewModel.currentLocation.accept(location)
        #endif
    }
    
    //맵의 이동이 끝났을때 마지막에 centerPoint를 전달해주는 델리게이트
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    //핀을 탭할때 마다 point의 값을 전달해주는 델리게이트
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    //제대로된 현재 위치를 불러오지 못했을때 호출되는 델리게이트
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}

