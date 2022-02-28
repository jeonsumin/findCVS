//
//  BaseViewController.swift
//  FindCVS
//
//  Created by Terry on 2022/02/28.
//

import UIKit
import RxSwift


class BaseViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
    }
    func attribute(){
        view.backgroundColor = .systemBackground
    }
    func layout(){}
    
}
