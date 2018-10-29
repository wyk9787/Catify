//
//  PhotoTableViewCell.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/28/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

class PhotoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
