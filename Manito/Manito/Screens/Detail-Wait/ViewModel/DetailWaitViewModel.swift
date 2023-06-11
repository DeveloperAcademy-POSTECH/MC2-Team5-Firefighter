//
//  DetailWaitViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 2023/05/30.
//

import Combine

final class DetailWaitViewModel {
    
    // MARK: - property
    
    let roomIndex: Int
    private let detailWaitService: DetailWaitAPI
    var roomInformation = CurrentValueSubject<Room?, Never>(nil)
    
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
//        let copyButtonDidTap: AnyPublisher<Void, Never>
    }
    
    var copyButtonStream = PassthroughSubject<Void,Never>()
    
    struct Output {
        let roomInformationDidUpdate: AnyPublisher<Room?, Never>
//        let showToastView: AnyPublisher<String, Never>
    }
    
    func transform(_ input: Input) -> Output {
//        let showToastView = input.copyButtonDidTap
//            .compactMap { self.roomInformation.value?.invitation?.code }
//            .eraseToAnyPublisher()
        
        return Output(
            roomInformationDidUpdate: self.roomInformation.eraseToAnyPublisher())
//            showToastView: showToastView)
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
