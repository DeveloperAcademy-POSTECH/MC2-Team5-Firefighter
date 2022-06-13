//
//  CreateLetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/13.
//

import UIKit

import SnapKit

final class CreateLetterViewController: BaseViewController {

    
    // MARK: - property

    private let indicatorView: UIView = {
        let view = UIView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 3)))
        view.backgroundColor = .white.withAlphaComponent(0.8)
        view.layer.cornerRadius = 5
        return view
    }()
    private let missionView = IndividualMissionView(mission: "1000원 이하의 선물 주고 인증샷 받기")
    private let letterTextView = LetterTextView()
    private let letterPhotoView = LetterPhotoView()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func render() {
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(missionView)
        missionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(54)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        view.addSubview(letterTextView)
        letterTextView.snp.makeConstraints {
            $0.top.equalTo(missionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        view.addSubview(letterPhotoView)
        letterPhotoView.snp.makeConstraints {
            $0.top.equalTo(letterTextView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
    }
}
