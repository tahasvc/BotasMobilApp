//
//  ReportsViewController.swift
//  BotasMobilApp
//
//  Created by Admin on 21.05.2019.
//  Copyright © 2019 tahasvc. All rights reserved.
//

import Foundation
class ReportsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layer.cornerRadius=20
    }
    @IBAction func hatVanaPeriyodikClick(_ sender: Any) {
        ViewController.delegate.presentDialogViewController(HatVanaPeriyodikViewController(nibName: "HatVanaPeriyodikForm", bundle: nil))
    }
    @IBAction func pigKovanClick(_ sender: Any) {
        ViewController.delegate.presentDialogViewController(HatVanaPeriyodikViewController(nibName: "PigKovanView", bundle: nil))
    }
    @IBAction func hasarTamirClick(_ sender: Any) {
        ViewController.delegate.presentDialogViewController(HatVanaPeriyodikViewController(nibName: "HasarTamirView", bundle: nil))
    }
    @IBAction func petrolBoruHatClick(_ sender: Any) {
        ViewController.delegate.presentDialogViewController(HatVanaPeriyodikViewController(nibName: "PetrolBoruHatView", bundle: nil))
    }
}
