import UIKit

class NoteTableViewCell: UITableViewCell {
    // MARK: - Properties
    var note: Note? {
        didSet {
            guard let note = note else { return }
            updateNoteInfo(note: note)
        }
    }
    
    // MARK: - IBOutlets
    @IBOutlet private var noteTitle: UILabel!
    @IBOutlet private var noteCreateDate: UILabel!
}

// MARK: - Internal
@objc extension NoteTableViewCell {
    func updateNoteInfo(note: Note) {
        noteTitle.text = note.title
        noteCreateDate.text = note.dateCreated.description
    }
}
