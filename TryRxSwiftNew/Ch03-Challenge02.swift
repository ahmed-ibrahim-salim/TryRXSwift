//
//  Ch03-Challenge02.swift
//  TryRxSwiftNew
//
//  Created by Ahmad medo on 25/12/2022.
//

import Foundation
import RxSwift
import RxRelay

// challnge show how to use behavior relay for user session
// adding events to relay, and getting current value
class Challenge2{
    
    static func runChallenge(){
        
        let disposeBag = DisposeBag()
        enum UserSession {
            case loggedIn, loggedOut
        }
        
        enum LoginError: Error {
            case invalidCredentials
        }
        
        // Create userSession BehaviorRelay of type UserSession with initial value of .loggedOut
        let userSession = BehaviorRelay<UserSession>(value: .loggedOut)
        
        // Subscribe to receive next events from userSession
        userSession.subscribe(onNext: {
            userSession in
            print(userSession)
        }).disposed(by: disposeBag)
        
        func logInWith(username: String,
                       password: String,
                       completion: (Error?) -> Void) {
            guard username == "johnny@appleseed.com",
                  password == "appleseed" else {
                completion(LoginError.invalidCredentials)
                return
            }
            
            // Update userSession
            userSession.accept(.loggedIn)
        }
        
        func logOut() {
            // Update userSession
            userSession.accept(.loggedOut)
        }
        
        func performActionRequiringLoggedInUser(action: () -> ()) {
            // Ensure that userSession is loggedIn and then execute action()
            guard userSession.value == .loggedIn else{
               print("you can not do that")
                return
            }
            
            // if logged in then you can do something
            action()
        }
        
        // excution logged out then logged in
        for i in 1...2 {
            let password = i % 2 == 0 ? "appleseed" : "password"
            
            logInWith(username: "johnny@appleseed.com",
                      password: password) {
                error in
                guard error == nil else {
                    print(error!)
                    return
                }
                
                print("User logged in.")
            }
            
            performActionRequiringLoggedInUser(action: {
                print("Successfully did something only a logged in user can do.")
            })
        }
    }
}
