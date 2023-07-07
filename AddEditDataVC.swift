//
//  AddEditDataVC.swift
//  CrudTask
//
//  Created by trioangle on 07/07/23.
//

import Foundation
import UIKit
import Alamofire

class AddEditVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titLbl: UILabel!
    @IBOutlet weak var nameTitLbl: UILabel!
    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var nameTxtHolderView: UIView!
    @IBOutlet weak var mobileTitLbl: UILabel!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var mobileTxtHolderView: UIView!
    @IBOutlet weak var emailTitLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var emailTxtHolderView: UIView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var errorLbl: UILabel!
    
    var user_id = String()
    var isEdit = false
    var time = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setDelegates()
        self.initDesign()
    }
    
    func initDesign() {
        if self.isEdit == true {
            self.titLbl.text = "Edit Details"
        } else {
            self.titLbl.text = "Add Details"
        }
        self.backBtn.setTitle("", for: .normal)
        self.errorLbl.isHidden = true
        self.nameTxtHolderView.layer.cornerRadius = self.nameTxtHolderView.frame.height / 2
        self.nameTxtHolderView.layer.borderColor = UIColor.lightGray.cgColor
        self.nameTxtHolderView.layer.borderWidth = 0.5
        
        self.mobileTxtHolderView.layer.cornerRadius = self.mobileTxtHolderView.frame.height / 2
        self.mobileTxtHolderView.layer.borderColor = UIColor.lightGray.cgColor
        self.mobileTxtHolderView.layer.borderWidth = 0.5
        
        self.emailTxtHolderView.layer.cornerRadius = self.mobileTxtHolderView.frame.height / 2
        self.emailTxtHolderView.layer.borderColor = UIColor.lightGray.cgColor
        self.emailTxtHolderView.layer.borderWidth = 0.5
        
        self.nameTxtFld.placeholder = "Name"
        self.nameTxtFld.keyboardType = .default
        self.nameTxtFld.borderStyle = .none
        
        self.mobileTxtFld.placeholder = "Mobile"
        self.mobileTxtFld.keyboardType = .numberPad
        self.mobileTxtFld.borderStyle = .none
        
        self.emailTxtFld.placeholder = "E-Mail"
        self.emailTxtFld.keyboardType = .default
        self.emailTxtFld.borderStyle = .none
        
        self.submitBtn.layer.cornerRadius = self.submitBtn.frame.height / 2
    }
    
    func setDelegates() {
        self.nameTxtFld.delegate = self
        self.mobileTxtFld.delegate = self
        self.emailTxtFld.delegate = self
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
    
    func callPostAPI() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept-Charset": "utf-8"
        ]
        var params = [String: Any]()
        params["name"] = self.nameTxtFld.text!
        params["email"] = self.emailTxtFld.text!
        params["mobile"] = self.mobileTxtFld.text!
        
        let url = "https://crudcrud.com/api/a1efeef5617f449d965aa2e59a132d2f/venkkat"
        AF.request(url,
                method: .post,
                parameters: params,
                encoding: URLEncoding.default,
                headers: headers).response { response in
            print("api:",url)
            guard let data = response.data else {
                //self.fetchData()
                return }
                    do {
                        self.errorLbl.isHidden = true
                        self.dismiss(animated: true)
                    } catch let error {
                        print(error)
                        self.errorLbl.text = error.localizedDescription
                        self.startTimer()
                    }
            print("response::", response)
            dump(response)
        }
    }
    
    func callUpdateAPI() {
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept-Charset": "utf-8"
        ]
        var params = [String: Any]()
        params["name"] = self.nameTxtFld.text!
        params["email"] = self.emailTxtFld.text!
        params["mobile"] = self.mobileTxtFld.text!
        params["id"] = self.user_id
        
        let url = "https://crudcrud.com/api/a1efeef5617f449d965aa2e59a132d2f/venkkat"
        AF.request(url,
                method: .put,
                parameters: params,
                encoding: URLEncoding.default,
                headers: headers).response { response in
            print("api:",url)
            print(params)
            guard let data = response.data else {
                //self.fetchData()
                return }
                    do {
                        let decoder = JSONDecoder()
                        let userData = try decoder.decode([DataModel].self, from: data)
                        dump(data)
                        self.dismiss(animated: true)
                    } catch let error {
                        print(error)
                        self.errorLbl.text = error.localizedDescription
                        self.startTimer()
                    }
            print("response::", response)
            dump(response)
        }
    }
    
    @IBAction func backTapped(sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func submitTapped(sender: Any) {
        if self.isEdit == true {
            self.callUpdateAPI()
        } else {
            self.callPostAPI()
        }
    }
}

extension AddEditVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin...")
    }
    
    @IBAction
    private func textFieldDidChange(textField: UITextField) {
        //self.checkNextButtonStatus()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
