//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: ViewModelType {

    typealias MessageDetails = (roomId: String, mission: String, missionId: String, manitteeId: String)
    typealias ReportDetails = (nickname: String, content: String)

    enum MessageType: Int {
        case sent = 0
        case received = 1
    }

    struct Input {
        let viewDidLoad: AnyPublisher<MessageType, Never>
        let segmentControlValueChanged: AnyPublisher<MessageType, Never>
        let refresh: PassthroughSubject<Void, Never>
        let sendLetterButtonDidTap: AnyPublisher<Void, Never>
        let reportButtonDidTap: PassthroughSubject<String, Never>
    }

    struct Output {
        let messages: PassthroughSubject<[Message], NetworkError>
        let index: PassthroughSubject<Int, Never>
        let messageDetails: AnyPublisher<MessageDetails, Never>
        let reportDetails: AnyPublisher<ReportDetails, Never>
    }

    // MARK: - property

    private let messageSubject: PassthroughSubject<[Message], NetworkError> = PassthroughSubject()
    private let indexSubject: PassthroughSubject<Int, Never> = PassthroughSubject()

    private var cancelBag: Set<AnyCancellable> = Set()

    private let service: LetterServicable
    private var messageDetails: MessageDetails

    // MARK: - init

    init(service: LetterServicable,
         roomId: String,
         mission: String,
         missionId: String) {
        self.service = service
        self.messageDetails = MessageDetails(roomId, mission, missionId, "")
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let refreshWithType = input.refresh
            .map { MessageType.sent }

        Publishers.Merge3(input.viewDidLoad, input.segmentControlValueChanged, refreshWithType)
            .withUnretained(self)
            .sink(receiveValue: { owner, type in
                owner.fetchMessages(with: type)
                owner.sendCurrentIndex(at: type)
            })
            .store(in: &self.cancelBag)

        let messagePublisher = input.sendLetterButtonDidTap
            .withUnretained(self)
            .map { owner, _ -> MessageDetails in
                owner.loadMessageDetails()
                return owner.messageDetails
            }
            .eraseToAnyPublisher()

        let reportPublisher = input.reportButtonDidTap
            .withUnretained(self)
            .map { owner, content -> ReportDetails in
                owner.service.loadNickname()
                return (owner.service.nickname, content)
            }
            .eraseToAnyPublisher()

        return Output(messages: self.messageSubject, index: self.indexSubject, messageDetails: messagePublisher, reportDetails: reportPublisher)
    }

    // MARK: - Private - func

    private func sendCurrentIndex(at type: MessageType) {
        let currentIndex = self.currentIndex(at: type)
        self.indexSubject.send(currentIndex)
    }

    private func fetchMessages(with type: MessageType) {
        let roomId = self.messageDetails.roomId

        switch type {
        case .sent: self.fetchSendMessages(roomId: roomId)
        case .received: self.fetchReceivedMessages(roomId: roomId)
        }
    }
}

// MARK: - Helper
extension LetterViewModel {
    private func currentIndex(at type: MessageType) -> Int {
        return type.rawValue
    }

    private func fetchSendMessages(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchSendLetter(roomId: roomId)
                self.messageSubject.send(messages)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.messageSubject.send(completion: .failure(error))
            }
        }
    }

    private func fetchReceivedMessages(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchReceiveLetter(roomId: roomId)
                self.messageSubject.send(messages)
            } catch(let error) {
                guard let error = error as? NetworkError else { return }
                self.messageSubject.send(completion: .failure(error))
            }
        }
    }

    private func loadMessageDetails() {
        guard let manitteeId = self.service.manitteeId else { return }
        self.messageDetails.manitteeId = manitteeId
    }
}
