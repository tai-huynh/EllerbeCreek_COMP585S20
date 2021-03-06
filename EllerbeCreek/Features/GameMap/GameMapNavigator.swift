//
//  GameMapNavigator.swift
//  Ellerbe Creek
//
//  Created by Ryan Anderson on 2/3/20.
//  Copyright © 2020 Ryan Anderson. All rights reserved.
//

import UIKit

class GameMapNavigator: Navigator {
    enum Destination {
        case profile
        case sighting(_ sighting: Sighting)
        case newSession(_ preserve: Preserve)
        case sessionDetail( _ session: Session)
    }
    
    var dependencyContainer: CoreDependencyContainer & KeyValueStorable
    
    init(dependencyContainer: CoreDependencyContainer & KeyValueStorable) {
        self.dependencyContainer = dependencyContainer
    }
    
    func navigate(to destination: GameMapNavigator.Destination) {
        let viewController = makeViewController(for: destination)
        dependencyContainer.navigationController.viewControllers = [viewController]
    }
    
    func present(_ destination: Destination, with presentationStyle: UIModalPresentationStyle = .fullScreen) {
        if let rootController = dependencyContainer.navigationController.viewControllers.first {
            let viewController = makeViewController(for: destination)
            viewController.modalPresentationStyle = presentationStyle
            viewController.modalPresentationCapturesStatusBarAppearance = true
            rootController.present(viewController, animated: true, completion: nil)
        }
    }
    
    private func makeViewController(for destination: Destination) -> UIViewController {
        switch destination {
        case .profile:
            let controller = dependencyContainer.makeProfileViewController()
            dependencyContainer.profileNavigationController.viewControllers = [controller]
            return dependencyContainer.profileNavigationController
        case .sighting(let sighting):
            return dependencyContainer.makeSightingViewController(sighting: sighting)
        case .newSession(let preserve):
            return dependencyContainer.makeNewSessionViewController(preserve: preserve)
        case .sessionDetail(let session):
            return dependencyContainer.makeSessionDetailViewController(session: session)
        }
    }
}
