//
//  ThemeViewController.swift
//  Assignment3
//
//  Created by Andrew Pender on 23/5/20.
//  Copyright © 2020 Andrew Pender. All rights reserved.
//

import UIKit

class ThemeViewController: UIViewController {
    private let emojiThemes = [
        ConcentrationTheme(name: "default", emojis: ["🍕", "🎸", "🧘", "🚴‍♂️", "🤖", "👽", "🐮", "🐱", "👻"]),
        ConcentrationTheme(name: "animals", emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐵", "🐸", "🐽", "🐷", "🐔", "🐧"])]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton {
                if let cvc = segue.destination as? ConcentrationViewController {
                    cvc.emojiChoices = emojiThemes[button.tag].emojis
                    print(emojiThemes[button.tag].emojis)
                    cvc.title = button.currentTitle
                }
            }
        }
    }

}
