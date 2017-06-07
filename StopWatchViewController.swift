//
//  StopWatchViewController.swift
//  MyDemos
//
//  Created by StoneNan on 2017/5/23.
//  Copyright © 2017年 StoneNan. All rights reserved.
//

import UIKit

class StopWatchViewController: UIViewController, UITableViewDelegate {

    fileprivate let mainStopWatch: StopWatch = StopWatch()
    fileprivate let lapStopWatch: StopWatch = StopWatch()
    fileprivate var isPlay: Bool = false
    fileprivate var laps: [String] = []
    
    
    
    // MARK: Prepare for the look
    override var shouldAutorotate: Bool {
        return false
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    fileprivate func initCircleButton(_ button: UIButton) {
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.backgroundColor = UIColor.white
    }
    
    
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var lapTimerLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var lapResetButton: UIButton!
    @IBOutlet weak var lapsTableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initCircleButton(playPauseButton)
        initCircleButton(lapResetButton)
        
        lapResetButton.isEnabled = false
        lapResetButton.setTitleColor(UIColor.lightGray, for: UIControlState())
        
        lapsTableView.delegate = self
        lapsTableView.dataSource = self
        
    }

    
    
    
    @IBAction func playPauseTimer(_ sender: UIButton) {
        if (!self.isPlay) {
            lapResetButton.isEnabled = true
            changeButton(lapResetButton, title: "Lap", titleColor: .black)
            self.mainStopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateMainTimer, userInfo: nil, repeats: true)
            self.lapStopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(self.mainStopWatch.timer, forMode: .commonModes)
            RunLoop.current.add(self.lapStopWatch.timer, forMode: .commonModes)
            
            self.isPlay = true
            changeButton(playPauseButton, title: "Stop", titleColor: .red)
        } else {
            self.mainStopWatch.timer.invalidate()
            self.lapStopWatch.timer.invalidate()
            self.isPlay = false
            changeButton(playPauseButton, title: "Start", titleColor: .green)
            changeButton(lapResetButton, title: "Reset", titleColor: .black)
        }
    }
    
    @IBAction func lapResetTimer(_ sender: UIButton) {
        if (!self.isPlay) {
            resetMainTimer()
            resetLapTimer()
            changeButton(lapResetButton, title: "Lap", titleColor: .lightGray)
            lapResetButton.isEnabled = false
        } else {
            if let timerLabelText = timerLabel.text {
                laps.append(timerLabelText)
            }
            lapsTableView.reloadData()
            resetLapTimer()
            self.lapStopWatch.timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: Selector.updateLapTimer, userInfo: nil, repeats: true)
            
            RunLoop.current.add(self.lapStopWatch.timer, forMode: .commonModes)
        }
    }
    
    
    
    // MARK: Fileprivate fuctions needed
    fileprivate func changeButton(_ button: UIButton, title: String, titleColor: UIColor) {
        button.setTitle(title, for: UIControlState())
        button.setTitleColor(titleColor, for: UIControlState())
    }
    fileprivate func resetMainTimer() {
        resetTimer(mainStopWatch, label: timerLabel)
        laps.removeAll()
        lapsTableView.reloadData()
    }
    fileprivate func resetLapTimer() {
        resetTimer(lapStopWatch, label: lapTimerLabel)
    }
    fileprivate func resetTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.timer.invalidate()
        stopwatch.counter = 0.0
        label.text = "00:00:00"
    }
    fileprivate func updateTimer(_ stopwatch: StopWatch, label: UILabel) {
        stopwatch.counter = stopwatch.counter + 0.035
        
        var minutes: String = "\((Int)(stopwatch.counter / 60))"
        if (Int)(stopwatch.counter / 60) < 10 {
            minutes = "0\((Int)(stopwatch.counter / 60))"
        }
        
        var seconds: String = String(format: "%.2f", (stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        if stopwatch.counter.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        
        label.text = minutes + ":" + seconds
    }
    
    
    func updateMainTimer() {
        updateTimer(mainStopWatch, label: timerLabel)
    }
    func updateLapTimer() {
        updateTimer(lapStopWatch, label: lapTimerLabel)
    }
}

extension StopWatchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return laps.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier: String = "LapCell"
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        
        if let labelNum = cell.viewWithTag(11) as? UILabel {
            labelNum.text = "Lap \(laps.count - (indexPath as NSIndexPath).row)"
        }
        if let labelTimer = cell.viewWithTag(12) as? UILabel {
            labelTimer.text = laps[laps.count - (indexPath as NSIndexPath).row - 1]
        }
        
        return cell
    }
}

fileprivate extension Selector {
    static let updateMainTimer = #selector(StopWatchViewController.updateMainTimer)
    static let updateLapTimer = #selector(StopWatchViewController.updateLapTimer)
}
