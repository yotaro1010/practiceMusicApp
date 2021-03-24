//
//  PlayerViewController.swift
//  musicApp
//
//  Created by Yotaro Ito on 2020/12/11.
//
import AVFoundation
import UIKit

class PlayerViewController: UIViewController {

//   どの曲が選択されたか
    public var position: Int = 0
    public var quotes: [Quotes] = []
    
    var player: AVAudioPlayer?
    
    private let quoteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let quoteLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let characterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let movieLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let playPauseButton = UIButton()
    
    @IBOutlet var holder: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if holder.subviews.count == 0 {
            configure()
        }
    }
    func configure() {
        let quote = quotes[position]
        let urlString = Bundle.main.path(forResource: quote.quoteName, ofType: "mp3")
        do {
           try AVAudioSession.sharedInstance().setMode(.default)
            try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
//            nilじゃなければ
            guard let urlString = urlString else {
                print("urlString is nil")
                return
            }
            player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: urlString))
            
            guard let player = player else {
                print("player is nil")
                return
            }
            player.play()
            player.volume = 0.5
        }
        catch {
            print("error")
        }
        holder.addSubview(quoteImageView)
        quoteImageView.frame = CGRect(x: 10,
                                      y: 10,
                                      width: holder.frame.size.width-20,
                                      height: holder.frame.size.width-20)
        quoteImageView.image = UIImage(named: quote.imageName)
        
//        labelの順番　quote, character, movie
        
        holder.addSubview(quoteLabel)
        quoteLabel.frame = CGRect(x: 10,
                                  y: quoteImageView.frame.size.height + 10,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        
        holder.addSubview(characterLabel)
        characterLabel.frame = CGRect(x: 10,
                                      y: quoteImageView.frame.size.height + 70,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        
        holder.addSubview(movieLabel)
        movieLabel.frame = CGRect(x: 10,
                                      y: quoteImageView.frame.size.height + 10 + 140,
                                      width: holder.frame.size.width-20,
                                      height: 70)
        quoteLabel.text = quote.quoteName
        characterLabel.text = quote.character
        movieLabel.text = quote.movie
        
        
    
        let nextButton = UIButton()
        let backButton = UIButton()
        
       
        let yPosition = movieLabel.frame.origin.y + 70 + 20
        let size: CGFloat = 70
        playPauseButton.frame = CGRect(x: (holder.frame.size.width - size) / 2.0,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        backButton.frame = CGRect(x: 20,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        nextButton.frame = CGRect(x: holder.frame.size.width - size,
                                  y: yPosition,
                                  width: size,
                                  height: size)
        
        playPauseButton.addTarget(self, action: #selector(didTapPlayButton), for: .touchUpInside)
        backButton.addTarget(self, action: #selector(didTapNextButton), for: .touchUpInside)
        nextButton.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        
        playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)
        backButton.setBackgroundImage(UIImage(systemName: "backward.fill"), for: .normal)
        nextButton.setBackgroundImage(UIImage(systemName: "forward.fill"), for: .normal)

        
        holder.addSubview(playPauseButton)
        holder.addSubview(nextButton)
        holder.addSubview(backButton)

        let slider = UISlider(frame: CGRect(x: 20,
                                            y: holder.frame.size.height-60,
                                            width: holder.frame.size.height-40,
                                            height: 50))
        holder.addSubview(slider)
        slider.value = 0.5
        slider.addTarget(self, action: #selector(didSlideSlider(_:)), for: .valueChanged)
    }
    @objc func didSlideSlider(_ slider: UISlider) {
        let value = slider.value
        player?.volume = value
    }
    
    @objc func didTapPlayButton(){
        
        if player?.isPlaying == true{
            player?.stop()
            playPauseButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: .normal)
           
            UIView.animate(withDuration: 0.2, animations: {
                self.quoteImageView.frame = CGRect(x: 30,
                                              y: 30,
                                              width: self.holder.frame.size.width-60,
                                              height: self.holder.frame.size.width-60)
                
            })
        }
        else{
            player?.play()
            playPauseButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: .normal)

            UIView.animate(withDuration: 0.2, animations: {
                self.quoteImageView.frame = CGRect(x: 10,
                                              y: 10,
                                              width: self.holder.frame.size.width-20,
                                              height: self.holder.frame.size.width-20)
                
            })
        }
    }
    @objc func didTapBackButton(){
        if position > 0 {
            position = position - 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
    @objc func didTapNextButton(){
        if position < quotes.count - 1 {
            position = position + 1
            player?.stop()
            for subview in holder.subviews {
                subview.removeFromSuperview()
            }
            configure()
        }
    }
     override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let player = player {
            player.stop()
        }
    }
}
