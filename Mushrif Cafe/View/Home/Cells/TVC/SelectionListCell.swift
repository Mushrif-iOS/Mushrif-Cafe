//
//  SelectionListCell.swift
//  Mushrif Cafe
//
//  Created by Bhushan Kumar on 02/10/24.
//

import UIKit

class SelectionListCell: UITableViewCell {
    
    @IBOutlet var titleImg: UIImageView!
    
    @IBOutlet var titleLabel: UILabel! {
        didSet {
            titleLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    
    @IBOutlet var priceLabel: UILabel! {
        didSet {
            priceLabel.font = UIFont.poppinsMediumFontWith(size: 17)
        }
    }
    
    @IBOutlet var tickButton: UIButton!
    
    var selectionImage: UIImage?
    var deselectionImage: UIImage?
    var isSelectionMarkTrailing = true
    
    func updateSelectionAppearance() {
        if let selectionImage = selectionImage {
            if isSelectionMarkTrailing {
                if isSelected {
                    //accessoryView = UIImageView(image: selectionImage)
                    tickButton.setImage(selectionImage, for: .normal)
                } else {
                    if let deselectionImage = deselectionImage {
                        //accessoryView = UIImageView(image: deselectionImage)
                        tickButton.setImage(deselectionImage, for: .normal)
                    } else {
                        //accessoryView = nil
                        tickButton.setImage(nil, for: .normal)
                    }
                }
            } else {
                if isSelected {
                    //imageView?.image = selectionImage
                    tickButton.setImage(selectionImage, for: .normal)
                } else {
                    if let deselectionImage = deselectionImage {
                        //imageView?.image = deselectionImage
                        tickButton.setImage(deselectionImage, for: .normal)
                    } else {
                        //imageView?.image = UIImage.emptyImage(size: selectionImage.size)
                        tickButton.setImage(UIImage.emptyImage(size: selectionImage.size), for: .normal)
                    }
                }
            }
        } else {
            accessoryType = isSelected ? .checkmark : .none
        }
    }
    
//    private var imageViewOriginX = CGFloat(0)
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        guard var imageViewFrame = imageView?.frame else { return }
//        
//        // re-entrance guard
//        if 0 == imageViewOriginX {
//            imageViewOriginX = imageViewFrame.origin.x
//        }
//        
//        imageViewFrame.origin.x = imageViewOriginX + CGFloat(indentationLevel) * indentationWidth
//        imageView?.frame = imageViewFrame
//    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        updateSelectionAppearance()
    }
    
    override var isSelected: Bool {
        didSet {
            updateSelectionAppearance()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        updateSelectionAppearance()
    }
    
//    override var accessibilityTraits: UIAccessibilityTraits {
//        get {
//            if isSelected {
//                return super.accessibilityTraits.union(.selected)
//            }
//            return super.accessibilityTraits
//        }
//        set {
//            super.accessibilityTraits = newValue
//        }
//    }
}
