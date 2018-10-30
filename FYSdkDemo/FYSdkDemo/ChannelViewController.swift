//
//  ChannelViewController.swift
//  FYSdkDemo
//
//  Created by ting on 2018/10/29.
//  Copyright © 2018年 feiyucloud. All rights reserved.
//

import UIKit
import SnapKit

class ChannelViewController: UIViewController, FYRtcEngineKitDelegate, UITableViewDataSource, UITableViewDelegate {
    
    private var channelId: String!
    private var userId = getUserId()
    
    private var stateLabel: UILabel!
    private var btnMuteOther: UIButton!
    private var btnSpeaker: UIButton!
    private var btnMuteLocal: UIButton!
    private var tableView: UITableView!
    
    private let EventCellId = "EventCellId"
    private var eventArray = Array<String>()
    
    private var countdownTimer: Timer? = nil
    private var duration: Int = 0
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    convenience init(channelId: String) {
        self.init(nibName: nil, bundle: nil)
        self.channelId = channelId
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: "161616")
        
        // ================ nameLabel and stateLabel ================
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor.white
        nameLabel.font = UIFont.systemFont(ofSize: 32)
        nameLabel.text = channelId
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.top.equalTo(self.view.safeAreaLayoutGuide).offset(50)
            } else {
                make.top.equalTo(self.view).offset(50)
            }
        }
        
        stateLabel = UILabel()
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 16)
        stateLabel.text = "正在加入"
        self.view.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        // ================ button leave channel ================
        let leaveBtn = UIButton(type: .custom)
        leaveBtn.setBackgroundImage(UIImage(named: "call_end_nor"), for: .normal)
        leaveBtn.setBackgroundImage(UIImage(named: "call_end_pre"), for: .highlighted)
        leaveBtn.addTarget(self, action: #selector(self.actionLeaveChannel(_:)), for: .touchUpInside)
        self.view.addSubview(leaveBtn)
        leaveBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            if #available(iOS 11.0, *) {
                make.bottom.equalTo(self.view.safeAreaLayoutGuide).offset(-30)
            } else {
                make.bottom.equalTo(self.view).offset(-30)
            }
        }
        
        // ================ button speaker, muteOther, muteLocal ================
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        stackView.alignment = .fill
        self.view.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).offset(-10)
            make.bottom.equalTo(leaveBtn.snp.top).offset(-30)
        }
        
        btnSpeaker = buildControlButton(titleNormal: "Speaker On", titleSelect: "Speaker Off")
        btnSpeaker.addTarget(self, action: #selector(actionBtnSpeaker(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(btnSpeaker)
        
        btnMuteOther = buildControlButton(titleNormal: "Mute Other", titleSelect: "Unmute Other")
        btnMuteOther.addTarget(self, action: #selector(actionBtnMuteOther(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(btnMuteOther)
        
        btnMuteLocal = buildControlButton(titleNormal: "Mute Local", titleSelect: "Unmute Local")
        btnMuteLocal.addTarget(self, action: #selector(actionBtnMuteLocal(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(btnMuteLocal)
        
        // ================ event TableView ================
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: EventCellId)
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.width.equalTo(self.view)
            make.top.equalTo(stateLabel.snp.bottom).offset(20)
            make.bottom.equalTo(stackView.snp.top).offset(-20)
        }
        
        // ================ join channel ================
        AppCall.shared.delegate = self
        AppCall.shared.getRtcEngine().joinChannel(channelId, uid: userId, option: nil)
    }
    
    private func buildControlButton(titleNormal: String, titleSelect: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(titleNormal, for: .normal)
        button.setTitle(titleSelect, for: .selected)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitleColor(UIColor(hexString: "53cef6"), for: .highlighted)
        button.setTitleColor(UIColor(hexString: "53cef6"), for: .selected)
        return button
    }
    
    // MARK: - Button action
    @objc func actionLeaveChannel(_ sender: Any) {
        AppCall.shared.getRtcEngine().leaveChannel()
    }
    
    @objc func actionBtnSpeaker(_ sender: Any) {
        let button: UIButton = sender as! UIButton
        button.isSelected = !button.isSelected
        AppCall.shared.getRtcEngine().enableSpeaker(button.isSelected)
    }
    
    @objc func actionBtnMuteOther(_ sender: Any) {
        let button: UIButton = sender as! UIButton
        button.isSelected = !button.isSelected
        AppCall.shared.getRtcEngine().muteOtherAudio(userId!, channelId: channelId, mute: button.isSelected)
    }
    
    @objc func actionBtnMuteLocal(_ sender: Any) {
        let button: UIButton = sender as! UIButton
        button.isSelected = !button.isSelected
        AppCall.shared.getRtcEngine().muteLocalAudio(button.isSelected)
    }
    
    // MARK: - Private
    private func leaveChannel() {
        countdownTimer?.invalidate()
        MyProgressHUD.showInfo(msg: "Leave Channel")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func startCountdown() {
        if countdownTimer == nil {
            countdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                self.duration += 1
                if self.duration >= 3600 {
                    let sec = self.duration % 3600
                    self.stateLabel.text = String(format: "%d:%02d:%02d",
                                                  (Int)(self.duration / 3600),
                                                  (Int)(self.duration / 60),
                                                  (Int)(sec % 60))
                } else {
                    self.stateLabel.text = String(format: "%02d:%02d",
                                                  (Int)(self.duration / 60),
                                                  (Int)(self.duration % 60))
                }
            })
        }
    }
    
    private func processChannelEvent(event: String) {
        eventArray.append(event)
        let indexPath = IndexPath(row: eventArray.count-1, section: 0)
        tableView.insertRows(at: [indexPath], with: .none)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - FYRtcEngineKitDelegate
    func rtcEngine(_ engine: FYRtcEngineKit, didError error: FYError) {
        countdownTimer?.invalidate()
        self.dismiss(animated: true, completion: nil)
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didJoinChannel channel: String, uid: String) {
        userId = uid
        startCountdown()
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didLeaveChannel channel: String) {
        leaveChannel()
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didJoinedOfUid uid: String) {
        processChannelEvent(event: String(format: "%@ : 加入频道", uid))
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didOfflineOfUid uid: String) {
        processChannelEvent(event: String(format: "%@ : 离开频道", uid))
    }
    
    func rtcEngine(_ engine: FYRtcEngineKit, didAudioMuted muted: Bool, uid: String) {
        let name: String = (uid == userId ? "我" : uid)
        let event: String = (muted ? String(format: "%@ : 被静音", name) : String(format: "%@ : 静音解除", name))
        processChannelEvent(event: event)
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCellId, for: indexPath)
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor(hexString: "c7c7c7")
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        cell.textLabel?.text = eventArray[indexPath.row]
        return cell
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 26
    }
}
