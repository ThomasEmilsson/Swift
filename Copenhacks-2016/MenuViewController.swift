//
//  MainViewController.swift
//  Copenhacks
//
//  Created by Thomas Emilsson on 4/16/16.
//  Copyright © 2016 Nathan Gitter. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MenuViewController: ViewController, MKMapViewDelegate {
    
    private var games = [Game]()
    
    private let navigationViewHeight: CGFloat = 50 + Metrics.statusBarHeight
    private let logotypeSize = CGSize(width: 150, height: 50)
    
    private let spinnerSize = CGSize(width: 30, height: 30)
    
    private let createGameButtonSize = CGSize(width: 65, height: 65)
    private let createGameButtonPadding: CGFloat = 15
    
    private var navigationView: UIView!
    private var logotypeImageView: UIImageView!
    
    private var collectionView: UICollectionView!
    private var spinner: UIActivityIndicatorView!
    private var mapView: MKMapView!
    private var createGameButton: CreateGameButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view configs
        self.view.backgroundColor = Colors.white
        self.title = "Main Menu"
        self.navigationController?.navigationBar.hidden = true
        
        // navigation view
        self.navigationView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.navigationViewHeight))
        self.navigationView.backgroundColor = Colors.blue
        self.view.addSubview(self.navigationView)
        
        // logotype
        self.logotypeImageView = UIImageView(frame: CGRect(x: self.view.frame.midX - self.logotypeSize.width / 2, y: Metrics.statusBarHeight, width: self.logotypeSize.width, height: self.logotypeSize.height))
        self.logotypeImageView.image = UIImage(image: Image.Logotype)
        self.navigationView.addSubview(self.logotypeImageView)
        
        // collection view
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.scrollDirection = UICollectionViewScrollDirection.Vertical
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: self.navigationView.frame.maxY, width: self.view.frame.size.width * 0.35, height: self.view.frame.height - self.navigationViewHeight), collectionViewLayout: layout)
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = Colors.lightGray
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.registerClass(GameCollectionViewCell.self, forCellWithReuseIdentifier: "GameCell")
        self.collectionView.showsVerticalScrollIndicator = true
        self.view.addSubview(self.collectionView)
        
        // spinner
        self.spinner = UIActivityIndicatorView(frame: CGRect(x: self.collectionView.frame.midX - self.spinnerSize.width / 2, y: self.collectionView.frame.midY - self.spinnerSize.height / 2, width: self.spinnerSize.width, height: self.spinnerSize.height))
        self.spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(self.spinner)
        
        // map view
        self.mapView = MKMapView(frame: CGRect(x: self.view.frame.width * 0.35, y: self.navigationView.frame.maxY, width: self.view.frame.size.width, height: self.view.frame.height - self.navigationView.frame.maxY))
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let location = Location.currentLocation
        let region = MKCoordinateRegion(center: location, span: span)
        self.mapView.setRegion(region, animated: true)
        self.mapView.zoomEnabled = true
        self.mapView.delegate = self
        self.view.addSubview(self.mapView)
        
        loadMapView()
        
        // create game button
        self.createGameButton = CreateGameButton(frame: CGRect(x: self.view.frame.maxX - self.createGameButtonSize.width - self.createGameButtonPadding, y: self.view.frame.maxY - self.createGameButtonSize.height - self.createGameButtonPadding, width: self.createGameButtonSize.width, height: self.createGameButtonSize.height))
        self.createGameButton.addTarget(self, action: #selector(MenuViewController.createGameButtonPressed), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.createGameButton)
        
        self.loadGames()
        
    }
    
    // MARK: - Helper Functions
    
    private func loadGames() {
        print("loading games")
        
        self.spinner.startAnimating()
        
        API.getGames({ games in
            print("got games")
            
            self.spinner.stopAnimating()
            
            self.games = games
            self.collectionView.reloadData()
            
        })
        
    }
    
    // MARK: - Button Functions
    
    private dynamic func createGameButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func loadMapView() {
        
        // CREATE PINS
        let copenhagen = Game(title: "Copenhagen", image: UIImage(), platforms: [], lat: 55.83915, lng: 12.56259)
        let  paris = Game(title: "Paris", image: UIImage(), platforms: [], lat: 48.856614, lng: 2.352222)
        let  london = Game(title: "London", image: UIImage(), platforms: [], lat: 37.871593, lng: -0.127758)
        let berkeley = Game(title: "Berkeley", image: UIImage(), platforms: [], lat: 55.83915, lng: -122.272747)
        let  gothenburg = Game(title: "Gothenburg", image: UIImage(), platforms: [], lat: 57.708870, lng: 11.974560)
        let  edinburgh = Game(title: "Edinburg", image: UIImage(), platforms: [], lat: 55.953252, lng: -3.188267)
        
        let newAnnotationCopenhagen = MKPointAnnotation()
        let newAnnotationParis = MKPointAnnotation()
        let newAnnotationLondon = MKPointAnnotation()
        let newAnnotationBerkeley = MKPointAnnotation()
        let newAnnotationGothenburg = MKPointAnnotation()
        let newAnnotationEdinburgh = MKPointAnnotation()
        
        
        newAnnotationCopenhagen.coordinate = CLLocationCoordinate2D(latitude: copenhagen.lat, longitude: copenhagen.lng)
        newAnnotationParis.coordinate = CLLocationCoordinate2D(latitude: paris.lat, longitude: paris.lng)
        newAnnotationLondon.coordinate = CLLocationCoordinate2D(latitude: london.lat, longitude: london.lng)
        newAnnotationBerkeley.coordinate = CLLocationCoordinate2D(latitude: berkeley.lat, longitude: berkeley.lng)
        newAnnotationGothenburg.coordinate = CLLocationCoordinate2D(latitude: gothenburg.lat, longitude: gothenburg.lng)
        newAnnotationEdinburgh.coordinate = CLLocationCoordinate2D(latitude: edinburgh.lat, longitude: edinburgh.lng)
        
        newAnnotationCopenhagen.title = "rasdf"
        newAnnotationCopenhagen.subtitle = "afsdf"
        
        mapView.addAnnotation(newAnnotationCopenhagen)
        mapView.addAnnotation(newAnnotationParis)
        mapView.addAnnotation(newAnnotationLondon)
        mapView.addAnnotation(newAnnotationBerkeley)
        mapView.addAnnotation(newAnnotationGothenburg)
        mapView.addAnnotation(newAnnotationEdinburgh)
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
}

// MARK: - Collection View Delegate Functions

extension MenuViewController: UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let game = self.games[indexPath.item]
        let playViewController = PlayViewController(game: game, editable: false)
        self.navigationController?.pushViewController(playViewController, animated: true)
    }
    
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = Colors.extraLightGray
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        cell?.backgroundColor = Colors.white
    }
    
}

extension MenuViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.games.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("GameCell", forIndexPath: indexPath) as! GameCollectionViewCell
        cell.game = self.games[indexPath.item]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: 50)
    }
    
}

extension MenuViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2
    }
    
}
