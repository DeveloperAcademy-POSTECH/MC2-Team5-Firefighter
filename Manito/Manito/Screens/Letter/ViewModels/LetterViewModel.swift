//
//  LetterViewModel.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/20.
//

import Combine
import Foundation

final class LetterViewModel: ViewModelType {

    enum MessageType: Int {
        case send = 0
        case received = 1
    }

    struct Input {
        let viewDidLoad: AnyPublisher<MessageType, Never>
        let segmentControlValueChanged: CurrentValueSubject<MessageType, Never>
        let refresh: PassthroughSubject<Void, Never>
    }

    struct Output {
        let messages: PassthroughSubject<[Message], Never>
        let index: PassthroughSubject<Int, Never>
    }

    // MARK: - property

    private let messageSubject: PassthroughSubject<[Message], Never> = PassthroughSubject()
    private let indexSubject: PassthroughSubject<Int, Never> = PassthroughSubject()

    private var cancelBag: Set<AnyCancellable> = Set()

    private let service: LetterServicable

    // MARK: - init

    init(service: LetterServicable) {
        self.service = service
    }

    // MARK: - Public - func

    func transform(from input: Input) -> Output {
        let refreshWithType = input.refresh
            .map { MessageType.send }

        Publishers.Merge3(input.viewDidLoad, input.segmentControlValueChanged, refreshWithType)
            .sink(receiveValue: { [weak self] type in
                self?.fetchMessages(with: type)
                self?.sendCurrentIndex(at: type)
            })
            .store(in: &self.cancelBag)

        return Output(messages: self.messageSubject, index: self.indexSubject)
    }

    // MARK: - Private - func

    private func sendCurrentIndex(at type: MessageType) {
        let currentIndex = self.currentIndex(at: type)
        self.indexSubject.send(currentIndex)
    }

    private func fetchMessages(with type: MessageType) {
        let roomId = "" // TODO: - roomId 넣기

        switch type {
        case .send: self.fetchSendMessages(roomId: roomId)
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
            } catch {
                self.messageSubject.send([])
            }
        }
    }

    private func fetchReceivedMessages(roomId: String) {
        Task {
            do {
                let messages = try await self.service.fetchReceiveLetter(roomId: roomId)
                self.messageSubject.send(messages)
            } catch {
                self.messageSubject.send([])
            }
        }
    }
}
