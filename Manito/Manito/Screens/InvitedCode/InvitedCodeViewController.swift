//
//  InvitedCodeViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import Combine
import UIKit

import SnapKit

final class InvitedCodeViewController: UIViewController {
        
    // MARK: - ui components
    
    private let invitedCodeView: InvitedCodeView = InvitedCodeView()
    
    // MARK: - property
    
    private let viewModel: any BaseViewModelType
    private var cancellable: Set<AnyCancellable> = Set()
    
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
        self.bindViewModel()
        self.bindUI()
    }

    // MARK: - func
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> InvitedCodeViewModel.Output? {
        guard let viewModel = self.viewModel as? InvitedCodeViewModel else { return nil }
        let input = InvitedCodeViewModel.Input(viewDidLoad: self.viewDidLoadPublisher, 
                                               copyButtonDidTap: self.invitedCodeView.codeButtonDidTapPublisher)
        
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: InvitedCodeViewModel.Output?) {
        guard let output else { return }
        
        output.roomInfo
            .sink { [weak self] roomInfo in
                self?.invitedCodeView.updateRoomInfo(roomInfo: roomInfo.roomInformation)
                self?.invitedCodeView.updateCodeButtonTitle(code: roomInfo.invitation.code)
            }
            .store(in: &self.cancellable)
        
        output.copyButtonDidTap
            .sink { [weak self] code in
                ToastView.showToast(code: code,
                                    message: TextLiteral.DetailWait.toastCopyMessage.lowercased(), 
                                    controller: self ?? UIViewController())
            }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.invitedCodeView.closeButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &self.cancellable)
    }
}
