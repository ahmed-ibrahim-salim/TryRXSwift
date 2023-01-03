//
//  Chapter05-challenge1.swift
//  TryRxSwiftNew
//
//  Created by magdy khalifa on 03/01/2023.
//
import Foundation
import RxSwift

class Chapter01Challenge01{
    
    let disposeBag = DisposeBag()
    
    let contacts = [
        "603-555-1212": "Florent",
        "212-555-1212": "Shai",
        "408-555-1212": "Marin",
        "617-555-1212": "Scott"
    ]
    
    static func run(){
        
        func phoneNumber(from inputs: [Int]) -> String {
            var phone = inputs.map(String.init).joined()
            
            phone.insert("-", at: phone.index(
                phone.startIndex,
                offsetBy: 3)
            )
            
            phone.insert("-", at: phone.index(
                phone.startIndex,
                offsetBy: 7)
            )
            
            return phone
        }
        
        let input = PublishSubject<Int>()
        
        // Add your code here
        
        input
            .skip(while: {$0 == 0})
            .filter({$0 < 10})
            .take(10)
            .toArray()
            .subscribe({
                event in
                print(event)
            })
            
        
        
        input.onNext(0)
        input.onNext(603)
        
        input.onNext(2)
        input.onNext(1)
        
        // Confirm that 7 results in "Contact not found",
        // and then change to 2 and confirm that Shai is found
        input.onNext(7)
        
        "5551212".forEach {
            if let number = (Int("\($0)")) {
                input.onNext(number)
            }
        }
        
        input.onNext(9)
    }
    
    
    
}

