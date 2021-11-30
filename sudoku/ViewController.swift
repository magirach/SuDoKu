//
//  ViewController.swift
//  sudoku
//
//  Created by Moinuddin Girach on 29/11/21.
//

import UIKit

class ViewController: UIViewController {

    let a = Sudoku()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let b = a.createPuzzle(difficulty: 5)
        var x = 10
        var y = 100
        for i in 0..<9 {
            for j in 0..<9 {
            let lbl = UITextField(frame: CGRect(x: x, y: y, width: 30, height: 30 ))
                lbl.delegate = self
                lbl.textColor = b[i][j] == 0 ? .black : .blue
                lbl.textAlignment = .center
                lbl.keyboardType = .numberPad
                lbl.text = b[i][j] == 0 ? "" : "\(b[i][j])"
                lbl.isUserInteractionEnabled = b[i][j] == 0
                lbl.layer.borderColor = UIColor.black.cgColor
                lbl.layer.borderWidth = 1
                lbl.tag = i * 10 + j
                self.view.addSubview(lbl)
                x += (30 + (j % 3 == 2 ? 2 : 0))
            }
            x = 10
            y += (30 + (i % 3 == 2 ? 2 : 0))
        }
    }


}

extension ViewController: UITextFieldDelegate {
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let col = textField.tag % 10
        let row = (textField.tag - col) / 10
        if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            if let num = Int(updatedString), num > 0 {
                let valid = a.addNumber(number: num, row: row, col: col)
                return valid
            }

        }
        return true
    }
}

