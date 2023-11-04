//
//  InvitedCodeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import UIKit

import SnapKit

final class InvitedCodeViewController: UIViewController {
        
    // MARK: - ui components
    
    private let invitedCodeView: InvitedCodeView = InvitedCodeView()
    
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("\(#file) is dead")
    }

    // MARK: - life cycle

    override func loadView() {
        self.view = self.invitedCodeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - base func
    
}
