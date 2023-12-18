//
//  ContinueWatchingTableViewCell.swift
//  ShowToStream
//
//  Created by Pankaj Rana on 10/02/21.
//

import UIKit

class ContinueWatchingTableViewCell: UITableViewCell {
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var showTitleLabel: UILabel!
    @IBOutlet private weak var producerLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var timerView: UIView!
    @IBOutlet weak var availbleForNextLbl: UILabel!

    var show: Show! { didSet { showDidSet() } }
    
    func showDidSet() {
        if show.contentThumbnail != "" {
            posterImageView.setImage(with: show.contentThumbnail ?? "", placeholderImage: #imageLiteral(resourceName: "Home"))
        }
        timeLabel.text          = show.timeLeft
        showTitleLabel.text     = show.title
        producerLabel.text      = show.producer.first
        if show.paymentType == "1"{
            if show.timeLeft == "" {
                timerView.isHidden = true
                availbleForNextLbl.isHidden = true
            } else {
                timerView.isHidden = false
                availbleForNextLbl.isHidden = false
            }
        }else {
            timerView.isHidden = true
            availbleForNextLbl.isHidden = true
        }
        if show.playDuration != nil && show.totalPlayDuration != nil{
            if show.playDuration != "00:00:00" && show.totalPlayDuration != "00:00:00" {
                let totalDuration = Int((bindData(timer:show.playDuration!).timeIntervalSince(Date())))
                
                let totalPlayedDuration  = Int((bindData(timer:show.totalPlayDuration!).timeIntervalSince(Date())))
                
                print(totalDuration, totalPlayedDuration)
                
                let totalTime = (totalPlayedDuration * 100)/totalDuration
                
                print(totalTime)
                
                progressView.progress   = Float(totalTime) / 100.0
            }else{
                progressView.progress   = Float(0.0)
            }
        }else {
            progressView.progress   = Float(0.0)
        }
    }
    
    func bindData(timer: String) -> Date{
        let seconds = self.getTimerStartValueInSeconds(with: timer)
        let date =  Date(timeIntervalSinceNow: TimeInterval(seconds))
        return date
     }
    
    private func getTimerStartValueInSeconds(with value:String) -> Int {
        let array = value.components(separatedBy: ":")
        let hours = (Int(array[0]) ?? 0) * 60 * 60
        let minutes = (Int(array[1]) ?? 0) * 60
        let seconds = (Int(array[2]) ?? 0)
        return Int(hours + minutes + seconds)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
