//
//  ViewControllerExtension.swift
//  RumblApp
//
//  Created by Umamaheshwari on 30/01/20.
//  Copyright © 2020 Umamaheshwari. All rights reserved.
//

import UIKit

extension UIViewController {

    func presentDetail(_ viewControllerToPresent: UIViewController) {
        DispatchQueue.main.async {
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.push
            transition.subtype = CATransitionSubtype.fromRight
            self.view.window?.layer.add(transition, forKey: kCATransition)

            self.present(viewControllerToPresent, animated: false)
        }
        
    }

    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromLeft
        self.view.window?.layer.add(transition, forKey: kCATransition)

        self.dismiss(animated: false)
    }
}
