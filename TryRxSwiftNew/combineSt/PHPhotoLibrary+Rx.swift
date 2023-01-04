//
//  PHPhotoLibrary+Rx.swift
//  TryRxSwiftNew
//
//  Created by  on 04/01/2023.
//

import Foundation
import Photos
import RxSwift

extension PHPhotoLibrary {
    
    // custom observable
    static var authorized: Observable<Bool> {
        return Observable.create { observer in
            
            // create{} gets called when new subscriber comes in
            DispatchQueue.main.async {
                if authorizationStatus() == .authorized {
                    observer.onNext(true)
                    observer.onCompleted()
                } else {
                    observer.onNext(false)
                    
                    // request auth completion with new state
                    requestAuthorization { newStatus in
                        observer.onNext(newStatus == .authorized)
                        observer.onCompleted()
                    }
                }
            }
            
            return Disposables.create()
        }
    }
}
