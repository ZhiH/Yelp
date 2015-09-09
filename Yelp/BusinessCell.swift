//
//  BusinessCell.swift
//  Yelp
//
//  Created by Zhi Huang on 9/6/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessCell: UITableViewCell {
    @IBOutlet weak var businessAvatarView: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var businessRatingView: UIImageView!
    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!

    var business: Business! {
        didSet {
            businessNameLabel.text = business.name
            distanceLabel.text = business.distance
            if (business.reviewCount?.integerValue < 2) {
                reviewsLabel.text = "\(business.reviewCount!) review"
            } else {
                reviewsLabel.text = "\(business.reviewCount!) reviews"
            }
            addressLabel.text = business.address
            categoryLabel.text = business.categories

            businessAvatarView.setImageWithURL(business.imageURL)
            businessRatingView.setImageWithURL(business.ratingImageURL)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        businessAvatarView.layer.cornerRadius = 5
        businessAvatarView.clipsToBounds = true
        businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
        addressLabel.preferredMaxLayoutWidth = addressLabel.frame.size.width
        categoryLabel.preferredMaxLayoutWidth = categoryLabel.frame.size.width
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        businessNameLabel.preferredMaxLayoutWidth = businessNameLabel.frame.size.width
        addressLabel.preferredMaxLayoutWidth = addressLabel.frame.size.width
        categoryLabel.preferredMaxLayoutWidth = categoryLabel.frame.size.width
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
