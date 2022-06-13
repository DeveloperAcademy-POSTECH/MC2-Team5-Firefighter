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
    private let cancelButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.setTitle("취소", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.white.withAlphaComponent(0.5), for: .highlighted)
        return button
    }()
    private let modifyButton: UIButton = {
        let button = UIButton(frame: CGRect(origin: .zero, size: CGSize(width: 44, height: 44)))
        button.titleLabel?.font = .font(.regular, ofSize: 16)
        button.setTitle("변경", for: .normal)
        button.setTitleColor(.subBlue, for: .normal)
        button.setTitleColor(.subBlue.withAlphaComponent(0.5), for: .highlighted)
        return button
    }()
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    private let scrollContentView = UIView()
    private let missionView = IndividualMissionView(mission: "1000원 이하의 선물 주고 인증샷 받기")
    private let letterTextView = LetterTextView()
    private let letterPhotoView = LetterPhotoView()
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationItem()
    }
    
    override func render() {
        view.addSubview(indicatorView)
        indicatorView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(9)
            $0.centerX.equalToSuperview()
        }
        
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        scrollView.addSubview(scrollContentView)
        scrollContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(scrollView.snp.width)
        }
        
        scrollContentView.addSubview(missionView)
        missionView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(25)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(100)
        }
        
        scrollContentView.addSubview(letterTextView)
        letterTextView.snp.makeConstraints {
            $0.top.equalTo(missionView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        scrollContentView.addSubview(letterPhotoView)
        letterPhotoView.snp.makeConstraints {
            $0.top.equalTo(letterTextView.snp.bottom).offset(22)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().inset(105)
        }
    }
    
    override func setupNavigationBar() {
        guard let navigationBar = navigationController?.navigationBar else { return }
        let appearance = UINavigationBarAppearance()
        let font = UIFont.font(.regular, ofSize: 16)
        
        appearance.titleTextAttributes = [.font: font]
        appearance.shadowColor = .clear
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.backgroundImage = nil
        appearance.shadowImage = nil
            
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        
        title = "쪽지 작성하기"
    }
    
    // MARK: - func
    
    private func setupNavigationItem() {
        let leftOffsetCancelButton = removeBarButtonItemOffset(with: cancelButton, offsetX: 10)
        let rightOffsetModifyButton = removeBarButtonItemOffset(with: modifyButton, offsetX: -10)
        let cancelButton = makeBarButtonItem(with: leftOffsetCancelButton)
        let modifyButton = makeBarButtonItem(with: rightOffsetModifyButton)
        
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = modifyButton
    }
}
