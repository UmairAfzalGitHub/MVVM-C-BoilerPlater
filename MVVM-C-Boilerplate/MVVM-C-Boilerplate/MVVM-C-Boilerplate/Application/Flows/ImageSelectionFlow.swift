import UIKit
import Photos

// Protocol that defines the output of the ImageSelectionFlow
public protocol ImageSelectionFlowOutput: AnyObject {
    func imageSelectionFlowDidPick(image: UIImage)
    func imageSelectionFlowDidCancel()
    func imageSelectionFlowDidFinish()
}

// Provide default implementations to make these methods optional
public extension ImageSelectionFlowOutput {
    func imageSelectionFlowDidPick(image: UIImage) {}
    func imageSelectionFlowDidCancel() {}
    func imageSelectionFlowDidFinish() {}
}

open class ImageSelectionFlow: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Private Properties

    private weak var output: ImageSelectionFlowOutput?
    private unowned let rootViewController: UIViewController
    private let allowsEditing: Bool
    private var imagePicker: UIImagePickerController?

    // MARK: - Init

    public init(output: ImageSelectionFlowOutput, rootViewController: UIViewController, allowsEditing: Bool = false) {
        self.output = output
        self.rootViewController = rootViewController
        self.allowsEditing = allowsEditing
        super.init()
    }
    
    // MARK: - Methods
    
    public func start() {
        presentImageSourceOptions()
    }

    private func presentImageSourceOptions() {
        let alertController = UIAlertController(title: Constants.selectImage, message: Constants.chooseASource, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: Constants.camera, style: .default) { _ in
            self.checkCameraPermissionAndPresent()
        })
        
        alertController.addAction(UIAlertAction(title: Constants.photoLibrary, style: .default) { _ in
            self.presentImagePicker(sourceType: .photoLibrary)
        })
        
        alertController.addAction(UIAlertAction(title: Constants.cancel, style: .cancel) { _ in
            self.output?.imageSelectionFlowDidCancel()
        })
        
        rootViewController.present(alertController, animated: true, completion: nil)
    }

    private func checkCameraPermissionAndPresent() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            presentImagePicker(sourceType: .camera)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.presentImagePicker(sourceType: .camera)
                    }
                } else {
                    self.showPermissionDeniedAlert()
                }
            }
        default:
            showPermissionDeniedAlert()
        }
    }

    private func presentImagePicker(sourceType: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(sourceType) else { return }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        picker.allowsEditing = allowsEditing
        self.imagePicker = picker
        
        rootViewController.present(picker, animated: true, completion: nil)
    }

    private func showPermissionDeniedAlert() {
        let alert = UIAlertController(title: Constants.permissionDenied, message: Constants.permissionDeniedMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.settings, style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        })
        alert.addAction(UIAlertAction(title: Constants.cancel, style: .cancel, handler: nil))
        rootViewController.present(alert, animated: true, completion: nil)
    }

    // MARK: - UIImagePickerControllerDelegate

    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            guard let self = self, let selectedImage = info[self.allowsEditing ? .editedImage : .originalImage] as? UIImage else {
                self?.output?.imageSelectionFlowDidFinish()
                return
            }
            self.output?.imageSelectionFlowDidPick(image: selectedImage)
            self.output?.imageSelectionFlowDidFinish()
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        output?.imageSelectionFlowDidCancel()
    }

    private enum Constants {
        static let permissionDenied = "Permission Denied"
        static let permissionDeniedMessage = "Please enable camera access in Settings."
        static let settings = "Settings"
        static let cancel = "Cancel"
        static let photoLibrary = "Photo Library"
        static let camera = "Camera"
        static let selectImage = "Select Image"
        static let chooseASource = "Choose a source"
    }
}
