//
//  ContentView.swift
//  RxswiftPractice(1)
//
//  Created by 최희진 on 11/2/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = UserViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            switch viewModel.userState {
            case .initial:
                Text("사용자 정보를 조회하려면 아래 버튼 클릭")
                
            case .loading:
                ProgressView()
                
            case .loaded(let user):
                VStack(alignment: .leading, spacing: 12) {
                    Text("이름: \(user.name)")
                    Text("아이디: \(user.username)")
                    Text("번호: \(user.phone)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
            case .error(let message):
                Text(message)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                viewModel.fetchUser()
            }) {
                Text("사용자 정보 조회")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
