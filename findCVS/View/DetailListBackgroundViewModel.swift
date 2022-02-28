//
//  DetailListBackgroundViewModel.swift
//  findCVS
//
//  Created by Terry on 2022/02/28.
//

import RxSwift
import RxCocoa

struct DetailListBackgroundViewModel{
    //ViewModel -> View
    let isStatusLabelHidden: Signal<Bool>
    
    //View -> ViewModel
    let shouldHideLabelHiddenLabel = PublishSubject<Bool>()
    
    init(){
        isStatusLabelHidden = shouldHideLabelHiddenLabel.asSignal(onErrorJustReturn: true)
    }
    
}
