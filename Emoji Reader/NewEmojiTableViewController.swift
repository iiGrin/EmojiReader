//
//  NewEmojiTableViewController.swift
//  Emoji Reader
//
//  Created by iggy on 4.09.22.
//

import UIKit

class NewEmojiTableViewController: UITableViewController {
    
    // Object model for editable emoji.
    var emoji = Emoji(emoji: "", name: "", description: "", isFavourite: false)

    @IBOutlet weak var emojiTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateUI()
        updateSaveButtonState()
    }
    
    // We make the save button active only when all tf are full. Call it in the viewDidLoad method when the screen loads and in textChanged method.
    private func updateSaveButtonState() {
        let emojiText = emojiTextField.text ?? ""
        let nameText = nameTextField.text ?? ""
        let descriptionText = descriptionTextField.text ?? ""

        saveButton.isEnabled = !emojiText.isEmpty && !nameText.isEmpty && !descriptionText.isEmpty
    }
    
    // Update the data when editing and call the method in viewDidLoad.
    private func updateUI() {
        emojiTextField.text = emoji.emoji
        nameTextField.text = emoji.name
        descriptionTextField.text = emoji.description
    }

    @IBAction func textChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    // Saving a new emoji.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "saveSegue" else { return }
        let emoji = emojiTextField.text ?? ""
        let name = nameTextField.text ?? ""
        let description = descriptionTextField.text ?? ""

        self.emoji = Emoji(emoji: emoji,
                           name: name,
                           description: description,
                           isFavourite: self.emoji.isFavourite)
    }
}
