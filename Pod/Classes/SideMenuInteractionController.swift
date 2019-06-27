//
//  SideMenuInteractiveTransitionController.swift
//  SideMenu
//
//  Created by Jon Kent on 12/28/18.
//

import UIKit

internal protocol SideMenuInteractable {
    func handle(state: SideMenuInteractionController.State)
}

internal class SideMenuInteractionController: UIPercentDrivenInteractiveTransition {

    internal enum State { case
        update(progress: CGFloat),
        finish,
        cancel
    }

    private(set) var isCancelled: Bool = false
    private(set) var isFinished: Bool = false

    init(cancelWhenBackgrounded: Bool = true, completionCurve: UIView.AnimationCurve = .easeIn) {
        super.init()
        self.completionCurve = completionCurve

        if cancelWhenBackgrounded {
            NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: UIApplication.didEnterBackgroundNotification, object: nil)
        }
    }

    override func cancel() {
        isCancelled = true
        super.cancel()
    }

    override func finish() {
        isFinished = true
        super.finish()
    }

    override func update(_ percentComplete: CGFloat) {
        guard !isCancelled && !isFinished else { return }
        super.update(percentComplete)
    }
}

private extension SideMenuInteractionController {

    @objc func handleNotification(notification: NSNotification) {
        switch notification.name {
        case UIApplication.didEnterBackgroundNotification:
            cancel()
        default: break
        }
    }

}

extension SideMenuInteractionController: SideMenuInteractable {

    func handle(state: State) {
        switch state {
        case .update(let progress):
            update(progress)
        case .finish:
            finish()
        case .cancel:
            cancel()
        }
    }
}
