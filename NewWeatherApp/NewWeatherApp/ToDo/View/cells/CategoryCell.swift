//
//  CategoryCell.swift
//  MonkeyDo
//
//  Created by Anja Seidel on 30.06.23.
//

import UIKit
import Combine

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var numView: UIView!
    @IBOutlet weak var checkImage: UIImageView!
    private var cancellables = Set<AnyCancellable>()
    
    var viewModel : CategoryCellViewModel! {
        didSet{
            bind(viewModel.outputs)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = cellView.frame.height / 2.7
           }

    func bind(_ outputs: CategoryCellOutputType){
        
        outputs
            .title
            .sink{ [weak self] number in
                self?.label.text = number
            }
            .store(in: &cancellables)
        outputs
            .isCompleted
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] isCompleted in

                self?.checkImage.image = UIImage(systemName: isCompleted ? "checkmark.square":"square")
            }
            .store(in: &cancellables)
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
