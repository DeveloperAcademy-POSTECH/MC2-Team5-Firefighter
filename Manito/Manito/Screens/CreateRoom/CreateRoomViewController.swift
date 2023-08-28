//
//  CreateRoomViewController.swift
//  Manito
//
//  Created by SHIN YOON AH on 2022/06/09.
//

import Combine
import UIKit

import SnapKit

final class CreateRoomViewController: BaseViewController {
    
    // MARK: - ui component
    
    private let createRoomView: CreateRoomView = CreateRoomView()
    
    // MARK: - property
    
    private var cancellable = Set<AnyCancellable>()
    private let createRoomViewModel: CreateRoomViewModel
    private let roomParticipationRepository: RoomParticipationRepository = RoomParticipationRepositoryImpl()
    
    // MARK: - init
    
    init(viewModel: CreateRoomViewModel) {
        self.createRoomViewModel = viewModel
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
        self.view = self.createRoomView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureDelegation()
        self.bindViewModel()
    }
    
    // MARK: - override
    
    override func configureUI() {
        super.configureUI()
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func endEditingView() {
        self.createRoomView.endEditingView()
    }
    
    // MARK: - func
    
    private func configureDelegation() {
        self.createRoomView.configureDelegate(self)
    }
    
    private func pushDetailWaitViewController(roomId: Int) {
        guard let navigationController = self.presentingViewController as? UINavigationController else { return }
        let viewModel = DetailWaitViewModel(roomIndex: roomId,
                                            detailWaitService: DetailWaitService(repository: DetailRoomRepositoryImpl()))
        let viewController = DetailWaitViewController(viewModel: viewModel)
        
        navigationController.popViewController(animated: true)
        navigationController.pushViewController(viewController, animated: false)
        
        self.dismiss(animated: true) {
            NotificationCenter.default.post(name: .createRoomInvitedCode, object: nil)
        }
    }
    
    private func bindViewModel() {
        let output = self.transformedOutput()
        self.bindOutputToViewModel(output)
    }
    
    private func transformedOutput() -> CreateRoomViewModel.Output {
        let input = CreateRoomViewModel.Input(textFieldTextDidChanged: self.createRoomView.roomTitleView.textFieldPublisher.eraseToAnyPublisher(),
                                              sliderValueDidChanged: self.createRoomView.roomCapacityView.sliderPublisher.eraseToAnyPublisher(),
                                              startDateDidTap: self.createRoomView.roomDateView.calendarView.startDateTapPublisher.eraseToAnyPublisher(),
                                              endDateDidTap: self.createRoomView.roomDateView.calendarView.endDateTapPublisher.eraseToAnyPublisher(),
                                              characterIndexDidTap: self.createRoomView.characterCollectionView.characterIndexTapPublisher.eraseToAnyPublisher(),
                                              nextButtonDidTap: self.createRoomView.nextButtonDidTapPublisher.eraseToAnyPublisher(),
                                              backButtonDidTap: self.createRoomView.backButtonDidTapPublisher.eraseToAnyPublisher())
        return self.createRoomViewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: CreateRoomViewModel.Output) {
        
        output.title
            .sink(receiveValue: { [weak self] title in
                self?.createRoomView.roomInfoView.updateRoomTitle(title: title)
                self?.createRoomView.roomTitleView.updateTitleCount(count: title.count, maxLength: self?.createRoomViewModel.maxCount ?? 0)
            })
            .store(in: &self.cancellable)
        
        output.isOverMaxCount
            .sink(receiveValue: { [weak self] isOverMaxCount in
                if isOverMaxCount {
                    self?.createRoomView.roomTitleView.updateTextFieldText(maxLength: self?.createRoomViewModel.maxCount ?? 0)
                }
            })
            .store(in: &self.cancellable)
        
        output.capacity
            .sink(receiveValue: { [weak self] capacity in
                self?.createRoomView.roomCapacityView.updateCapacity(capacity: capacity)
                self?.createRoomView.roomInfoView.updateRoomCapacity(capacity: capacity)
            })
            .store(in: &self.cancellable)
        
        output.dateRange
            .sink(receiveValue: { [weak self] dateRange in
                self?.createRoomView.roomInfoView.updateRoomDateRange(range: dateRange)
            })
            .store(in: &self.cancellable)
        
        output.isEnabled
            .sink(receiveValue: { [weak self] isEnable in
                self?.createRoomView.toggleNextButton(isEnable: isEnable)
            })
            .store(in: &self.cancellable)
        
        output.currentStep
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
            .sink(receiveCompletion: { [weak self] result in 
                switch result {
                case .finished: return
                case .failure(_):
                    self?.makeAlert(title: "에러발생")
                }
            }, receiveValue: { [weak self] roomid in
                self?.pushDetailWaitViewController(roomId: roomid)
            })
            .store(in: &self.cancellable)
    }
}

extension CreateRoomViewController: CreateRoomViewDelegate {
    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
}
