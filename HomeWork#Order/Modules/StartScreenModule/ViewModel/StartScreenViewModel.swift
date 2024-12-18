

import Combine

final class StartScreenViewModel {
    private(set) var navigationSubscribtion = PassthroughSubject<ButtonIdentifier, Never>()
    
    func navigateToNextScreen(clickedButtonType: ButtonIdentifier) {
        navigationSubscribtion.send(clickedButtonType)
    }
}
