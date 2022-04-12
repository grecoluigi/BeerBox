import UIKit
@IBDesignable
class HeaderView: UIView
{
    @IBInspectable var rectWidth:   CGFloat = 60
    @IBInspectable var rectHeight:  CGFloat = 40
    
    @IBInspectable var rectBgColor:     UIColor = UIColor.darkGray
    @IBInspectable var rectBorderColor: UIColor = UIColor.lightGray
    @IBInspectable var rectBorderWidth: CGFloat = 2
    @IBInspectable var rectCornerRadius:CGFloat = 5
        {
        didSet { print("cornerRadius was set here")
            invalidateIntrinsicContentSize()
        }
    }
    
    override func draw(_ rect: CGRect)
    {
        super.draw(rect)
        roundRect()
    }
  
    internal func roundRect()
    {
        let width = self.frame.width - 20
        let height = self.frame.height - 10
        let xf:CGFloat = (self.frame.width  - width)  / 2
        let yf:CGFloat = (self.frame.height - height) / 2

        
        let ctx: CGContext = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        
        ctx.setLineWidth(rectBorderWidth)
        ctx.setStrokeColor(rectBorderColor.cgColor)
        
        
        
        let rect = CGRect(x: xf, y: yf, width: width , height: height)
        let clipPath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: rectCornerRadius).cgPath
        let linePath: CGPath = UIBezierPath(roundedRect: rect, cornerRadius: rectCornerRadius).cgPath
        
        
        ctx.addPath(clipPath)
        ctx.setFillColor(rectBgColor.cgColor)
        ctx.closePath()
        ctx.fillPath()
        
        ctx.addPath(linePath)
        ctx.strokePath()
        
        ctx.restoreGState()
        
    }
    
}
