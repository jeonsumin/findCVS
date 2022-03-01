//
//  LocationInfomationViewModel.swift
//  findCVS
//
//  Created by Terry on 2022/02/28.
//

import RxSwift
import RxCocoa
import os

struct LocationInfomationViewModel {
    let disposeBag = DisposeBag()
    
    //subViewModels
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    //ViewModel -> View
    let setMapCenter: Signal<MTMapPoint>
    let errorMassage: Signal<String>
    let detailListCellData: Driver<[DetailListCellData]>
    let scrollToSelectedLocation: Signal<Int>
    
    // View -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    let detailListItemSelected = PublishRelay<Int>()
    
    private let documentData = PublishSubject<[KLDocument]>()
    
    init(model: LocationInfomationModel = LocationInfomationModel() ){
        //MARK: 네트워크 통신
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation)
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap{ data -> LocationData? in
                guard case let .success(value) = data else {
                    return nil
                }
                return value
            }
        
        let cvsLocationDataErrorMessage = cvsLocationDataResult
            .compactMap{ data -> String? in
                switch data {
                case let .success(data) where data.documents.isEmpty:
                    return """
                    500m 근처에 이용할 수 있는 편의점이 없습니다.
                    지도 위치를 다시 확인 해 주시기 바랍니다.
                    """
                case let .failure(error) :
                    return error.localizedDescription
                default:
                    return nil
                }
            }
        
        cvsLocationDataValue
            .map { $0.documents }
            .bind(to: documentData)
            .disposed(by: disposeBag)
        
        //MARK: 지도 중심점 설정
        let selectDetailListItem = detailListItemSelected
            .withLatestFrom(documentData) { $1[$0] }
            .map { data -> MTMapPoint in
                guard let longitude = Double(data.x),
                      let latitude = Double(data.y) else {
                          return MTMapPoint()
                      }
                let geoCoord = MTMapPointGeo(latitude: latitude, longitude: longitude)
                return MTMapPoint(geoCoord: geoCoord)
            }
            
        
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        let currentMapCenter = Observable
            .merge(
                selectDetailListItem,
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMassage = Observable
            .merge(
                cvsLocationDataErrorMessage
                , mapViewError.asObservable()
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
        
        detailListCellData = documentData
            .map(model.documentToCellData)
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map{ !$0.isEmpty}
            .bind(to: detailListBackgroundViewModel.shouldHideLabelHiddenLabel)
            .disposed(by: disposeBag)
        
        
        scrollToSelectedLocation = selectPOIItem
            .map{ $0.tag }
            .asSignal(onErrorJustReturn: 0)
    }
    
}
