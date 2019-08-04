//
//  AddingUsersTableViewController.swift
//  networking
//
//  Created by Алексей Перов on 8/3/19.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

protocol AddingUsersDelegate: class {
    func addUser(user: User)
    func editUser(user: User, indexPath: IndexPath)
    func displayError()
}

class AddingUsersTableViewController: UITableViewController {
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var suiteTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var zipcodeTextField: UITextField!
    @IBOutlet weak var geolngTextField: UITextField!
    @IBOutlet weak var geolatTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var companyPhraseTextField: UITextField!
    @IBOutlet weak var companyBSTextField: UITextField!
    
    enum CallingCases {
        case editingUser
        case addingUser
    }
    
    private var user = User(name: "nil", username: "nil", email: "nil", address: Address(street: "nil", suite: "nil", city: "nil", zipcode: "nil", geo: Geo(lat: "nil", lng: "nil")), phone: "nil", website: "nil", company: Company(name: "nil", catchPhrase: "nil", bs: "nil"))
    weak var delegate: AddingUsersDelegate?
    var indexPath: IndexPath?
    private var callingCase = CallingCases.addingUser
    
    override func viewWillAppear(_ animated: Bool) {
        if callingCase == .addingUser {
            self.title = "Add new user"
        } else {
            self.title = "Edit user info"
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkIfSavePossible()
        
        if callingCase == .editingUser && user.id != 0 {
            self.nameTextField.text = user.name
            self.usernameTextField.text = user.username
            self.emailTextField.text = user.email
            self.phoneTextField.text = user.phone
            self.websiteTextField.text = user.website
            self.streetTextField.text = user.address.street
            self.suiteTextField.text = user.address.suite
            self.cityTextField.text = user.address.city
            self.zipcodeTextField.text = user.address.zipcode
            self.geolatTextField.text = user.address.geo.lat
            self.geolngTextField.text = user.address.geo.lng
            self.companyNameTextField.text = user.company.name
            self.companyPhraseTextField.text = user.company.catchPhrase
            self.companyBSTextField.text = user.company.bs
        } else if callingCase == .editingUser && user.id == 0 {
            delegate?.displayError()
            self.dismiss(animated: true, completion: nil)
        }
    }

    func adjustForEditingContext(user: User, indexPath: IndexPath) {
            self.callingCase = .editingUser
            self.user = user
            self.indexPath = indexPath
    }
    
    func checkIfSavePossible() {
        if user.name != "nil" && user.username != "nil" && user.email != "nil"  && user.phone != "nil" && user.website != "nil" && user.address.street != "nil" && user.address.city != "nil" && user.address.zipcode != "nil" && user.address.geo.lng != "nil" && user.address.geo.lat != "nil" && user.company.name != "nil" && user.company.catchPhrase != "nil" && user.company.bs != "nil" {
            doneButton.isEnabled = true
        } else {
            doneButton.isEnabled = false
            print(user)
        }
    }
    
    @IBAction func cancelButtonWasTapped(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true)
    }
    @IBAction func doneButtonWasTouched(_ sender: Any) {
        switch callingCase {
        case .addingUser:
            if let existingDelegate = delegate {
                existingDelegate.addUser(user: user)
            } else {
                
            }
            self.dismiss(animated: true, completion: nil)
        case .editingUser:
            if let existingDelegate = delegate, let existingPath = indexPath {
                existingDelegate.editUser(user: user, indexPath: existingPath)
            } else {
                
            }
            self.dismiss(animated: true, completion: nil)
        default:
            return
        }
    }
    @IBAction func nameTFEditingChanged(_ sender: UITextField) {
        user.name = nameTextField.text ?? "nil"
        if let text = nameTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func usernameTFEditingChanged(_ sender: UITextField) {
        user.username = usernameTextField.text ?? "nil"
        if let text = usernameTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func emailTFEditingChanged(_ sender: UITextField) {
        user.email = emailTextField.text ?? "nil"
        if let text = emailTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func phoneTFEditingChanged(_ sender: UITextField) {
        user.phone = phoneTextField.text ?? "nil"
        if let text = phoneTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }
    }
    @IBAction func websiteTFEditingChanged(_ sender: UITextField) {
        user.website = websiteTextField.text ?? "nil"
        if let text = websiteTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func streetTFEditingChanged(_ sender: UITextField) {
        user.address.street = streetTextField.text ?? "nil"
        if let text = streetTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func suiteTFEditingChanged(_ sender: UITextField) {
        user.address.suite = suiteTextField.text ?? "nil"
        if let text = suiteTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func cityTFEditingChanged(_ sender: UITextField) {
        user.address.city = cityTextField.text ?? "nil"
        if let text = cityTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func zipcodeTFEditingChanged(_ sender: UITextField) {
        user.address.zipcode = zipcodeTextField.text ?? "nil"
        if let text = zipcodeTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func geolngTFEditingChanged(_ sender: UITextField) {
        user.address.geo.lng = geolngTextField.text ?? "nil"
        if let text = geolngTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func geolatTFEditingChanged(_ sender: UITextField) {
        user.address.geo.lat = geolatTextField.text ?? "nil"
        if let text = geolatTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func companyNameTFEditingChanged(_ sender: UITextField) {
        user.company.name = companyNameTextField.text ?? "nil"
        if let text = companyNameTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func companyPhraseTFEditingChanged(_ sender: UITextField) {
        user.company.catchPhrase = companyPhraseTextField.text ?? "nil"
        if let text = companyPhraseTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    @IBAction func companyBSEditingChanged(_ sender: UITextField) {
        user.company.bs = companyBSTextField.text ?? "nil"
        if let text = companyBSTextField.text, !text.isEmpty {
            checkIfSavePossible()
        } else {
            doneButton.isEnabled = false
        }    }
    
}
