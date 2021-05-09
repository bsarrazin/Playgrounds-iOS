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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let note = note, let context = note.managedObjectContext
            else { return }

        let attachment = Attachment(context: context)
        attachment.created = .init()
        attachment.image = info[.originalImage] as? UIImage
        attachment.note = note
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UINavigationControllerDelegate
extension AttachPhotoViewController: UINavigationControllerDelegate {
}

// MARK: - NoteDisplayable
extension AttachPhotoViewController: NoteDisplayable {
}
