//
//  FeedCell.swift
//  SnapchatApp
//
//  Created by Rusen Topcu on 20.11.2020.
//

import UIKit

class FeedCell: UITableViewCell {

    
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var feedUserNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
