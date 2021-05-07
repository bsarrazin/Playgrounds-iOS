import UIKit

protocol NoteDisplayable: AnyObject {
    var note: Note? { get set }
}

class NoteDetailViewController: UIViewController, NoteDisplayable {
    // MARK: - Properties
    var note: Note? {
        didSet { updateNoteInfo() }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var titleField: UILabel!
    @IBOutlet private var bodyField: UITextView!
    
    // MARK: - View Life Cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        updateNoteInfo()
    }
}

// MARK: - Internal
extension NoteDetailViewController {
    func updateNoteInfo() {
        guard isViewLoaded, let note = note
            else { return }
        
        titleField.text = note.title
        bodyField.text = note.body
    }
}
