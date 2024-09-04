
import Foundation
import UIKit

protocol HomeViewOutput: AnyObject {
    func openImagePicker(root: UIViewController)
    func signup(image: UIImage?)
}

class HomeViewModel: HomeViewOutput, ImageSelectionFlowOutput {
    
    weak var view: HomeViewInput?

    private var imageSelectionFlow: ImageSelectionFlow?
    private let authRepository = AuthRepository()
    
    init(view: HomeViewInput? = nil) {
        self.view = view
    }
    
    // A dummy API call to show how to communicate with network layer
    func signup(image: UIImage?) {
        
        guard let image,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            // Handle image retrieval error
            return
        }

        authRepository.signup(imageData: imageData, userName: "John Doe", email: "Test@test.com") {[weak self] result in
            guard let self else { return }
            switch result {
            case .success(_):
                view?.didSignUpSuccessfully()
            case .failure(let failure):
                view?.didRecieveError(error: failure)
                print(failure)
            }
        }
    }
    
    // MARK: - HomeViewOutput
    
    func openImagePicker(root: UIViewController) {
        imageSelectionFlow = ImageSelectionFlow(output: self, rootViewController: root, allowsEditing: true)
        imageSelectionFlow?.start()
    }
    
    // MARK: - ImageSelectionFlowOutput
    
    func imageSelectionFlowDidPick(image: UIImage) {
        // Handle selected image
        view?.didSelectImage(image: image)
        print("Selected image: \(image)")
    }
    
    func imageSelectionFlowDidCancel() {
        // Handle cancellation
        print("Image selection cancelled")
    }
    
    func imageSelectionFlowDidFinish() {
        // Cleanup if needed
        imageSelectionFlow = nil
        print("Image selection flow finished")
    }
}
