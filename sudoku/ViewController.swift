//
//  ViewController.swift
//  sudoku
//
//  Created by Moinuddin Girach on 29/11/21.
//

import UIKit

class ViewController: UIViewController {

    let a = GameManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        a.createGame()
        var x = 10
        var y = 100
        for i in 0..<9 {
            for j in 0..<9 {
            let lbl = UITextField(frame: CGRect(x: x, y: y, width: 30, height: 30 ))
                lbl.delegate = self
                lbl.textColor = a[i, j] == 0 ? .black : .blue
                lbl.textAlignment = .center
                lbl.keyboardType = .numberPad
                lbl.text = a[i,j] == 0 ? "" : "\(a[i, j])"
                lbl.isUserInteractionEnabled = a[i, j] == 0
                lbl.layer.borderColor = UIColor.black.cgColor
                lbl.layer.borderWidth = 1
                lbl.tag = i * 10 + j
                self.view.addSubview(lbl)
                x += (30 + (j % 3 == 2 ? 2 : 0))
            }
            x = 10
            y += (30 + (i % 3 == 2 ? 2 : 0))
        }
        
        let buttonUndo = UIButton(type: .custom)
        buttonUndo.frame = CGRect(x: 10, y: y + 10, width: 70, height: 30)
        buttonUndo.setTitle("undo", for: .normal)
        buttonUndo.setTitleColor(.black, for: .normal)
        buttonUndo.addTarget(self, action: #selector(undo), for: .touchUpInside)
        self.view.addSubview(buttonUndo)
        
        
        let buttonRedo = UIButton(type: .custom)
        buttonRedo.frame = CGRect(x: 100, y: y + 10, width: 70, height: 30)
        buttonRedo.setTitle("redo", for: .normal)
        buttonRedo.setTitleColor(.black, for: .normal)
        buttonRedo.addTarget(self, action: #selector(redo), for: .touchUpInside)
        self.view.addSubview(buttonRedo)
        
        let buttonErase = UIButton(type: .custom)
        buttonErase.frame = CGRect(x: 200, y: y + 10, width: 70, height: 30)
        buttonErase.setTitle("erase", for: .normal)
        buttonErase.setTitleColor(.black, for: .normal)
        buttonErase.addTarget(self, action: #selector(eraase), for: .touchUpInside)
        self.view.addSubview(buttonErase)
    }

    @objc func undo(sender: UIButton) {
        if let val = a.undo() {
            if let text = self.view.viewWithTag(val.row * 10 + val.col) as? UITextField {
                text.text = val.value == 0 ? "" : "\(val.value)"
            }
        }
    }
    
    @objc func redo(sender: UIButton) {
        if let val = a.redo() {
            if let text = self.view.viewWithTag(val.row * 10 + val.col) as? UITextField {
                text.text = val.value == 0 ? "" : "\(val.value)"
            }
        }
    }
    
    @objc func eraase(sender: UIButton) {
        if let tag = focousedText?.tag {
            let col = tag % 10
            let row = (tag - col) / 10
            a.eraseValue(row: row, col: col)
            if let text = self.view.viewWithTag(row * 10 + col) as? UITextField {
                text.text = ""
            }
        }
    }
    
    private var focousedText: UITextField?

}

extension ViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        focousedText = textField
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        focousedText = nil
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let col = textField.tag % 10
        let row = (textField.tag - col) / 10
        if let updatedString = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) {
            if let num = Int(updatedString), num > 0 && num < 10 {
                a.fillValue(value: num, row: row, col: col)
            } else {
                return false
            }

        }
        return true
    }
}
