//
//  UserViewModel.swift
//  RxswiftPractice(1)
//
//  Created by 최희진 on 11/2/24.
//

import SwiftUI
import RxSwift

enum UserState {
    case initial
    case loading
    case loaded(User)
    case error(String)
}

class UserViewModel: ObservableObject {
    private let disposeBag = DisposeBag()
    @Published var userState: UserState = .initial
    
    func fetchUser() {
        userState = .loading // 조회 시작 시 상태를 로딩으로 설정

        Observable<User>.create { observer in
            // 랜덤으로 성공 또는 실패 결정
            let success = Bool.random() // 무작위로 true 또는 false 반환

            if success {
                // 성공 시 더미 데이터 반환
                let user = User(
                    id: 0,
                    name: "abc",
                    username: "abc id",
                    phone: "010-1234-5678"
                )
                observer.onNext(user)
                observer.onCompleted() // 데이터 전송 완료
            } else {
                // 실패 시 에러 발생
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "네트워크 오류가 발생했습니다."])
                observer.onError(error) // 에러 전송
            }

            return Disposables.create() // 리소스 해제용
        }
        .delay(.seconds(2), scheduler: MainScheduler.instance)
        .observe(on: MainScheduler.instance)
        .subscribe(
            onNext: { [weak self] user in
                self?.userState = .loaded(user) // 데이터 로드 성공 시 상태를 loaded로 업데이트
            },
            onError: { [weak self] error in
                self?.userState = .error(error.localizedDescription) // 에러 발생 시 상태를 error로 설정
            }
        )
        .disposed(by: disposeBag)
    }
}
