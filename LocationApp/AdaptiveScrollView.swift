 /*
  * AdaptiveScrollView.swift
  * Assign 1
  *
  * Code found at https://useyourloaf.com/blog/split-views-and-unexpected-keyboards/
  * Original Author: Keith Harrison
  * November 22, 2015
  *
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  * http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  *
  * Purpose: To allow for scrolling of the add and edit screens
  *         to account for the keyboard when it appears
  *
  *
  * @author Justin Greene  mailto:jagree19@asu.edu
  * @version April 2018
  */
 
 import UIKit
 
 class AdaptiveScrollView: UIScrollView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardDidShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let keyboardSize = keyboardFrame.cgRectValue.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        adjustContentInsets(contentInsets: contentInsets)
    }
    
    private func adjustContentInsets(contentInsets: UIEdgeInsets) {
        contentInset = contentInsets
        scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustContentInsets(contentInsets: .zero)
    }
 }
