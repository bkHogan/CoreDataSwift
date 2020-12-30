//
//  ViewController.swift
//  CoreDataAssignment
//
//  Created by Field Employee on 12/29/20.
//

import UIKit

class ViewController: UITableViewController {

    let networking = NetworkingService.shared
    let persistence = PersistenceService.shared
    
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "PersistedDataUpdated"), object: nil, queue: .main) { (_) in
        }
        
        persistence.fetch(User.self) { [weak self] (users) in
            self?.users = users
            self?.tableView.reloadData()
        }
        
    }
    
    private func getUsers() {
        let urlPath = "https://anapioficeandfire.com/api/houses/"
        networking.request(urlPath) { [weak self] (result) in
            
            switch result {
            case .success(let data):
                do {
                    guard let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else { return }
                    
                    let users: [User] = jsonArray.compactMap {
                        guard
                            let strongSelf = self,
                            let name = $0["name"] as? String,
                            let region = $0["region"] as? String
                            else{ return nil }
                        
                        let user = User(context: strongSelf.persistence.context)
                        user.name = name
                        user.region = region
                        
                        return user
                    }
                    
                    self?.users = users
                    DispatchQueue.main.async {
                        self?.persistence.save()
                    }
                    
                    print(users)
                    
                }catch {
                    print(error)
                }
                
                
            case .failure(let error): print(error)
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name! + " are from  " + user.region!
        // cell.detailTextLabel?.text = ??
        return cell
    }
}

