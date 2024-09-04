
import UIKit

protocol HomeViewInput: AnyObject {
    func didSelectImage(image: UIImage)
    func didSignUpSuccessfully()
    func didRecieveError(error: Error)
}

class HomeViewController: UIViewController, HomeViewInput {
    @IBOutlet weak var imageView: UIImageView!

    var output: HomeViewOutput?
    var viewModel: HomeViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel = HomeViewModel(view: self)
        output = viewModel
    }

    @IBAction func didTapSelectImage(_ sender: Any) {
        output?.openImagePicker(root: self)
    }

    // MARK: - HomeViewInput

    func didSelectImage(image: UIImage) {
        imageView.image = image
        // Optional, just for displaying the contact point
        // viewModel?.signup(image: image)
    }
    
    func didSignUpSuccessfully() {
    }
    
    func didRecieveError(error: Error) {
        // Show Error
    }
}
