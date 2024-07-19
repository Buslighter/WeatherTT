import UIKit

class AnimationView: UIView, Animation {
    func setupAnimation() {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupAnimation()
    }
    
}



protocol Animation {
    func setupAnimation()
}
