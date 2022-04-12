import UIKit
@IBDesignable
class HeaderView: UIView
{

    @IBInspectable var cornerRadius: CGFloat = 0.0 {
            didSet {
                self.layer.cornerRadius = cornerRadius
            }
        }
}
