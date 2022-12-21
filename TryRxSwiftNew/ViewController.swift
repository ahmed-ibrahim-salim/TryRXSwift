//
//  ViewController.swift
//  TryRxSwiftNew
//
//  Created by magdy khalifa on 21/12/2022.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let disposeBag = DisposeBag()
        
        
        let one = 1
        let two = 2
        let three = 3
        
        let string1 = "string1"
        
//        let observable = Observable<Int>.just(one)
        
//        let listOfNum = [one, two, three]
        
        let observable2 = Observable.of([one, two, three])
        
        let observable4 = Observable.from([one, two, three])
        
//        let subscriber = observable4.subscribe(
//            // these are events listeners
//            onNext: {
//                element in
//                print(element)
//            },
//            onCompleted: {
//                // does not have element
//                print("completed")
//
//            }
//        ).disposed(by: disposeBag)
// --------------------------------
       // create
        let observableWithCreate = Observable<String>.create{
            observer in
            // 1
              observer.onNext("1")
              // 2
              observer.onCompleted()
            // 3
              observer.onNext("?")
            // 4
              return Disposables.create()
        }
        
        observableWithCreate.subscribe(
            onNext: {
                print($0)
            },
            onError: {
                print($0)
            },
            onCompleted: {
                print("completed")
            },
            onDisposed: {
                print("disposed")
            }
        ).disposed(by: disposeBag)
        
    }
}

