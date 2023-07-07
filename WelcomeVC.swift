//
//  WelcomeVC.swift
//  CrudTask
//
//  Created by trioangle on 07/07/23.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class WelcomeVC: UIViewController {
    @IBOutlet weak var welcomeLbl: UILabel!
    @IBOutlet weak var getStartedBtn: UIButton!
    @IBOutlet weak var otherBtnStackView: UIStackView!
    @IBOutlet weak var mapBtn: UIButton!
    @IBOutlet weak var dataBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    var time = 5
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.welcomeLbl.text = "Welcome to Data Saver"
        self.otherBtnStackView.isHidden = true
        self.errorLbl.isHidden = true
    }
    
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.time > 0 {
                print ("\(self.time) seconds")
                self.time -= 1
                self.errorLbl.isHidden = false
            } else {
                Timer.invalidate()
                self.errorLbl.isHidden = true
            }
        }
    }
    
    @IBAction func getStartedTapped(sender: Any) {
        self.otherBtnStackView.isHidden = false
    }
    
    @IBAction func mapTapped(sender: Any) {
        self.errorLbl.text = "Google Key missing..."
        self.startTimer()
    }
    
    @IBAction func dataTapped(sender: Any) {
        let dataVC = self.storyBoard.instantiateViewController(withIdentifier: "DataVC") as! DataVC
        dataVC.modalPresentationStyle = .fullScreen
        self.present(dataVC, animated: true)
    }
}
