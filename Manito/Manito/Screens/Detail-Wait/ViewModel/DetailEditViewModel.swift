//
//  DetailEditViewModel.swift
//  Manito
//
//  Created by Mingwan Choi on 10/31/23.
//

import Combine
import Foundation

final class DetailEditViewModel: BaseViewModelType {
    struct Input {
        let viewDidLoad: AnyPublisher<Void, Never>
        let changeButtonDidTap: AnyPublisher<CreatedRoomInfoRequestDTO, Never>
    }
    struct Output {
        let roomInfo: AnyPublisher<RoomInfo, Never>
        let isPassStartDate: AnyPublisher<Bool, Never>
        let isOverMember: AnyPublisher<Bool, Never>
        let changeSuccess: AnyPublisher<Result<Int, Error>, Never>
    }
    
    private let usecase: DetailEditUsecase
    private var cancellable: Set<AnyCancellable> = Set()
    
    init(usecase: DetailEditUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        let roomInfoOutput = input.viewDidLoad
            .compactMap { [weak self] _ in
                self?.usecase.roomInformation
            }
            .eraseToAnyPublisher()
        
        let isPastPublisher = input.changeButtonDidTap
            .compactMap { [weak self] dto in
                self?.usecase.validStartDatePast(startDate: dto.startDate)
            }
            .eraseToAnyPublisher()
        
        let isMemberOverPublisher = input.changeButtonDidTap
            .compactMap { [weak self] dto in
                self?.usecase.validMemberCountOver(capacity: dto.capacity)
            }
            .eraseToAnyPublisher()
        
        let changeRoomOutput = input.changeButtonDidTap
            .filter { [weak self] dto in
                guard let self else { return false }
                return self.usecase.validMemberCountOver(capacity: dto.capacity) }
            .filter { [weak self] dto in
                guard let self else { return false }
                return self.usecase.validStartDatePast(startDate: dto.startDate) }
            .asyncMap { [weak self] dto -> Result<Int, Error> in
                do {
                    let statusCode = try await self?.usecase.changeRoomInformation(roomDto: dto)
                    return .success(statusCode ?? 0)
                } catch(let error) {
                    return .failure(error)
                }
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
        
        return Output(
            roomInfo: roomInfoOutput,
            isPassStartDate: isPastPublisher,
            isOverMember: isMemberOverPublisher,
            changeSuccess: changeRoomOutput)
    }
}
