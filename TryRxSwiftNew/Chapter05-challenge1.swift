//
//  Chapter05-challenge1.swift
//  TryRxSwiftNew
//
//  Created by magdy khalifa on 03/01/2023.
//
import Foundation
import RxSwift

class Chapter05Challenge01{
    
    let disposeBag = DisposeBag()
    
    static let contacts = [
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
        // skip untill true then pass what comes next
            .skip(while: {$0 == 0})
            .filter({$0 < 10})
        // take first 10 items only
            .take(10)
        // toArray returns a Single which is (success or failed)
            .toArray()
            .subscribe({
                result in
                
                switch result{
                case .success(let numbers):
                    
                    let phone = phoneNumber(from: numbers)
                    
                    if let contact = contacts[phone] {
                      print("Dialing \(contact) (\(phone))...")
                    } else {
                      print("Contact not found")
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
            })
            
        
        input.onNext(0)
        input.onNext(603)
        
        input.onNext(2)
        input.onNext(1)
        
        // 7 == "Contact not found",
//        input.onNext(7)

        // 212 Shai is found
        input.onNext(2)
        
        "5551212".forEach {
            if let number = (Int("\($0)")) {
                input.onNext(number)
            }
        }
        
        input.onNext(9)
    }
    
    
    
}

