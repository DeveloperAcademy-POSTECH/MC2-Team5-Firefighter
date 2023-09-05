//
//  CheckRoomViewController.swift
//  Manito
//
//  Created by COBY_PRO on 2022/06/15.
//

import UIKit

import SnapKit
//FIXME: 리팩터링 하기
final class CheckRoomViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let checkRoomView: CheckRoomView = CheckRoomView()
    
    // MARK: - property
    
    private var roomInfo: ParticipateRoomInfo
    
    // MARK: - init
    
    init(roomInfo: ParticipateRoomInfo) {
        self.roomInfo = roomInfo
        super.init()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }
    
    // MARK: - life cycle
    
    override func loadView() {
        self.view = self.checkRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupRoomInfo(roomInfo: roomInfo)
    }
    
    // MARK: - override
    
    override func configureUI() {
        view.backgroundColor = .black.withAlphaComponent(0.7)
    }
    
    // MARK: - func
    
    private func setupRoomInfo(roomInfo: ParticipateRoomInfo) {
        self.checkRoomView.roomInfoView.setupRoomInfo(roomInfo: roomInfo)
    }
}
