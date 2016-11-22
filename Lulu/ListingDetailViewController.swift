//
//  ListingDetailViewController.swift
//  Lulu
//
//  Created by Scott Campbell on 11/21/16.
//  Copyright © 2016 Team Lulu. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth
import Alamofire
import AlamofireImage

class ListingDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var listingImageView: UIImageView!
    @IBOutlet weak var listingTitleLabel: UILabel!
    @IBOutlet weak var listingDescriptionLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profileRating: RatingControl!
    
    @IBOutlet weak var bidValueTextField: UITextField!
    @IBOutlet weak var placeBidButton: UIButton!
    
    // MARK: - Properties
    var listing: Listing?
    var ref: FIRDatabaseReference?
    
    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get a reference to the firebase db and storage
        ref = FIRDatabase.database().reference()
        
        bidValueTextField.delegate = self
    
        // Setup the toolbar for the bidding textview
        let numberToolbar = UIToolbar()
        numberToolbar.barStyle = UIBarStyle.default
        
        numberToolbar.setItems([
            UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ListingDetailViewController.cancelPressed)),
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(ListingDetailViewController.donePressed))
            ], animated: false)
        
        numberToolbar.isUserInteractionEnabled = true
        numberToolbar.sizeToFit()
        
        bidValueTextField.inputAccessoryView = numberToolbar
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        placeBidButton.layer.cornerRadius = 5.0
        
        if let listing = listing {
            listingImageView.af_setImage(withURL: listing.photos[0])
            listingTitleLabel.text = listing.title
            listingDescriptionLabel.text = listing.description
            
            profileImageView.image = listing.seller.profileImage
            profileNameLabel.text = "\(listing.seller.firstName!) \(listing.seller.lastName!)"
            
            // TODO: Implement ratings for sellers.
            profileRating.rating = 3
            
            for button in profileRating.ratingButtons{
                button.isUserInteractionEnabled = false
            }
        }
    }
    
    func donePressed(){
        view.endEditing(true)
    }
    
    func cancelPressed(){
        view.endEditing(true) // or do something
    }
    
    @IBAction func placeBidPress(_ sender: Any) {
        // Check mif the user placed a bid value in the text field
        if let bidAmount = Double(bidValueTextField.text!) {
            print("user placed bid of \(bidAmount)")
            
            //TODO: Validate input of price
            
            let listingID = listing?.listingID
            
            let listingRef = ref?.child("listings").child(listingID!)
            
            listingRef?.observeSingleEvent(of: .value, with: {snapshot in
                //Check if bid table exists
                if snapshot.hasChild("bids"){
                    let bidsRef = listingRef?.child("bids").childByAutoId()
                    
                    bidsRef?.child("bidderID").setValue(FIRAuth.auth()?.currentUser?.uid)
                    bidsRef?.child("amount").setValue(bidAmount)
                    bidsRef?.child("createdTimestamp").setValue(FIRServerValue.timestamp())
                }
                else {
                    // TODO: bids table is missing should never happen
                }
            })
        }
        bidValueTextField.text = ""
    }
    
}

// MARK: - UITextFieldDelegate
extension ListingDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // TODO: deal with this in some way
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // TODO: deal with this in some way
    }
}
