import UIKit

class AttachPhotoViewController: UIViewController {
    // MARK: - Properties
    var note: Note?
    lazy var imagePicker: UIImagePickerController = {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        addChild(picker)
        return picker
    }()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(imagePicker)
        view.addSubview(imagePicker.view)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imagePicker.view.frame = view.bounds
    }
}

// MARK: - UIImagePickerControllerDelegate
extension AttachPhotoViewController: UIImagePickerControllerDelegate {
}

// MARK: - UINavigationControllerDelegate
extension AttachPhotoViewController: UINavigationControllerDelegate {
}

// MARK: - NoteDisplayable
extension AttachPhotoViewController: NoteDisplayable {
}
