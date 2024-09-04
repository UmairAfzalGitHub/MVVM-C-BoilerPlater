//
//  HomeViewModel.swift
//  MVVMBoilerplate
//
//  Created by Umair Afzal on 23/08/2024.
//

import Foundation
import UIKit

class HomeViewModel {
    
    let authRepository = AuthRepository()
    
    func signup() {
        
        guard let image = UIImage(named: "profile.jpg"),
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            // Handle image retrieval error
            return
        }
        
        authRepository.signup(imageData: imageData, userName: "John Doe", email: "Test@test.com") { result in
            switch result {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure)
            }
        }
    }
}
