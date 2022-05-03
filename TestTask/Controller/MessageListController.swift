//
//  MessageListController.swift
//  TestTask
//
//  Created by Vadim Novikov on 18.04.2022.
//

import UIKit

class MessageListController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var messages = [String]()
    var isLoading = false
    var currentRow = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(MessageCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = .none
        let tableViewLoadingCellNib = UINib(nibName: "LoadingCell", bundle: nil)
        self.tableView.register(tableViewLoadingCellNib, forCellReuseIdentifier: "loadingCellId")
        self.tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            loadMoreData()
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return messages.count
        } else if section == 1 {
            return 1
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            let message = messages[indexPath.row]
            var content = cell.defaultContentConfiguration()
            content.text = message
            cell.contentConfiguration = content
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
            } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "loadingCellId", for: indexPath) as! LoadingCell
            cell.activityIndicator.startAnimating()
            cell.contentView.transform = CGAffineTransform(scaleX: 1, y: -1)
            return cell
            }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableView.automaticDimension
        } else {
            return 55
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if (offsetY > contentHeight - scrollView.frame.height) && !isLoading {
        loadMoreData()
        }
    }

// MARK: - Network

    let baseURL = "https://numero-logy-app.org.in/getMessages?"
    var url: URL { return URL(string: "\(baseURL)offset=\(currentRow)")! }

    func loadMoreData() {
        if !isLoading {
            isLoading = true
            URLSession(configuration: URLSessionConfiguration.default).dataTask(with: url) { data,
                                                                                             response,
                                                                                             error in
                guard let data = data else {
                    self.showAlert()
                    return }
                guard let messages = try? JSONDecoder().decode(MessageList.self, from: data) else {
                self.isLoading = false
                self.showAlert()
                return
                }
                self.messages += messages.result
                sleep(3)
                self.currentRow += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.isLoading = false
                }
            }.resume()
        }
    }
    
// MARK: - Network problem alert

    func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Network error", message: "Please wait...",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default) { action in
                self.loadMoreData()
            })
            self.present(alert, animated: true, completion: nil)
        }
    }
}
