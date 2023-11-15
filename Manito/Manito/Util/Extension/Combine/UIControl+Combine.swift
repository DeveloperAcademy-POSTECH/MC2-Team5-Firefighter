//
//  UIControl+Combine.swift
//  Manito
//
//  Created by SHIN YOON AH on 2023/06/21.
//

import Combine
import UIKit

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
      }

    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never

        let control: UIControl
        let event: UIControl.Event

        func receive<S>(subscriber: S)
        where S: Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(
                control: self.control,
                subscriber: subscriber,
                event: self.event
            )
            subscriber.receive(subscription: subscription)
        }
    }

    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription
    where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {

        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?

        init(control: UIControl, subscriber: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscriber
            self.event = event

            control.addTarget(self, action: #selector(self.eventDidOccur), for: event)
        }

        func request(_ demand: Subscribers.Demand) {}

        func cancel() {
            self.subscriber = nil
            self.control.removeTarget(self, action: #selector(self.eventDidOccur), for: self.event)
        }

        @objc func eventDidOccur() {
            _ = self.subscriber?.receive(self.control)
        }
    }
}

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        self.controlPublisher(for: .touchUpInside)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}

extension UISegmentedControl {
    var tapPublisher: AnyPublisher<Void, Never> {
        self.controlPublisher(for: .valueChanged)
            .map { _ in Void() }
            .eraseToAnyPublisher()
    }
}

extension UISlider {
     var valuePublisher: AnyPublisher<Int, Never> {
         controlPublisher(for: .valueChanged)
             .map { $0 as! UISlider }
             .map { Int($0.value) }
             .eraseToAnyPublisher()
     }
 }
