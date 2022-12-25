//
//  Chapter03-Subjects.swift
//  TryRxSwiftNew
//
//  Created by Ahmad medo on 25/12/2022.
//

import Foundation
import RxSwift
import RxRelay


enum MyError: Error {
    case anError
}

//MARK: - Chapter 3 Subjects
class Chapter03Subjects{
    static var disposeBag = DisposeBag()
    
    static func newPrint<T: CustomStringConvertible>(label: String,
                                              event: Event<T>){
        
        print(label, (event.element ?? event.error) ?? event)
    }
    // Publish subject
    static func usingPublishSubject(){
        let subject = PublishSubject<String>()
        
        // no body subscribed then no one will get this event
        subject.on(.next("Is anyone listening?"))
        
        let subscribtion1 = subject
            .subscribe(onNext: {
                print($0)
            })
        // now subscribtion1 recieves the following event
        subject.on(.next("1"))
        // at some point of time a new subscriber is listening, and get the following events
        let subscriptionTwo = subject
            .subscribe { event in
                print("2)", event.element ?? event)
            }
        
        subject.onNext("3")
        
        // subject gets terminated with a completed event
        subject.onCompleted()
        
        //following subscribers gets only a completed event
        let subscription3 = subject
            .subscribe { event in
                print("3", event.element ?? event)
            }
        
        // even you provided a next event
        subject.onNext("will not be received")
    }
    
    // Behavior subject
    static func usingBehaviorSubject(){
        
        // define behavior subject with initial value
        let subject = BehaviorSubject(value: "initial value")
        
        // first subscriber, will recieve the latest event and all events from now on.
        subject
          .subscribe {
              self.newPrint(label: "1)", event: $0)
          }
          .disposed(by: disposeBag)
        
        subject.onNext("X")
        
        subject.onError(MyError.anError)
        
        // second subscriber, only recieves latest event
        subject
          .subscribe {
              self.newPrint(label: "2)", event: $0)
          }
          .disposed(by: disposeBag)
        
    }
    // Replay subject
    static func usingReplaySubject(){
        // replay subject, with buffersize of 2
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        
        // new subscriber get latest 2 events
        subject.subscribe{
            self.newPrint(label: "1)", event: $0)
        }
        .disposed(by: disposeBag)
        
        // new subscriber get latest 2 events
        subject.subscribe{
            self.newPrint(label: "2)", event: $0)
        }
        .disposed(by: disposeBag)
        
        // we already have 2 subscribers, then they get this event normally without repeating older events
        subject.onNext("4")
        
        //The replay subject is terminated with an error, without disposing the behavior subject
        subject.onError(MyError.anError)
//        // if used disposed then only emits error event only
//        subject.dispose()
        
        // gets the last 2 events which is 3,4 and terminated with error
        subject
          .subscribe {
              self.newPrint(label: "3)", event: $0)
          }
          .disposed(by: disposeBag)
    }
    
    static func usingRelays(){
        let relay = PublishRelay<String>()

        relay.accept("Knock knock, anyone home?")

        relay.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)

        relay.accept("1")
     // ----- behavior relay
        let behaviorRelay = BehaviorRelay(value: "initial value")
        // print latest "initial", and any upcoming events
        behaviorRelay.subscribe{
            self.newPrint(label: "(1", event: $0)
        }.disposed(by:disposeBag)
        
        behaviorRelay.accept("1")
        
        behaviorRelay
          .subscribe {
              self.newPrint(label: "2)", event: $0)
          }
          .disposed(by: disposeBag)
        
        // relay accepts new event
        behaviorRelay.accept("2")
        
        // behaviorRelay allow access to current value
        print(behaviorRelay.value)
    }
    
}
