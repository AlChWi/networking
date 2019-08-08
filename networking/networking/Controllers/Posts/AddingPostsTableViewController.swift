//
//  AddingPostsTableViewController.swift
//  networking
//
//  Created by Alex P on 08/08/2019.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

protocol AddingPostsDelegate: class {
    func addPost(post: Post)
    func editPost(post: Post, indexPath: IndexPath)
    func displayError()
}

class AddingPostsTableViewController: UITableViewController {
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var postTitleTextField: UITextField!
    @IBOutlet weak var postBodyTextView: UITextView! {
        didSet {
            postBodyTextView.delegate = self
        }
    }
    
    enum CallingCases {
        case editingPost
        case addingPost
    }
    private var post = Post(userId: 0, title: "nil", body: "nil")
    weak var delegate: AddingPostsDelegate?
    var indexPath: IndexPath?
    private var callingCase = CallingCases.addingPost
    
    override func viewWillAppear(_ animated: Bool) {
        if callingCase == .addingPost {
            self.title = "Add new post"
        } else {
            self.title = "Edit post info"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfSavePossible()
        
        if callingCase == .editingPost && post.id != 0 {
            self.postTitleTextField.text = post.title
            self.postBodyTextView.text = post.body
        } else if callingCase == .editingPost && post.id == 0 {
            delegate?.displayError()
            self.dismiss(animated: true, completion: nil)
        }
    }

    func checkIfSavePossible() {
        if post.userId != 0, post.title != "nil", post.body != "nil" {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
            print(post.body
            )
            print(post.title)
            print(post.id)
            print(post.userId)
        }
    }
    
    func adjustForAddingContext(user: User) {
        self.callingCase = .addingPost
        self.post.userId = user.id
    }
    func adjustForEditingContext(post: Post, indexPath: IndexPath) {
        self.callingCase = .editingPost
        self.post = post
        self.indexPath = indexPath
    }
 


    @IBAction func postTitleEditingChanged(_ sender: UITextField) {
        post.title = postTitleTextField.text ?? "nil"
        if let text = postTitleTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }
    }
    @IBAction func doneButtonTouched(_ sender: Any) {
        switch callingCase {
        case .addingPost:
            if let existingDelegate = delegate {
                existingDelegate.addPost(post: post)
            } else {
                
            }
            self.dismiss(animated: true, completion: nil)
        case .editingPost:
            if let existingDelegate = delegate, let existingPath = indexPath {
                existingDelegate.editPost(post: post, indexPath: existingPath)
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
extension AddingPostsTableViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        post.body = postBodyTextView.text ?? "nil"
        if let text = postBodyTextView.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }
    }
}
