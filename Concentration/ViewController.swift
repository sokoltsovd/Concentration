//
//  ViewController.swift
//  Concentration
//
//  Created by Dmitry Sokoltsov on 12.07.2021.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var game = ConcentrationGame(numberOfPairsOfCards: numberOfPairsOfCards)
    
    var numberOfPairsOfCards: Int {
        return (buttonCollection.count + 1) / 2
    }
    
    private var emojiCollection = "💀🐝💩🦄👾🤠👽🤖🤡👹🧚🏻‍♀️👑"

    func updateTouches() {
        //            Создаем словарь с атрибутами
                    let attributes: [NSAttributedString.Key: Any] = [
                        .strokeWidth: 5.0,
                        .strokeColor: UIColor.red
                    ]
        //            Создаем стринг с атрибутами
                    let attributedString = NSAttributedString(string: "Touches: \(touches)", attributes: attributes)
                    touchLabel.attributedText = attributedString
    }
    
//    didset будет запускаться только когда знаечение нажатий будет изменено с 0 на 1 и т.д.
    private(set) var touches = 0 {
        didSet {
            updateTouches()
        }
    }
    
    private var emojiDictionary = [Card:String]()
    
    private func emojiIdentifier(for card: Card) -> String {
        if emojiDictionary[card] == nil {
            let randomStringIndex = emojiCollection.index(emojiCollection.startIndex, offsetBy: emojiCollection.count.arc4randomExtension)
            emojiDictionary[card] = String(emojiCollection.remove(at: randomStringIndex))
        }
        return emojiDictionary[card] ?? "?"
    }
    
    private func updateViewFromModel() {
        for index in buttonCollection.indices {
            let button = buttonCollection[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emojiIdentifier(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0, green: 0.03217588738, blue: 1, alpha: 0) : #colorLiteral(red: 0.6644750834, green: 0.9731798768, blue: 1, alpha: 1)
            }
        }
    }
    
    
    @IBOutlet private var buttonCollection: [UIButton]!
    @IBOutlet private weak var touchLabel: UILabel! {
        didSet {
            updateTouches()
        }
    }
    @IBAction private func buttonAction(_ sender: UIButton) {
        touches += 1
        if let buttonIndex = buttonCollection.firstIndex(of: sender) {
            game.chooseCard(at: buttonIndex)
            updateViewFromModel()
        }
    }
}


// Расширение для рандомного числа
extension Int {
    var arc4randomExtension: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}
