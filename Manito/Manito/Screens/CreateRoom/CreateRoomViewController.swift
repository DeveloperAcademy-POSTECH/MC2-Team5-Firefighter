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
    
    private let roomService: RoomProtocol = RoomAPI(apiService: APIService())
    
    private var cancellable = Set<AnyCancellable>()
    private let createRoomViewModel: CreateRoomViewModel
    
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
    
    // FIXME: 플로우 연결 하면서 변경 될 예정
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        
        let viewController = DetailWaitViewController(viewModel: DetailWaitViewModel(roomIndex: roomId,
                                                                                     detailWaitService: DetailWaitService(api: DetailWaitAPI(apiService: APIService()))))
        
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
        let input = CreateRoomViewModel.Input(
            textFieldTextDidChanged: self.createRoomView.roomTitleView.textFieldPublisher.eraseToAnyPublisher(),
            sliderValueDidChanged: self.createRoomView.roomCapacityView.sliderPublisher.eraseToAnyPublisher(),
            calendarDateDidTap: self.createRoomView.calendarDidTapPublisher.eraseToAnyPublisher(),
            nextButtonDidTap: self.createRoomView.nextButtonDidTapPublisher.eraseToAnyPublisher())
        return self.createRoomViewModel.transform(from: input)
    }
    
    private func bindOutputToViewModel(_ output: CreateRoomViewModel.Output) {
        output.title
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] title in
                self?.createRoomView.roomTitleView.setCounter(count: title.count)
                self?.createRoomView.roomInfoView.updateRoomTitle(title: title)
            })
            .store(in: &cancellable)
        
        output.capacity
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] capacity in
                self?.createRoomView.roomCapacityView.updateCapacity(capacity: capacity)
                self?.createRoomView.roomInfoView.updateRoomCapacity(capacity: capacity)
                
            })
            .store(in: &cancellable)
        
        output.date
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] range in
                self?.createRoomView.roomInfoView.updateRoomDateRange(range: range)
            })
            .store(in: &cancellable)
        
        output.currentStep
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] currentStep in
                self?.createRoomView.nextButtonDidTap(step: currentStep)
            })
            .store(in: &cancellable)
    }
    
    // MARK: - network
    
    private func requestCreateRoom(room: CreateRoomDTO) {
        Task {
            do {
                guard let roomId = try await self.roomService.postCreateRoom(body: room) else { return }
                self.pushDetailWaitViewController(roomId: roomId)
            } catch NetworkError.serverError {
                print("server Error")
            } catch NetworkError.encodingError {
                print("encoding Error")
            } catch NetworkError.clientError(let message) {
                print("client Error: \(String(describing: message))")
            }
        }
    }
}

extension CreateRoomViewController: CreateRoomViewDelegate {
    func didTapCloseButton() {
        self.dismiss(animated: true)
    }
    
    func requestCreateRoom(roomInfo: RoomInfo, colorIndex: Int) {
        guard let roomTitle = roomInfo.title,
              let roomCapacity = roomInfo.capacity,
              let roomStartDate = roomInfo.startDate,
              let roomEndDate = roomInfo.endDate else { return }
        self.requestCreateRoom(room: CreateRoomDTO(room: RoomDTO(title: roomTitle,
                                                                 capacity: roomCapacity,
                                                                 startDate: roomStartDate,
                                                                 endDate: roomEndDate),
                                                   member: MemberDTO(colorIndex: colorIndex)))
    }
}
