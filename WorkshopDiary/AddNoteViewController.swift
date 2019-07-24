//
//  AddNoteViewController.swift
//  WorkshopDiary
//
//  Created by Oscar Swanros on 7/22/19.
//  Copyright © 2019 Pacific3. All rights reserved.
//

import UIKit
import MapKit
import WKDataClient

private extension Selector {
    static let cancelTapped = #selector(AddNoteViewController.cancelTapped)
    static let saveTapped = #selector(AddNoteViewController.saveTapped)
}


protocol AddNoteViewControllerDelegate: class {
    func addNoteViewControllerDidCancel(_ viewController: AddNoteViewController)

    func addNoteViewController(_ viewController: AddNoteViewController, didAdd entry: DiaryEntry)
}

private func format(date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "EEEE, MMMM dd, YYYY"

    return formatter.string(from: date)
}

final class AddNoteViewController: UIViewController {

    weak var delegate: AddNoteViewControllerDelegate?

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

    private lazy var titleTextField: UITextField = {
        let t = UITextField()
        t.placeholder = "Title"
        t.translatesAutoresizingMaskIntoConstraints =  false

        return t
    }()

    private lazy var noteTextView: UITextView = {
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
        m.heightAnchor.constraint(equalToConstant: 180).isActive = true
        m.showsUserLocation = true
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

    private let locationManager = CLLocationManager()

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

        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        locationManager.stopUpdatingLocation()
    }
}

extension AddNoteViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            manager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.first else {
            return
        }

        let coordinates = lastLocation.coordinate
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)

        mapView.region = region
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

        let currentLocation = mapView.userLocation.coordinate
        let newEntry = DiaryEntry(
            title: titleTextField.text ?? "",
            content: noteTextView.text,
            coordinates: Coordinates(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
        )

        delegate?.addNoteViewController(self, didAdd: newEntry)
    }
}

