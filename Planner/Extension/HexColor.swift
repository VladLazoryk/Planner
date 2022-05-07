import Foundation
import UIKit

extension UIColor {
    
    static let colorCellWhite = UIColor().colorFromHex("#FFFFFF")
    static let colorCellRed = UIColor().colorFromHex("#FF7E79")
    static let colorCellOrange = UIColor().colorFromHex("#FF9300")
    static let colorCellYellow = UIColor().colorFromHex("#FFFC79")
    static let colorCellGreen = UIColor().colorFromHex("#008F00")
    static let colorCellLightBlue = UIColor().colorFromHex("#0096FF")
    static let colorCellBlue = UIColor().colorFromHex("#011993")
    static let colorCellPurple = UIColor().colorFromHex("#531B93")
    
    func colorFromHex(_ hex: String) -> UIColor {
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#") {
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6 {
            return UIColor.black
        }
        
        var rgb : UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&rgb)
        
        return UIColor.init(red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
                            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
                            blue: CGFloat(rgb & 0x0000FF) / 255.0,
                            alpha: 1.0)
        
    }
}
