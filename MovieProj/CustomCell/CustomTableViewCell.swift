//
//  CustomTableViewCell.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 28/03/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var movieTitle: UILabel?
    @IBOutlet weak var movieImageView: UIImageView?
    @IBOutlet weak var movieDate: UILabel?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
