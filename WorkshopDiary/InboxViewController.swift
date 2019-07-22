//
//  NoteViewController.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import UIKit

private extension Selector {
    static let addNoteTapped = #selector(InboxViewController.addNoteTapped)
}

let store: [String] = [
    "Had an excellent day!",
    "Got some ice cream",
    "Went to the beach and I'm feeling great!",
    "Had a chat with my boss about my raise",
    "Got engaged!"
]

final class InboxViewController: UIViewController {
    // MARK: Navigation
    private lazy var addNoteBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Add", style: .done, target: self, action: .addNoteTapped)
    }()

    // MARK: View Hierarchy
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.dataSource = self

        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        return t
    }()

    // MARK: Lifecyucle
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Notes Inbox"

        navigationItem.rightBarButtonItem = addNoteBarButtonItem

        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

// MARK: Table View Data Source
extension InboxViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(store[indexPath.item])"
        return cell
    }
}

extension InboxViewController {
    @objc
    fileprivate func addNoteTapped() {
        let addNoteViewController = AddNoteViewController()
        let nav = UINavigationController(rootViewController: addNoteViewController)
        present(nav, animated: true, completion: nil)
    }
}
