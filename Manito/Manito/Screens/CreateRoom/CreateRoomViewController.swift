//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import Combine
import UIKit

import SnapKit

final class CreateRoomViewController: UIViewController, Navigationable, Keyboardable {
    
    // MARK: - ui component
    
    private let createRoomView: CreateRoomView = CreateRoomView()
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    private let viewModel: any BaseViewModelType
    
    // MARK: - init
    
    init(viewModel: any BaseViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
        self.view = self.createRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBarHiddenState()
        self.bindViewModel()
        self.bindUI()
        self.setupNavigation()
        self.setupKeyboardGesture()
    }
    
    // MARK: - override
    
    override func endEditingView() {
        self.createRoomView.endEditingView()
    }

    // MARK: - func

    private func setupNavigationBarHiddenState() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> CreateRoomViewModel.Output? {
        guard let viewModel = self.viewModel as? CreateRoomViewModel else { return nil }
        let input = CreateRoomViewModel.Input(textFieldTextDidChanged: self.createRoomView.textFieldPublisher.eraseToAnyPublisher(),
                                              sliderValueDidChanged: self.createRoomView.sliderPublisher.eraseToAnyPublisher(),
                                              startDateDidTap: self.createRoomView.startDateTapPublisher.eraseToAnyPublisher(),
                                              endDateDidTap: self.createRoomView.endDateTapPublisher.eraseToAnyPublisher(),
                                              characterIndexDidTap: self.createRoomView.characterIndexTapPublisher.eraseToAnyPublisher(),
                                              nextButtonDidTap: self.createRoomView.nextButtonDidTapPublisher.eraseToAnyPublisher(),
                                              backButtonDidTap: self.createRoomView.backButtonDidTapPublisher.eraseToAnyPublisher())
        return viewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: CreateRoomViewModel.Output?) {
        guard let output,
              let viewModel = self.viewModel as? CreateRoomViewModel
        else { return }
        
        output.title
            .sink(receiveValue: { [weak self] title in
                self?.createRoomView.updateRoomTitle(title: title)
                self?.createRoomView.updateTitleCount(count: title.count, maxLength: viewModel.maxCount)
            })
            .store(in: &self.cancellable)
        
        output.fixedTitleByMaxCount
            .sink(receiveValue: { [weak self] fixedTitle in
                self?.createRoomView.updateTextFieldText(fixedTitle: fixedTitle)
            })
            .store(in: &self.cancellable)
        
        output.capacity
            .sink(receiveValue: { [weak self] capacity in
                self?.createRoomView.updateCapacity(capacity: capacity)
                self?.createRoomView.updateRoomCapacity(capacity: capacity)
            })
            .store(in: &self.cancellable)
        
        output.dateRange
            .sink(receiveValue: { [weak self] dateRange in
                self?.createRoomView.updateRoomDateRange(range: dateRange)
            })
            .store(in: &self.cancellable)
        
        output.isEnabled
            .sink(receiveValue: { [weak self] isEnable in
                self?.createRoomView.toggleNextButton(isEnable: isEnable)
            })
            .store(in: &self.cancellable)
        
        output.currentNextStep
            .sink(receiveValue: { [weak self] step in
                self?.createRoomView.nextButtonDidTap(currentStep: step.0, nextStep: step.1)
            })
            .store(in: &self.cancellable)
        
        output.previousStep
            .sink(receiveValue: { [weak self] step in
                self?.createRoomView.backButtonDidTap(previousStep: step)
            })
            .store(in: &self.cancellable)
        
        output.roomId
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let roomId): self?.pushDetailWaitViewController(roomId: roomId.description)
                case .failure(let error): self?.makeAlert(title: error.localizedDescription)
                }
            }
            .store(in: &self.cancellable)
    }
    
    private func bindUI() {
        self.createRoomView.closeButtonDidTapPublisher
            .sink { [weak self] _ in
                self?.dismiss(animated: true)
            }
            .store(in: &self.cancellable)
    }
}

// MARK: - Helper
extension CreateRoomViewController {
    private func pushDetailWaitViewController(roomId: String) {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        let viewModel = DetailWaitViewModel(roomId: roomId, usecase: DetailWaitUseCaseImpl(repository: DetailRoomRepositoryImpl()))
        let viewController = DetailWaitViewController(viewModel: viewModel)
        
        navigationController.popViewController(animated: true)
        navigationController.pushViewController(viewController, animated: false)
        
        self.dismiss(animated: true) {
            viewController.sendCreateRoomEvent()
        }
    }
}
