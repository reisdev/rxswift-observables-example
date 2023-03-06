//
//  ViewController.swift
//  rxswift-observables-example
//
//  Created by Matheus dos Reis de Jesus on 01/03/23.
//

import UIKit
import RxSwift
import RxCocoa

extension String: Error {}

// Fluxo de Dados

// onNext(um novo valor)
// onCompleted(fluxo encerrado com sucessado)
// onError(ocorreu um erro no fluxo)

class ViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        exemploPublishSubject()
        exemploBehaviorSubject()
        exemploReplaySubject()
    }
    
    // Single: success(1), failure(1)
    func exemploTraitSingle() -> Single<String> {
        Single<String>.create { single in
            
            single(.failure("Erro"))
            single(.success("OK"))
            
            return Disposables.create()
        }
    }
    
    // Completable: completed, error
    func exemploTraitCompletable() -> Completable {
        Completable.create { completable in
            
            completable(.error("Erro"))
            completable(.completed)
            
            return Disposables.create ()
        }
    }
    
    // Maybe: success, completed, error
    func exemploTraitMaybe() -> Maybe<String> {
        Maybe<String>.create { maybe in
            
            maybe(.success("OK"))
            maybe(.completed)
            maybe(.error("Erro"))
            
            return Disposables.create()
        }
    }
    
    func exemploPublishSubject() {
        let publishObservable = PublishSubject<String>()
        
        print("===== PublishSubject =====")
        publishObservable.subscribe(onNext: { string in
            print(string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("PublishObservable Completed")
        }).disposed(by: disposeBag)
        
        publishObservable.onNext("OK 1")
        publishObservable.onNext("OK 2")
        publishObservable.onNext("OK 3")
        
        publishObservable.onCompleted()
        
        // Não é emitido, pois o fluxo de dados foi enceraddo no onCompleted
        publishObservable.onError("Erro no fluxo de dados")
    }
    
    func exemploBehaviorSubject() {
        let behaviorObservable = BehaviorSubject<String>(value: "OK 0")
        
        print("===== BehaviorSubject =====")
        
        behaviorObservable.onNext("OK -1")
        
        behaviorObservable.subscribe(onNext: { string in
            print(string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("BehaviorObservable Completed")
        }).disposed(by: disposeBag)
        
        behaviorObservable.onNext("OK 1")
        behaviorObservable.onNext("OK 2")
        behaviorObservable.onNext("OK 3")
        
        behaviorObservable.onCompleted()
        
        let value = try? behaviorObservable.value()
        
        print(String(format: "Valor: %@", value ?? ""))
    }
    
    func exemploReplaySubject() {
        let replayObservable = ReplaySubject<String>.create(bufferSize: 2)
        
        print("===== ReplaySubject =====")
                
        replayObservable.onNext("OK -1")
        replayObservable.onNext("OK 1")
        replayObservable.onNext("OK 2")
        
        replayObservable.subscribe(onNext: { string in
            print(string)
        }, onError: { error in
            print(error)
        }, onCompleted: {
            print("ReplayObservable Completed")
        }).disposed(by: disposeBag)
        
        replayObservable.onNext("OK 3")
        replayObservable.onNext("OK 4")
    }
}

