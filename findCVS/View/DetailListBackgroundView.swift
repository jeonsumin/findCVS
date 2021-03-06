//
//  DetailListBackgroundView.swift
//  findCVS
//
//  Created by Terry on 2022/02/28.
//

import RxSwift
import RxCocoa
import SnapKit

class DetailListBackgroundView: UIView {
    let disposeBag = DisposeBag()
    let statusLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        atrribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: DetailListBackgroundViewModel){
        viewModel.isStatusLabelHidden
            .emit(to: statusLabel.rx.isHidden)
            .disposed(by: disposeBag)
    }
    
    private func atrribute() {
        backgroundColor = .systemBackground
        statusLabel.text = "🏪"
        statusLabel.textAlignment = .center
    }
    
    private func layout(){
        addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints{
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
