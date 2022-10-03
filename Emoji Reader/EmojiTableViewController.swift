//
//  TableViewController.swift
//  Emoji Reader
//
//  Created by iggy on 1.09.22.
//

import UIKit

class EmojiTableViewController: UITableViewController {
    
    // Create an object according to the data model.
    var objects = [Emoji(emoji: "🥰",
                         name: "Love",
                         description: "Lets love each other",
                         isFavourite: false),
                   Emoji(emoji: "👊🏻",
                         name: "Figt Club",
                         description: "The first rule of Fight Club is ...",
                         isFavourite: false),
                   Emoji(emoji: "😺",
                         name: "Cat",
                         description: "Cat is cutest animal",
                         isFavourite: false)]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Emoji Reader"
        self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // Transition from newEmoji screen.
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        // Save new emoji.
        guard segue.identifier == "saveSegue" else { return }
        let sourceVC = segue.source as! NewEmojiTableViewController
        let emoji = sourceVC.emoji
        
        // Еdit old emoji and save it.
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            objects[selectedIndexPath.row] = emoji
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
        } else {
            // Add a new emoji to the end of the list.
            let newIndexPath = IndexPath(row: objects.count, section: 0)

            objects.append(emoji)
            tableView.insertRows(at: [newIndexPath], with: .fade)
        }
    }
    
    // Edit emoji.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard segue.identifier == "editEmoji" else { return }
        let indexPath = tableView.indexPathForSelectedRow!
        let emoji = objects[indexPath.row]
        
        // Getting to the edit screen.
        let navigationVC = segue.destination as! UINavigationController
        let newEmojiVC = navigationVC.topViewController as! NewEmojiTableViewController
        newEmojiVC.emoji = emoji
        newEmojiVC.title = "Edit"
    }
    
    // MARK: - Table view data source
        override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return objects.count
    }

        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "emojiCell", for: indexPath) as! EmojiTableViewCell
            let object = objects[indexPath.row]
            cell.set(object: object)

        // Getting text in a cell.
//        var content = cell.defaultContentConfiguration()
//        content.text = "\(indexPath)"
//        cell.contentConfiguration = content
            
        // Changing UI elements directly through a cell.
//       cell.emojiLabel.text = "🥹"
        
        return cell
    }
    
    // Deleting a cell
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
            return .delete
    }

    // Deleting a cell.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            objects.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // Making Cells Moveable.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Navigation.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedEmoji = objects.remove(at: sourceIndexPath.row) // Add element in memory by sourceIndexPath and remove it.
        objects.insert(movedEmoji, at: destinationIndexPath.row) // Get the removed element and store it in the recipient's IndexPath.
        tableView.reloadData()
    }
    
    // Create a left swipeAction.
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let done = doneAction(at: indexPath)
        let favourtite = favourteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [done, favourtite])
    }
    
    // Implementing the delete method in leadingSwipeAction with default button name.
    func doneAction(at indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Done") { action, view, completion in
            self.objects.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        // Costomized button
        action.backgroundColor = .systemGreen
        action.image = UIImage(systemName: "checkmark.circle")
        return action
    }
    
    // FavouriteAction
    func favourteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = objects[indexPath.row]
        let action = UIContextualAction(style: .normal, title: "Favourite") { action, view, completion in
            object.isFavourite = !object.isFavourite
            self.objects[indexPath.row] = object
            completion(true)
        }
        
        // Costomized FavouriteAction
        action.backgroundColor = object.isFavourite ? .systemPurple : .systemGray
        action.image = UIImage(systemName: "heart")
        return action
    }
}
