//
//  UIScrollView+Combine.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/22.
//

import Combine
import UIKit

enum ScrollViewEvent {
    case didScroll(scrollView: UIScrollView)
}

extension UIScrollView {
    func eventPublisher(for event: ScrollViewEvent) -> EventPublisher {
        return EventPublisher(scrollView: self)
    }

    struct EventPublisher: Publisher {
        typealias Output = ScrollViewEvent
        typealias Failure = Never

        let scrollView: UIScrollView

        func receive<S>(subscriber: S)
        where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
            let subscription = EventSubscription<S>(target: subscriber)
            subscriber.receive(subscription: subscription)
            scrollView.delegate = subscription
        }
    }

    final class EventSubscription<Target: Subscriber>: NSObject, UIScrollViewDelegate, Subscription
    where Target.Input == ScrollViewEvent {

        var target: Target?

        init(target: Target) {
            self.target = target
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            target = nil
        }

        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            _ = target?.receive(.didScroll(scrollView: scrollView))
        }
    }
}

extension UIScrollView {
    var scrollPublisher: AnyPublisher<Void, Never> {
        eventPublisher(for: .didScroll(scrollView: self))
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}

