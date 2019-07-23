//
//  AddNoteViewController.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import UIKit
import WKDataClient
import MapKit

private extension Selector {
    static let cancelTapped = #selector(AddNoteViewController.cancelTapped)
    static let saveTapped = #selector(AddNoteViewController.saveTapped)
}

protocol AddNoteViewControllerDelegate: class {
    /**
     Notifies the view controller that the user has cancelled the operation.

     - Parameters:
        - viewController: The view controller that cancelled the operation.
     */
    func addNoteViewControllerDidCancel(_ viewController: AddNoteViewController)

    /**
     Notifies the view controller that the user has saved the information correctly.

     - Parameters:
        - viewController: The view controller that saved the entry.
        - newEntry: The entry that was just saved to the store.
     */
    func addNoteViewController(_ viewController: AddNoteViewController, didAdd newEntry: DiaryEntry)
}

private func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMM d, yyyy"

    return formatter.string(from: date)
}

final class AddNoteViewController: UIViewController {
    /// The delegate that will react to events from this view controller.
    weak var delegate: AddNoteViewControllerDelegate?

    private lazy var locationManager: CLLocationManager = {
        let l = CLLocationManager()
        l.delegate = self

        return l
    }()

    // MARK: Navigation
    private lazy var cancelBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: .cancelTapped)
    }()

    private lazy var saveBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(title: "Save", style: .done, target: self, action: .saveTapped)
    }()

    // MARK: View Hierarchy
    private lazy var scrollView: UIScrollView = {
        let s = UIScrollView(frame: .zero)
        s.translatesAutoresizingMaskIntoConstraints = false
        s.alwaysBounceVertical = true
        s.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)

        return s
    }()

    fileprivate lazy var titleTextField: UITextField = {
        let t = UITextField()
        t.placeholder = "Title"
        t.translatesAutoresizingMaskIntoConstraints =  false

        return t
    }()

    fileprivate lazy var noteTextView: UITextView = {
        let t = UITextView()

        t.translatesAutoresizingMaskIntoConstraints = false
        t.heightAnchor.constraint(greaterThanOrEqualToConstant: 180).isActive = true

        t.layer.borderColor = UIColor.black.cgColor
        t.layer.borderWidth = 0.5
        t.layer.cornerRadius = 4

        return t
    }()

    private lazy var mapView: MKMapView = {
        let m = MKMapView(frame: .zero)
        m.translatesAutoresizingMaskIntoConstraints = false
        m.heightAnchor.constraint(equalToConstant: 180).isActive = true

        return m
    }()

    private lazy var dateLabel: UILabel = {
        let l = UILabel(frame: .zero)
        l.text = format(date: Date())
        l.textColor = UIColor.lightGray
        l.textAlignment = .center
        return l
    }()

    private lazy var stackView: UIStackView = {
        let s = UIStackView(arrangedSubviews: [self.titleTextField, self.noteTextView, self.mapView, self.dateLabel])
        s.translatesAutoresizingMaskIntoConstraints = false
        s.axis = .vertical
        s.spacing = 20
        s.distribution = .fillProportionally

        return s
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure navigation option
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem

        // Configure view hierarchy
        view.backgroundColor = .white
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])


        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10)
            ])
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Request location permission
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        locationManager.stopUpdatingLocation()
    }
}


// MARK: - Actions
extension AddNoteViewController {
    @objc
    fileprivate func cancelTapped() {
        delegate?.addNoteViewControllerDidCancel(self)
    }

    @objc
    fileprivate func saveTapped() {
        let entry = DiaryEntry(
            title: titleTextField.text ?? "",
            content: noteTextView.text,
            coordinate: mapView.userLocation.coordinate
        )

        delegate?.addNoteViewController(self, didAdd: entry)
    }
}

extension AddNoteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        if status == .authorizedWhenInUse {
            self.mapView.showsUserLocation = true
        }

        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let firstLocation = locations.first else {
            return
        }

        let region = MKCoordinateRegion(center: firstLocation.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
}
