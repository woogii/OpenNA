//
//  Extensions.swift
//  OpenNA
//
//  Created by TeamSlogup on 2017. 3. 23..
//  Copyright © 2017년 wook2. All rights reserved.
//

import Foundation
import UIKit

// MARK : - Extension Collection

extension String {
  
  func firstUppercaseCharacter()->String {
    return String(self.characters.prefix(1)).uppercased()
  }
  
  subscript (i: Int) -> Character {
    guard i < characters.count else { return Character("") }
    return self[self.characters.index(self.startIndex, offsetBy: i)]
  }
  
  // Copyright © 2016년 minsone : http://minsone.github.io/mac/ios/linear-hangul-in-objective-c-swift
  
  var hangul: String {
    get {
      let hangle = [
        ["ㄱ","ㄲ","ㄴ","ㄷ","ㄸ","ㄹ","ㅁ","ㅂ","ㅃ","ㅅ","ㅆ","ㅇ","ㅈ","ㅉ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"],
        ["ㅏ","ㅐ","ㅑ","ㅒ","ㅓ","ㅔ","ㅕ","ㅖ","ㅗ","ㅘ","ㅙ","ㅚ","ㅛ","ㅜ","ㅝ","ㅞ","ㅟ","ㅠ","ㅡ","ㅢ","ㅣ"],
        ["","ㄱ","ㄲ","ㄳ","ㄴ","ㄵ","ㄶ","ㄷ","ㄹ","ㄺ","ㄻ","ㄼ","ㄽ","ㄾ","ㄿ","ㅀ","ㅁ","ㅂ","ㅄ","ㅅ","ㅆ","ㅇ","ㅈ","ㅊ","ㅋ","ㅌ","ㅍ","ㅎ"]
      ]
      
      return characters.reduce("") { result, char in
        if case let code = Int(String(char).unicodeScalars.reduce(0){$0.0 + $0.1.value}) - 44032, code > -1 && code < 11172 {
          let cho = code / 21 / 28, jung = code % (21 * 28) / 28, jong = code % 28;
          return result + hangle[0][cho] + hangle[1][jung] + hangle[2][jong]
        }
        return result + String(char)
      }
    }
  }

  
}

// MARK : - UIViewController Extension

extension UIViewController {
  
  // MARK : - Get a reference of the previousViewController
  func previousViewController() -> UIViewController? {
    if let stack = self.navigationController?.viewControllers {
      for i in (1..<stack.count).reversed() {
        if(stack[i] == self) {
          return stack[i-1]
        }
      }
    }
    return nil
  }
}

