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

let dummyContent = """
Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.
"""

var store: [DiaryEntry] = [
    DiaryEntry(title: "Had an excellent day!", content: dummyContent),
    DiaryEntry(title: "Got some ice cream", content: dummyContent),
    DiaryEntry(title: "Went to the beach and I'm feeling great!", content: dummyContent),
    DiaryEntry(title: "Had a chat with my boss about my raise", content: dummyContent),
    DiaryEntry(title: "Got engaged!", content: dummyContent)
]

final class DiaryCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

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
        t.register(DiaryCell.self, forCellReuseIdentifier: "Cell")

        return t
    }()

    // MARK: Lifecycle
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

        cell.textLabel?.text = "\(store[indexPath.item].title)"
        cell.detailTextLabel?.text = "\(store[indexPath.item].content)"

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

    func addNoteViewController(_ viewController: AddNoteViewController, didAdd newEntry: DiaryEntry) {
        // Dismiss the form.
        dismiss(animated: true, completion: nil)

        // First insert the new entry to our store.
        store.append(newEntry)

        // Then fabricate the index path.
        let indexPath = IndexPath(row: store.count - 1, section: 0)

        // Insert the row on the table view.
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
}
