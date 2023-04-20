//
//  DetailEditView.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/04/20.
//

import UIKit

import SnapKit

protocol DetailEditDelegate: AnyObject {
    func dismiss()
}

final class DetailEditView: UIView {
    
//    enum EditMode {
//        case date
//        case information
//    }
    
    // MARK: - ui component
    
    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.cancel, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        return button
    }()
    private let topIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 1.5
        return view
    }()
    private let changeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(TextLiteral.change, for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        return button
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.modifiedRoomInfo
        label.font = .font(.regular, ofSize: 16)
        return label
    }()
    private let startSettingLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailEditViewControllerStartSetting
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private let calendarView: CalendarView = CalendarView()
    private let tipLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.maxMessage
        label.textColor = .grey004
        label.font = .font(.regular, ofSize: 14)
        return label
    }()
    private let setMemberLabel: UILabel = {
        let label = UILabel()
        label.text = TextLiteral.detailEditViewControllerSetMember
        label.font = .font(.regular, ofSize: 18)
        label.textColor = .white
        return label
    }()
    private lazy var minMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.memberSlider.minimumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var maxMemberLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Int(self.memberSlider.maximumValue))인"
        label.font = .font(.regular, ofSize: 16)
        label.textColor = .white
        return label
    }()
    private lazy var memberSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 4
        slider.maximumValue = 15
        slider.maximumTrackTintColor = .darkGrey003
        slider.minimumTrackTintColor = .red001
        //        slider.value = Float(self.sliderValue)
        slider.isContinuous = true
        slider.setThumbImage(ImageLiterals.imageSliderThumb, for: .normal)
        return slider
    }()
    private lazy var memberCountLabel: UILabel = {
        let label = UILabel()
        //        label.text = "\(self.sliderValue)" + TextLiteral.per
        label.font = .font(.regular, ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    // MARK: - property
    
    private weak var delegate: DetailEditDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupLayout()
        self.setupCancleButton()
    }
//    private var editMode: EditMode
    
//    init(editMode: EditMode) {
//        self.editMode = editMode
//        super.init(frame: .zero)
//        self.setupLayout()
//    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - func
    
    private func setupLayout() {
        self.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.leading.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(self.changeButton)
        self.changeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(29)
            $0.width.height.equalTo(44)
        }
        
        self.addSubview(self.topIndicatorView)
        self.topIndicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(40)
            $0.height.equalTo(3)
        }
        
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.cancelButton.snp.centerY)
        }
        
        self.addSubview(self.startSettingLabel)
        self.startSettingLabel.snp.makeConstraints {
            $0.top.equalTo(self.cancelButton.snp.bottom).offset(51)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.calendarView)
        self.calendarView.snp.makeConstraints {
            $0.top.equalTo(self.startSettingLabel.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview().inset(Size.leadingTrailingPadding)
            $0.height.equalTo(400)
        }
        
        self.addSubview(tipLabel)
        self.tipLabel.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(25)
        }
        
//        if self.editMode == .information {
//            self.setupEditMembersLayout()
//        }
    }
    
    private func setupEditMembersLayout() {
        self.addSubview(self.setMemberLabel)
        self.setMemberLabel.snp.makeConstraints {
            $0.top.equalTo(self.calendarView.snp.bottom).offset(60)
            $0.leading.equalToSuperview().inset(Size.leadingTrailingPadding)
        }
        
        self.addSubview(self.minMemberLabel)
        self.minMemberLabel.snp.makeConstraints {
            $0.top.equalTo(self.setMemberLabel.snp.bottom).offset(30)
            $0.leading.equalToSuperview().inset(24)
        }
        
        self.addSubview(self.memberSlider)
        self.memberSlider.snp.makeConstraints {
            $0.leading.equalTo(self.minMemberLabel.snp.trailing).offset(5)
            $0.height.equalTo(45)
            $0.centerY.equalTo(self.minMemberLabel.snp.centerY)
        }
        
        self.addSubview(self.maxMemberLabel)
        self.maxMemberLabel.snp.makeConstraints {
            $0.top.equalTo(self.setMemberLabel.snp.bottom).offset(30)
            $0.leading.equalTo(self.memberSlider.snp.trailing).offset(5)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        self.addSubview(self.memberCountLabel)
        self.memberCountLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(self.setMemberLabel.snp.centerY)
        }
    }
    
    func configureDelegation(_ delegate: DetailEditDelegate) {
        self.delegate = delegate
    }
    
    private func setupCancleButton() {
        let action = UIAction { [weak self] _ in
            self?.delegate?.dismiss()
        }
        self.cancelButton.addAction(action, for: .touchUpInside)
    }
}