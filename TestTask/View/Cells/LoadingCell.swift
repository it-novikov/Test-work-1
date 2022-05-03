//
//  LoadingCellTableViewCell.swift
//  TestTask
//
//  Created by Vadim Novikov on 18.04.2022.
//

import UIKit

class LoadingCell: UITableViewCell {
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
