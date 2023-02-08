//
//  ResultViewController.swift
//  PersonalityQuiz
//
//  Created by Jevgeni Vakker on 23.10.2022.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet var resultAnswerLabel: UILabel!
    @IBOutlet var resultDefinationLabel: UILabel!
    
    var responses: [Answer]
    init?(coder: NSCoder, responses: [Answer]) {
        self.responses = responses
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculatePersonalityResult()
        navigationItem.hidesBackButton = true
    }
    
    func calculatePersonalityResult() {
        let frequencyOfAnswers = responses.reduce(into: [:]) {
            (counts, answer) in
            counts[answer.type, default: 0] += 1
        }
        
        let mostCommonAnswer = frequencyOfAnswers.sorted { $0.1 > $1.1 }.first!.key
        
        resultAnswerLabel.text = "You are a \(mostCommonAnswer.rawValue)!"
        resultDefinationLabel.text = mostCommonAnswer.definition
        
    }
    


}
