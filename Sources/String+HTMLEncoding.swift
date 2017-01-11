
import Foundation

public extension String {
  func removingHTMLEncoding() -> String {
    let result = self.replacingOccurrences(of: "+", with: " ")
    return result.removingPercentEncoding ?? result
  }
}
