//
//  SelectManitteeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/19.
//

import UIKit

final class SelectManitteeViewController: BaseViewController {

    private enum SelectionStage {
        case showJoystick, showCapsule, openName, openButton
    }

    // MARK: - ui component

    private let selectManitteeView: SelectManitteeView = SelectManitteeView()

    // MARK: - property

    private let roomId: String
    var manitteeNickname: String?
    private var stageType: SelectionStage = .showJoystick {
        didSet {
            self.hiddenImageView()
            self.setupGifImage()
        }
    }

    // MARK: - init

    init(roomId: String, manitteeNickname: String) {
        self.roomId = roomId
        self.manitteeNickname = manitteeNickname
        super.init()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.selectManitteeView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
