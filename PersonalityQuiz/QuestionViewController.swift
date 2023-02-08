//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Jevgeni Vakker on 23.10.2022.
//

import UIKit

class QuestionViewController: UIViewController {
   
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    
    @IBOutlet var multipleStackView: UIStackView!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedLabel1: UILabel!
    @IBOutlet var rangedLabel2: UILabel!
    @IBOutlet var rangedSlider: UISlider!
    
    @IBOutlet var questionProgressView: UIProgressView!
    
    var questions: [Question] = [
        Question(
            text: "Which food do you like the most?",
            type: .single,
            answers: [
                Answer(text: "Steak", type: .dog),
                Answer(text: "Fish", type: .cat),
                Answer(text: "Carrots", type: .rabbit),
                Answer(text: "Corn", type: .turtle)].shuffled()
        ),
        
        Question(text: "Which activities do you enjoy?",
                 type: .multiple,
                 answers: [
                    Answer(text: "Swimming", type: .turtle),
                    Answer(text: "Sleeping", type: .cat),
                    Answer(text: "Cuddling", type: .rabbit),
                    Answer(text: "Eating", type: .dog)
                 ].shuffled()
                ),
        
        Question(text: "How much do you enjoy car rides?",
                 type: .ranged,
                 answers: [
                    Answer(text: "I dislike them", type: .cat),
                    Answer(text: "I get a little nervous", type: .rabbit),
                    Answer(text: "I barely notice them", type: .turtle),
                    Answer(text: "I love them", type: .dog)
                 ]
                )
    ].shuffled()
    
    var questionIndex = 0
    
    var answerChosen: [Answer] = []
    
    var multipleLabelSwitch: [UISwitch] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func singleAnswerButtonPressed(sender: UIButton) {
        let currentAnswers = questions[questionIndex].answers
        
        for i in Range(0...currentAnswers.count - 1) {
            if sender.titleLabel?.text == currentAnswers[i].text {
                answerChosen.append(currentAnswers[i])
            }
        }
       
        nextQuestion()
    }
    
    @IBAction func multipleAnswerButtonPressed(sender: Any) {
        let currentAnswers = questions[questionIndex].answers
        for i in Range(0...currentAnswers.count - 1) {
            if multipleLabelSwitch[i].isOn {
                answerChosen.append(currentAnswers[i])
                print(currentAnswers[i])
            }
        }
        
        nextQuestion()
    }
    
    
    @IBAction func rangedAnswerButtonPressed(_ sender: Any) {
        let currentAnswers = questions[questionIndex].answers
        let index = Int(rangedSlider.value * Float(currentAnswers.count - 1))
        
        answerChosen.append(currentAnswers[index])
        
        nextQuestion()
    }
    
    func updateUI() {
        singleStackView.isHidden = true
        multipleStackView.isHidden = true
        rangedStackView.isHidden = true
        
        singleStackView.subviews.forEach { $0.removeFromSuperview() }
        multipleStackView.subviews.forEach { $0.removeFromSuperview() }
        multipleLabelSwitch.removeAll()
        
        
        
        let currentQuestion = questions[questionIndex]
        let currentAnswer = currentQuestion.answers
        let totalProgress = Float(questionIndex) / Float(questions.count)
        
        navigationItem.title = "Question #\(questionIndex + 1)"
        questionLabel.text = currentQuestion.text
        questionProgressView.setProgress(totalProgress, animated: true)
        
        switch currentQuestion.type {
        case .single:
            updateSingleStack(using: currentAnswer)
        case .multiple:
            updateMultipleStack(using: currentAnswer)
        case .ranged:
            updateRangedStack(using: currentAnswer)
        }
        
    }
    
    @IBSegueAction func showResults(_ coder: NSCoder) -> ResultViewController? {
        return ResultViewController(coder: coder, responses: answerChosen)
    }
    
    func updateSingleStack(using answers: [Answer]) {
        for i in Range(0...answers.count - 1) {
            let button = UIButton(type: .system)
            button.titleLabel?.font = .systemFont(ofSize: 18)
            button.setTitle(answers[i].text, for: .normal)
            button.addTarget(self, action: #selector(singleAnswerButtonPressed(sender:)), for: .touchUpInside)
            singleStackView.addArrangedSubview(button)
        }
        singleStackView.isHidden = false
    }
    
    func updateMultipleStack(using answers: [Answer]) {
        multipleStackView.isHidden = false
        
        for i in Range(0...answers.count - 1) {
            let multiSwitch = UISwitch()
            let label = UILabel()
            let stackView = UIStackView()
            stackView.axis = .horizontal
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 8
            multiSwitch.isOn = false
            label.text = answers[i].text
            multipleLabelSwitch.append(multiSwitch)
            print(multipleLabelSwitch)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(multipleLabelSwitch[i])
            multipleStackView.addArrangedSubview(stackView)
        }
        
        let button = UIButton(type: .system)
        button.setTitle("Submit answer", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.addTarget(self, action: #selector(multipleAnswerButtonPressed(sender:)), for: .touchUpInside)
        multipleStackView.addArrangedSubview(button)
    }
    
    func updateRangedStack(using answers: [Answer]) {
        rangedStackView.isHidden = false
        rangedSlider.setValue(0.5, animated: false)
        rangedLabel1.text = answers.first?.text
        rangedLabel2.text = answers.last?.text
    }
    
    func nextQuestion() {
        questionIndex += 1
        if questionIndex < questions.count {
            updateUI()
        } else {
            performSegue(withIdentifier: "Results", sender: nil)
        }
    }
}
