//
//  ViewController.swift
//  CrudTask
//
//  Created by trioangle on 07/07/23.
//

import UIKit
import Alamofire
import CoreData

@available(iOS 13.0, *)
class DataVC: UIViewController {

    @IBOutlet weak var titLbl: UILabel!
    @IBOutlet weak var dataTblView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    var dataModel = [DataModel]()
    var dataInCache = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.callAPI()
        self.titLbl.text = "Employee Details"
        self.backBtn.setTitle("", for: .normal)
        self.addBtn.layer.cornerRadius = self.addBtn.frame.height / 2
        self.addBtn.setTitle("", for: .normal)
        self.fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataInCache.removeAll()
        self.dataTblView.reloadData()
        self.callAPI()
        
    }
    func initDelegates() {
        self.dataTblView.delegate = self
        self.dataTblView.dataSource = self
        self.dataTblView.reloadData()
    }
    
    func callAPI() {
        //var param = JSON()
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept-Charset": "utf-8"
        ]
        let url = "https://crudcrud.com/api/a1efeef5617f449d965aa2e59a132d2f/venkkat"
        AF.request(url,
                method: .get,
                parameters: nil,
                encoding: URLEncoding.default,
                headers: headers).response { response in
            print("api:",url)
            guard let data = response.data else {
                self.fetchData()
                return }
                    do {
                        let decoder = JSONDecoder()
                        let userData = try decoder.decode([DataModel].self, from: data)
                        self.dataModel = userData
                        print(self.dataModel)
                        print("Count::", self.dataModel.count)
                        self.openDatabse()
                    } catch let error {
                        print(error)
                    }
            print("response::", response)
            dump(response)
        }
    }
    
    func fetchData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContent = appDelegate.persistentContainer.viewContext
        let fetchData = NSFetchRequest<NSFetchRequestResult>(entityName: "CrudTask")
        do {
            let result = try manageContent.fetch(fetchData)
            self.dataInCache =  result as! [NSManagedObject]
            self.initDelegates()
        }catch {
            print("err")
        }
    }
    
    func openDatabse() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        let manageContent = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CrudTask")
        let userEntity = NSEntityDescription.entity(forEntityName: "CrudTask", in: manageContent)!
        for i in 0..<self.dataModel.count {
            fetchRequest.predicate = NSPredicate(format: "id == %@",self.dataModel[i].id)
            do {
                let notesList = try manageContent.fetch(fetchRequest)
                let result =  notesList as! [NSManagedObject]
                if result.count > 0 {
                    result[0].setValue(self.dataModel[i].id, forKey: "id")
                    result[0].setValue(self.dataModel[i].name, forKey: "name")
                    result[0].setValue(self.dataModel[i].email, forKey: "email")
                    result[0].setValue(self.dataModel[i].mobile, forKey: "mobile")
                }else{
                    let noteEn = NSEntityDescription.insertNewObject(forEntityName: "CrudTask", into: manageContent)
                    noteEn.setValue(self.dataModel[i].id, forKey: "id")
                    noteEn.setValue(self.dataModel[i].name, forKey: "name")
                    noteEn.setValue(self.dataModel[i].email, forKey: "email")
                    noteEn.setValue(self.dataModel[i].mobile, forKey: "email")
                }
            }catch{
                
            }
        }
        DispatchQueue.main.async {
            do{
                try manageContent.save()
            }catch let error as NSError {
                print("could not save . \(error), \(error.userInfo)")
            }
            self.fetchData()
        }
       // saveData(UserDBObj:newUser)
    }
    
    @IBAction func backTapped(sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addTapped(sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "AddEditVC") as! AddEditVC
        vc.isEdit = false
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }

}

@available(iOS 13.0, *)
extension DataVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataInCache.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataCell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath) as! DataCell
        dataCell.selectionStyle = .none
        let model = self.dataInCache[indexPath.row]
        dataCell.nameLbl.text = model.value(forKey: "name") as? String ?? ""
        dataCell.mobileLbl.text = model.value(forKey: "mobile") as? String ?? ""
        dataCell.emailLbl.text = model.value(forKey: "email") as? String ?? ""
        return dataCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = self.dataInCache[indexPath.row]
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(identifier: "AddEditVC") as! AddEditVC
        vc.user_id = model.value(forKey: "id") as? String ?? ""
        vc.isEdit = true
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}


