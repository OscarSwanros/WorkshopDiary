//
//  NoteViewController.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import UIKit
import WKDataClient

private extension Selector {
    static let addNoteTapped = #selector(InboxViewController.addNoteTapped)
}

private class EntryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class InboxViewController: UIViewController {
    let dataClient = WKDataClient.shared

    // MARK: Navigation
    private lazy var addNoteBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Add", style: .done, target: self, action: .addNoteTapped)
    }()

    // MARK: View Hierarchy
    private lazy var tableView: UITableView = {
        let t = UITableView(frame: .zero, style: .plain)
        t.dataSource = self

        t.translatesAutoresizingMaskIntoConstraints = false
        t.register(EntryCell.self, forCellReuseIdentifier: "Cell")

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
        return dataClient.entries.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(dataClient.entries[indexPath.item].title)"
        cell.detailTextLabel?.text = "\(dataClient.entries[indexPath.item].content)"
        return cell
    }
}

extension InboxViewController {
    @objc
    fileprivate func addNoteTapped() {
        let addNoteViewController = AddNoteViewController()
        addNoteViewController.delegate = self
        let nav = UINavigationController(rootViewController: addNoteViewController)
        present(nav, animated: true, completion: nil)
    }
}

extension InboxViewController: AddNoteViewControllerDelegate {
    func addNoteViewControllerDidCancel(_ viewController: AddNoteViewController) {
        dismiss(animated: true, completion: nil)
    }

    func addNoteViewController(_ viewController: AddNoteViewController, didAdd entry: DiaryEntry) {
        dismiss(animated: true, completion: nil)

        dataClient.entries.append(entry)

        let newIndexPath = IndexPath(row: dataClient.entries.count - 1, section: 0)
        tableView.insertRows(at: [newIndexPath], with: .automatic)
    }
}
