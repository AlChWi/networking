//
//  NotificationView.swift
//  networking
//
//  Created by Alex P on 08/08/2019.
//  Copyright © 2019 Алексей Перов. All rights reserved.
//

import UIKit

class NotificationView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func configureMessage(_ messageText: String) {
        messageLabel.text = messageText
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder
        )
        commonInit()
    }
    private func commonInit() {
        Bundle.main.loadNibNamed("NotificationView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    @IBAction func dismissAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}
