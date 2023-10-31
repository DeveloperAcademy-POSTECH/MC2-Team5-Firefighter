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
        let changeRoomPublisher: AnyPublisher<CreatedRoomInfoRequestDTO, Never>
        let changeButtonDidTap: AnyPublisher<Void, Never>
    }
    struct Output {
        let roomInformation: AnyPublisher<RoomInfo, Never>
        let passStartDate: AnyPublisher<Bool, Never>
        let overMember: AnyPublisher<Bool, Never>
        let changeSuccess: AnyPublisher<Int, Error>
    }
    
    let usecase: DetailEditUsecase
    
    init(usecase: DetailEditUsecase) {
        self.usecase = usecase
    }
    
    // MARK: - func
    
    func transform(from input: Input) -> Output {
        let roomInformationOutput = input.viewDidLoad
            .compactMap { [weak self] _ in
                return self?.usecase.roomInformation
            }
            .eraseToAnyPublisher()
        
        let isPastPublisher = input.changeButtonDidTap.combineLatest(input.changeRoomPublisher)
            .compactMap { [weak self] _, dto in
                self?.validStartDatePast(startDate: dto.startDate)
            }
            .eraseToAnyPublisher()
        
        let isMemberOverPublisher = input.changeButtonDidTap.combineLatest(input.changeRoomPublisher)
            .compactMap { [weak self] _, dto in
                self?.validMemberCountOver(capacity: dto.capacity)
            }
            .eraseToAnyPublisher()
        
        let changeRoomOutput = input.changeButtonDidTap.combineLatest(input.changeRoomPublisher)
            .asyncMap { [weak self] _, dto in
                try await self?.changeRoomInformation(roomDto: dto)
            }
            .compactMap { $0 }
            .eraseToAnyPublisher()
            
        
        return Output(roomInformation: roomInformationOutput,
                      passStartDate: isPastPublisher,
                      overMember: isMemberOverPublisher,
                      changeSuccess: changeRoomOutput
        )
    }
    
    private func validStartDatePast(startDate: String) -> Bool {
        guard let startDate = startDate.toDefaultDate else { return false }
        let isPast = startDate.isPast
        return !isPast
    }
    
    private func validMemberCountOver(capacity: Int) -> Bool {
        let isOverMember = self.usecase.roomInformation.participants.count > capacity
        return !isOverMember
    }
    
    private func changeRoomInformation(roomDto: CreatedRoomInfoRequestDTO) async throws -> Int {
        let statusCode = try await self.usecase.changeRoomInformation(roomDto: roomDto)
        return statusCode
    }
}
