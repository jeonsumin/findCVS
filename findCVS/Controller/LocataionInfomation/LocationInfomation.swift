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
    let detailListBackgroundView = DetailListBackgroundView()
    let viewModel = LocationInfomationViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
    }
    
    
    func bind(_ viewModel: LocationInfomationViewModel) {
        detailListBackgroundView.bind(viewModel.detailListBackgroundViewModel)
        
        viewModel.setMapCenter
            .emit(to: mapView.rx.setMapCenterPoint)
            .disposed(by: disposeBag)
        
        viewModel.errorMassage
            .emit(to: self.rx.presentAlert)
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .drive(detailList.rx.items){ tv, row, data in
                let cell = tv.dequeueReusableCell(withIdentifier: "DetailListCell", for: IndexPath(row: row, section: 0)) as! DetailListCell
                cell.setData(data)
                return cell
            }
            .disposed(by: disposeBag)
        
        viewModel.detailListCellData
            .map { $0.compactMap{ $0.point } }
            .drive(self.rx.addPOIItems)
            .disposed(by: disposeBag)
        
        viewModel.scrollToSelectedLocation
            .emit(to: self.rx.showSelectedLocation)
            .disposed(by: disposeBag)
        
        detailList.rx.itemSelected
            .map{ $0.row }
            .bind(to: viewModel.detailListItemSelected)
            .disposed(by: disposeBag)
        
        currentLocationButton.rx.tap
            .bind(to: viewModel.currentLocationButtonTapped)
            .disposed(by: disposeBag)
    }
    
    
    override func attribute() {
        title = "??? ?????? ????????? ??????"
        
        mapView.currentLocationTrackingMode = .onWithoutHeadingWithoutMapMoving
        currentLocationButton.setImage(UIImage(systemName: "location.fill"), for: .normal)
        currentLocationButton.backgroundColor = .white
        currentLocationButton.layer.cornerRadius = 20
        
        detailList.register(DetailListCell.self, forCellReuseIdentifier: "DetailListCell")
        detailList.separatorStyle = .none
        detailList.backgroundView = detailListBackgroundView
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
     ??????????????? ???????????? ????????? ???????????????
     ??????????????? ????????? ?????? ????????????????????? ????????? ??????(??????????????? ??????????????? ????????? ??? ??????.)
     ????????? ??????????????? ???????????? ????????? ???????????? ?????????????????? ??????.
     */
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
        viewModel.currentLocation.accept(location)
        #endif
    }
    
    //?????? ????????? ???????????? ???????????? centerPoint??? ??????????????? ???????????????
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    //?????? ????????? ?????? point??? ?????? ??????????????? ???????????????
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    //???????????? ?????? ????????? ???????????? ???????????? ???????????? ???????????????
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        viewModel.mapViewError.accept(error.localizedDescription)
    }
}

