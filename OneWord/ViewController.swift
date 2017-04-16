//
//  ViewController.swift
//  OneWord
//
//  Created by Songbai Yan on 15/03/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let word1 = Word(text: "abandon", soundmark: "[ə'bændən]", partOfSpeech: "vt.", paraphrase: "丢弃，放弃，抛弃")
        
        let wordLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 40))
        wordLabel.textColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1)
        wordLabel.font = UIFont.systemFont(ofSize: 24)
        wordLabel.text = word1.text;
        self.view.addSubview(wordLabel)
        wordLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(78)
            maker.width.equalTo(self.view).offset(-156)
            maker.top.equalTo(self.view).offset(60)
        }
        
        let soundmarkLabel = UILabel(frame: CGRect(x: 0, y: 100, width: self.view.frame.width, height: 40))
        soundmarkLabel.text = word1.soundmark
        soundmarkLabel.textColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
        self.view.addSubview(soundmarkLabel)
        soundmarkLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(self.view).offset(78)
            maker.width.equalTo(self.view).offset(-156)
            maker.top.equalTo(wordLabel.snp.bottom).offset(20)
        }
        
        let partOfSpeechLabel = UILabel()
        partOfSpeechLabel.textColor = UIColor.white
        partOfSpeechLabel.textAlignment = .center
        partOfSpeechLabel.layer.cornerRadius = 5
        partOfSpeechLabel.layer.backgroundColor = UIColor(red: 74/255, green: 144/255, blue: 226/255, alpha: 1).cgColor
        partOfSpeechLabel.text = word1.partOfSpeech
        partOfSpeechLabel.font = UIFont.systemFont(ofSize: 15)
        self.view.addSubview(partOfSpeechLabel)
        partOfSpeechLabel.snp.makeConstraints { (maker) in
            maker.width.equalTo(25)
            maker.height.equalTo(25)
            maker.left.equalTo(self.view).offset(78)
            maker.top.equalTo(soundmarkLabel.snp.bottom).offset(20)
        }
        
        let paraphraseLabel = UILabel(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: 40))
        paraphraseLabel.text = word1.paraphrase
        paraphraseLabel.font = UIFont.systemFont(ofSize: 17)
        paraphraseLabel.numberOfLines = 0
        paraphraseLabel.textColor = UIColor(red: 66/255, green: 66/255, blue: 66/255, alpha: 1)
        self.view.addSubview(paraphraseLabel)
        paraphraseLabel.snp.makeConstraints { (maker) in
            maker.left.equalTo(partOfSpeechLabel.snp.right).offset(10)
            maker.width.equalTo(self.view).offset(-156)
            maker.centerY.equalTo(partOfSpeechLabel)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

