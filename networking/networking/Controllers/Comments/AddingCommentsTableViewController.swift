//
//  AddingCommentsTableViewController.swift
//  networking
//
//  Created by Alex P on 08/08/2019.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

protocol AddingCommentsDelegate: class {
    func addComment(comment: Comment)
    func editComment(comment: Comment, indexPath: IndexPath)
    func displayError()
}

class AddingCommentsTableViewController: UITableViewController {
    @IBOutlet weak var commentTitleTextField: UITextField!
    @IBOutlet weak var commentBodyTextView: UITextView! {
        didSet {
            commentBodyTextView.delegate = self
        }
    }
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    enum CallingCases {
        case editingComment
        case addingComment
    }
    private var comment = Comment(postId: 0, name: "nil", email: "nil", body: "nil")
    weak var delegate: AddingCommentsDelegate?
    var indexPath: IndexPath?
    private var callingCase = CallingCases.addingComment
    
    override func viewWillAppear(_ animated: Bool) {
        if callingCase == .addingComment {
            self.title = "Add new comment"
        } else {
            self.title = "Edit comment info"
        }
    }
    func checkIfSavePossible() {
        if comment.postId != 0, comment.name != "nil", comment.body != "nil", comment.email != "nil" {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
            print(comment.body
            )
            print(comment.name)
            print(comment.postId)
            print(comment.id)
            print(comment.email)
        }
    }
    func adjustForAddingContext(post: Post, user: User) {
        self.callingCase = .addingComment
        self.comment.postId = post.id
        self.comment.email = user.email
    }
    func adjustForEditingContext(comment: Comment, indexPath: IndexPath) {
        self.callingCase = .editingComment
        self.comment = comment
        self.indexPath = indexPath
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfSavePossible()
        
        if callingCase == .editingComment && comment.id != 0 {
            self.commentTitleTextField.text = comment.name
            self.commentBodyTextView.text = comment.body
        } else if callingCase == .editingComment && comment.id == 0 {
            delegate?.displayError()
            self.dismiss(animated: true, completion: nil)
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func titleTextFieldEditingChanged(_ sender: UITextField) {
        comment.name = commentTitleTextField.text ?? "nil"
        if let text = commentTitleTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }
    }
    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        switch callingCase {
        case .addingComment:
            if let existingDelegate = delegate {
                existingDelegate.addComment(comment: comment)
            } else {
                
            }
            self.dismiss(animated: true, completion: nil)
        case .editingComment:
            if let existingDelegate = delegate, let existingPath = indexPath {
                existingDelegate.editComment(comment: comment, indexPath: existingPath)
            } else {
                
            }
            self.dismiss(animated: true, completion: nil)
            //        default:
            //            return
        }
    }
    @IBAction func close(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension AddingCommentsTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        comment.body = commentBodyTextView.text ?? "nil"
        if let text = commentBodyTextView.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }
    }
}
