//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine
import Foundation

final class DetailWaitViewModel {
    
    // MARK: - property
    
    let roomIndex: Int
    private let detailWaitService: DetailWaitAPI
    var roomInformation = CurrentValueSubject<Room?, Never>(nil)
    lazy var editButtonDidTap = PassthroughSubject<Void, Never>()
    lazy var deleteButtonDidTap = PassthroughSubject<Void, Never>()
    lazy var leaveButtonDidTap = PassthroughSubject<Void, Never>()
    
    struct Input {
        let codeCopyButtonDidTap: AnyPublisher<Void, Never>
        let startButtonDidTap: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let roomInformationDidUpdate: AnyPublisher<Room?, Never>
        let showToast: AnyPublisher<String, Never>
        let startManitto: AnyPublisher<Void, Never>
        let presentEditView: AnyPublisher<Void, Never>
        let deleteRoom: AnyPublisher<Void, Never>
        let leaveRoom: AnyPublisher<Void, Never>
    }
    
    func transform(_ input: Input) -> Output {
        let showToastOutput = input.codeCopyButtonDidTap
            .compactMap { self.roomInformation.value?.invitation?.code }
            .eraseToAnyPublisher()
        
        let startManittoOutput = input.startButtonDidTap
            .throttle(for: 1, scheduler: DispatchQueue.main, latest: false)
            .eraseToAnyPublisher()
                
        return Output(roomInformationDidUpdate: self.roomInformation.eraseToAnyPublisher(),
                      showToast: showToastOutput,
                      startManitto: startManittoOutput,
                      presentEditView: self.editButtonDidTap.eraseToAnyPublisher(),
                      deleteRoom: self.deleteButtonDidTap.eraseToAnyPublisher(),
                      leaveRoom: self.leaveButtonDidTap.eraseToAnyPublisher()
        )
    }
    
    // MARK: - init
    
    init(roomIndex: Int, detailWaitService: DetailWaitAPI) {
        self.roomIndex = roomIndex
        self.detailWaitService = detailWaitService
    }
    
    // MARK: - func
    
    func fetchRoomInformation() {
        requestWaitRoomInfo { [weak self] result in
            switch result {
            case .success(let roominformation):
                self?.roomInformation.send(roominformation)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - network
    
    private func requestWaitRoomInfo(completionHandler: @escaping ((Result<Room, NetworkError>) -> Void)) {
        Task {
            do {
                let data = try await self.detailWaitService.getWaitingRoomInfo(roomId: self.roomIndex.description)
                if let roomInformation = data {
                    completionHandler(.success(roomInformation))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
    
    func requestStartManitto(completionHandler: @escaping ((Result<String, NetworkError>) -> Void)) {
        Task {
            do {
                let data = try await self.detailWaitService.startManitto(roomId: self.roomIndex.description)
                if let manittee = data {
                    guard let nickname = manittee.nickname else { return }
                    completionHandler(.success(nickname))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
    
    func requestDeleteRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteRoom(roomId: self.roomIndex.description)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default:
                    completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
    
    func requestDeleteLeaveRoom(completionHandler: @escaping ((Result<Void, NetworkError>) -> Void)) {
        Task {
            do {
                let statusCode = try await self.detailWaitService.deleteLeaveRoom(roomId: self.roomIndex.description)
                switch statusCode {
                case 200..<300: completionHandler(.success(()))
                default: completionHandler(.failure(.unknownError))
                }
            } catch NetworkError.serverError {
                completionHandler(.failure(.serverError))
            } catch NetworkError.clientError(let message) {
                completionHandler(.failure(.clientError(message: message)))
            }
        }
    }
}
