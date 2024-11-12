//
//  ViewController.swift
//  MixedTable
//
//  Created by Irina Deeva on 11/11/24.
//

import UIKit

class ViewController: UIViewController {
    private lazy var tableView = UITableView()
    private lazy var navBar = UINavigationBar(frame: CGRect(x: 0,
                                                            y: 50,
                                                            width: UIScreen.main.bounds.size.width, height: 50))
    private var array = Array(0...30)
    private var dictionary = Dictionary(uniqueKeysWithValues: (0...30).map { ($0, false) })

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navBar)

        let navItem = UINavigationItem(title: "Task 4")
        let navBarButton = UIBarButtonItem(title: "Shuffle", style: .plain, target: self, action: #selector(shuffleTapped))
        navItem.rightBarButtonItem = navBarButton
        navBar.items = [navItem]

        tableView.dataSource = self
        tableView.delegate = self

        [tableView].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: navBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    @objc private func shuffleTapped() {
        array.shuffle()

        let range = NSMakeRange(0, self.tableView.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.tableView.reloadSections(sections as IndexSet, with: .automatic)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        if let reusedCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell = reusedCell
        } else {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }

        cell.textLabel?.text = "\(array[indexPath.row])"

        if dictionary[array[indexPath.row]] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }
}

extension ViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let cell = tableView.cellForRow(at: indexPath) else {
            return
        }

        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            dictionary[array[indexPath.row]] = false

        } else {
            cell.accessoryType = .checkmark
            dictionary[array[indexPath.row]] = true

            let element = array.remove(at: indexPath.row)
            array.insert(element, at: 0)

            let destinationIndexPath = IndexPath(row: 0, section: indexPath.section)
            tableView.moveRow(at: indexPath, to: destinationIndexPath)
        }
    }
}
