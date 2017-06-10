//
//  ViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    fileprivate let wordTextKey = "wordText"
    fileprivate let soundmarkKey = "soundmark"
    fileprivate let partOfSpeechKey = "partOfSpeech"
    fileprivate let paraphraseKey = "paraphrase"
    
    fileprivate let service = MainService()
    
    private var paintBoard:PaintView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "随记单词"
        self.view.backgroundColor = UIColor.white
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "about"), style: .plain, target: self, action: #selector(MainViewController.aboutClick(sender:)))
        
        initWordUI()
        initWriteBoardView()
    }
    
    private func initWriteBoardView(){
        let boardView = UIView()
        boardView.layer.shadowColor = UIColor.red.cgColor//UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
        boardView.layer.masksToBounds = false
//        boardView.layer.shadowOffset = CGSize(width: 500, height: 300)
        boardView.layer.shadowRadius = 5
        self.view.addSubview(boardView)
        boardView.snp.makeConstraints { (maker) in
            maker.bottom.equalTo(self.view)
            maker.left.equalTo(self.view)
            maker.right.equalTo(self.view)
            maker.height.equalTo(250)
        }
        
        paintBoard = PaintView(frame: boardView.frame)
        paintBoard.lineWidth = 2
        paintBoard.backgroundColor = UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        boardView.addSubview(paintBoard)
        paintBoard.snp.makeConstraints { (maker) in
            maker.top.equalTo(boardView)
            maker.left.equalTo(boardView)
            maker.right.equalTo(boardView)
            maker.bottom.equalTo(boardView)
        }
        
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "clear"), for: .normal)
        clearButton.addTarget(self, action: #selector(MainViewController.clearBoard(sender:)), for: .touchUpInside)
        boardView.addSubview(clearButton)
        clearButton.snp.makeConstraints { (maker) in
            maker.right.equalTo(boardView).offset(-10)
            maker.top.equalTo(boardView).offset(5)
        }
    }
    
    func aboutClick(sender: UIBarButtonItem){
        self.navigationController?.pushViewController(AboutViewController(), animated: true)
    }
    
    func clearBoard(sender:UIButton){
        paintBoard.cleanAll()
    }
    
    private func initWordUI(){
        //防止scrollview自适应navigationbar的高度，避免出现单词闪动的情况
        self.automaticallyAdjustsScrollViewInsets = false
        
        var barHeight:CGFloat = 0
        if let tempBarHeight = self.navigationController?.navigationBar.frame.height{
            barHeight = tempBarHeight
        }
        
        let statusBarHeight:CGFloat = 22
        let topOffset = barHeight + statusBarHeight
        let scrollViewHeight = self.view.bounds.height - topOffset
        
        let firstWord = service.getRandomWord()
        let firstWordView = WordView(frame: self.view.frame)
        firstWordView.wordLabel.text = firstWord.text
        firstWordView.soundmarkLabel.text = firstWord.soundmark
        firstWordView.partOfSpeechLabel.text = firstWord.partOfSpeech
        firstWordView.paraphraseLabel.text = firstWord.paraphrase
        
        var secondWord = service.getRandomWord()
        if let localFirstWord = getFirstWordFromLocalDefaults(){
            secondWord = localFirstWord
        }
        let secondWordView = WordView(frame: self.view.frame)
        secondWordView.wordLabel.text = secondWord.text
        secondWordView.soundmarkLabel.text = secondWord.soundmark
        secondWordView.partOfSpeechLabel.text = secondWord.partOfSpeech
        secondWordView.paraphraseLabel.text = secondWord.paraphrase
        
        let thirdWord = service.getRandomWord()
        let thirdWordView = WordView(frame: self.view.frame)
        thirdWordView.wordLabel.text = thirdWord.text
        thirdWordView.soundmarkLabel.text = thirdWord.soundmark
        thirdWordView.partOfSpeechLabel.text = thirdWord.partOfSpeech
        thirdWordView.paraphraseLabel.text = thirdWord.paraphrase
        
        let loopView = CircularlyPagedScrollView(frame: self.view.frame, viewsToRotate: [firstWordView, secondWordView, thirdWordView], scrollHorizontally: true)
        loopView.circularlyPagedDelegate = self
        loopView.contentSize = CGSize(width: self.view.bounds.width * CGFloat(3), height: scrollViewHeight)
        loopView.resetMiddleViewShown(middle: loopView.viewsToRotate[2])
        self.view.addSubview(loopView)
        loopView.snp.makeConstraints { (maker) in
            maker.width.equalTo(self.view)
            maker.height.equalTo(self.view)
            maker.left.equalTo(self.view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getFirstWordFromLocalDefaults() -> Word?{
        guard let wordText = UserDefaults.standard.string(forKey: wordTextKey) else{
            return nil
        }
        guard let soundmark = UserDefaults.standard.string(forKey: soundmarkKey) else{
            return nil
        }
        guard let partOfSpeech = UserDefaults.standard.string(forKey: partOfSpeechKey) else{
            return nil
        }
        guard let paraphrase = UserDefaults.standard.string(forKey: paraphraseKey) else{
            return nil
        }
        return Word(text: wordText, soundmark: soundmark, partOfSpeech: partOfSpeech, paraphrase: paraphrase)
    }
}

extension MainViewController : CircularlyPagedDelegate{
    func circularlyPagedScrollView(updated views: [UIView], view: CircularlyPagedScrollView) {
        if views.count > 2{
            if let thirdView = views[2] as? WordView{
                update(third: thirdView)
            }
            
            if let middleView = views[1] as? WordView{
                save(current: middleView.wordLabel.text, soundmark: middleView.soundmarkLabel.text, partOfSpeech: middleView.partOfSpeechLabel.text, paraphrase: middleView.paraphraseLabel.text)
            }
        }
    }
    
    private func save(current text:String?, soundmark:String?, partOfSpeech:String?, paraphrase:String?){
        UserDefaults.standard.set(text, forKey: wordTextKey)
        UserDefaults.standard.set(soundmark, forKey: soundmarkKey)
        UserDefaults.standard.set(partOfSpeech, forKey: partOfSpeechKey)
        UserDefaults.standard.set(paraphrase, forKey: paraphraseKey)
        UserDefaults.standard.synchronize()
    }
    
    private func update(third wordView:WordView){
        let thirdWord = service.getRandomWord()
        wordView.wordLabel.text = thirdWord.text
        wordView.soundmarkLabel.text = thirdWord.soundmark
        wordView.partOfSpeechLabel.text = thirdWord.partOfSpeech
        wordView.paraphraseLabel.text = thirdWord.paraphrase
    }
}

