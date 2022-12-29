//
//  Chapter02-Observables.swift
//  TryRxSwiftNew
//
//  Created by Ahmad medo on 29/12/2022.
//

import Foundation
import RxSwift

class Ch02Observables{
    
    
    let disposeBag = DisposeBag()

    //MARK: - Chapter2 Observables
    func observablesChapter(){
        
        
        let one = 1
        let two = 2
        let three = 3
        
        let string1 = "string1"
        
        //        let observable = Observable<Int>.just(one)
        
        //        let listOfNum = [one, two, three]
        
        let observable2 = Observable.of([one, two, three])
        
        let observable4 = Observable.from([one, two, three])
        
        let subscriber = observable4.subscribe(
            // these are events listeners
            onNext: {
                element in
                print(element)
            },
            onCompleted: {
                // does not have element
                print("completed")
                
            }
        ).disposed(by: disposeBag)
        //--------------------------------
        //create
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
        
        
        
        // challenge 1
        let observable = Observable<Any>.never()
        
        observable.do(
            onSubscribe: {
                print("subscribed")
            })
        .subscribe(
            onNext: { element in
                print(element)
            },
            onCompleted: {
                print("Completed")
            },
            onDisposed: {
                print("Disposed")
            }
        )
            .disposed(by: disposeBag)
            }
}
