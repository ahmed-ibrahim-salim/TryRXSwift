//
//  ViewController.swift
//  TryRxSwiftNew
//
//  Created by Ahmed ibrahim on 21/12/2022.
//

import UIKit
import RxSwift
import RxRelay



class MainVC: UIViewController {
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        diffBetweenObservableSubject()
    }
}
extension MainVC{
    
    func diffBetweenObservableSubject(){
        // read-only
        let observable = Observable<Int>.of(1, 2, 3, 4, 5)
        
        // observable is read-only means that it does not accept values.
        observable.onNext()
        
        // you can only subscribe to observable
        observable.subscribe({
            event in
            print(event.element)
        })
        
        // ---------------------------------------------------------
        let subject = PublishSubject<Int>()
        
        // similar to observable, you can subscribe to subject
        subject.subscribe({
            event in
            print(event.element)
        })
        
        // main difference
        // you can add events to a subject
        subject.onNext(5555)

        
    }
}

extension MainVC{
    
    func takeWhileExample(){
        let disposeBag = DisposeBag()
        // 1
          Observable.of(2, 2, 4, 4, 6, 6)
            // 2
            .enumerated()
        // 3
            .takeWhile { index, integer in
              // 4
              integer.isMultiple(of: 2) && index < 3
            }
        // 5
            .map(\.element)
            // 6
            .subscribe(onNext: {
                print($0)
                
            })
    }
    
    func skipUntillExample(){
        // 1
          let subject = PublishSubject<String>()
          let trigger = PublishSubject<String>()
        // 2
          subject
            .skipUntil(trigger)
            .subscribe(onNext: {
        print($0) })
            .disposed(by: disposeBag)
        // skipped cuz trigger not started yet
       subject.onNext("A")
       subject.onNext("B")
        
        // trigger started
        trigger.onNext("X")
        // now this gets emitted
        subject.onNext("C")
    }
    
    func skipWhileExample(){
        // 1
        Observable.of(2, 2, 3, 4, 4)
        // 2
            .skip(while: { $0 == 2 })
            .subscribe(onNext: {
                print($0)
                
            })
            .disposed(by: disposeBag)
    }
    
    func filterExample(){
        let strikes = Observable.of(1, 2, 3, 4, 5, 6)
        
        strikes
            .filter { $0.isMultiple(of: 2)}
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
    
    func elementAt(){
        let strikes = PublishSubject<String>()
        // 2
        strikes
            .elementAt(2)
            .subscribe(onNext: { _ in
                print("You're out!")
            })
            .disposed(by: disposeBag)
        
        strikes.onNext("X")
        strikes.onNext("X")
        strikes.onNext("X")
    }
}
