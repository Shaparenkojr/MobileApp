

import Foundation
import UIKit

final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
}

private extension NavigationController {
    
    func setupNavigation() {
        let startVM = StartScreenViewModel()
        let startScreen = StartScreenViewController(viewModel: startVM)
        viewControllers = [startScreen]
    }
}

