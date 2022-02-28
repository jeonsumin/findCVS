//
//  LocationInfomationViewModel.swift
//  findCVS
//
//  Created by Terry on 2022/02/28.
//

import RxSwift
import RxCocoa

struct LocationInfomationViewModel {
    let disposeBag = DisposeBag()
    
    //ViewModel -> View
    let setMapCenter: Signal<MTMapPoint>
    let errorMassage: Signal<String>
    
    // View -> viewModel
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let currentLocationButtonTapped = PublishRelay<Void>()
    
    init(){
        //MARK: 지도 중심점 설정
        let moveToCurrentLocation = currentLocationButtonTapped
            .withLatestFrom(currentLocation)
        let currentMapCenter = Observable
            .merge(
                currentLocation.take(1),
                moveToCurrentLocation
            )
        
        setMapCenter = currentMapCenter
            .asSignal(onErrorSignalWith: .empty())
        
        errorMassage = mapViewError.asObservable()
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도해주세요.")
    }
    
}
