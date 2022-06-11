//
//  LetterViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class LetterViewController: BaseViewController {
    
    private enum LetterState: String, CaseIterable {
        case received = "받은 쪽지"
        case sent = "보낸 쪽지"
    }
    
    // MARK: - property
    
    private let segmentControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [LetterState.received.rawValue,
                                                 LetterState.sent.rawValue])
        let normalTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let selectedTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]

        control.setTitleTextAttributes(normalTextAttributes, for: .normal)
        control.setTitleTextAttributes(selectedTextAttributes, for: .selected)
        control.selectedSegmentTintColor = .white
        control.backgroundColor = .black
        control.selectedSegmentIndex = 0
        
        return control
    }()
    
    let button = UIButton()

    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func render() {
        view.addSubview(segmentControl)
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(13)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
    }
    
    override func configUI() {
        super.configUI()
    }
    
    override func setupNavigationBar() {
        super.setupNavigationBar()
  
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .automatic
        title = "쪽지함"
    }
    
    // MARK: - func
    
}
