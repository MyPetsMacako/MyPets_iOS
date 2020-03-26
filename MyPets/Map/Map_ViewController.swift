//
//  Map_ViewController.swift
//  MyPets
//
//  Created by alumnos on 14/02/2020.
//  Copyright © 2020 alumnos. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var global_coordinateOne = CLLocationCoordinate2D (latitude: 0.0, longitude:0.0)
var global_coordinateTwo = CLLocationCoordinate2D (latitude: 0.0, longitude:0.0)
var global_locationName = ""

enum LocationType {
    case vet
    case store
    case park
}

var searchField = ""

var firstLoad: Bool = true

class Map_ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var reloadButton: ReloadButtonBehaviour!

    @IBOutlet weak var vetsButton: CategoryButtonBehaviour!
    @IBOutlet weak var storesButton: CategoryButtonBehaviour!
    @IBOutlet weak var parksButton: CategoryButtonBehaviour!

    @IBOutlet weak var mapView: MKMapView!
    
    var searchedAnnotations_Array: Array<SearchedAnnotation> = []
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    
    
    var resultSearchController:UISearchController? = nil
    
    var matchingItems:[MKMapItem] = []
    //var mapView: MKMapView? = nil
    
    var isVetsEnable: Bool = false
    var isStoresEnable: Bool = false
    var isParksEnable: Bool = false
    var hiddeReloadButton:Bool = true
    
    /// Obtiene la localización actual.
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        reloadButton.isHidden = true
        ////////////////LOCALIZATION /////////////////////////////////////////////////////
        
        //let localizacion = CLLocationCoordinate2DMake
        //print(localizacion)
        
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.requestWhenInUseAuthorization()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
            
        }
        ///////////////////BARRA BÚSQUEDA/////////////////////////////////////////////////
        
        /*let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable as! UISearchResultsUpdating
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Buscar lugares"
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.dimsBackgroundDuringPresentation = true
        definesPresentationContext = true*/
    }
    
    /// Muestra en el mapa la localización del usuario y muedtra esa región.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        let currentLocation = CLLocation(latitude: locValue.latitude, longitude: locValue.longitude)
        let regionRadius: CLLocationDistance = 2000.0
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        
        mapView.setRegion(region, animated: true)
    }
    
    //////////////////FUNCIONES DE BÚSQUEDA/////////////////////////////////////////////
    func searchVeterinarians() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        searchField = "Veterinarians"
        
        searchedAnnotations_Array = []
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = mapView.region
        searchRequest.naturalLanguageQuery = searchField
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil{
                print("ERROR")
            } else {
                self.matchingItems = response!.mapItems
                //print(self.matchingItems)
                let type = self.assignType(searchField: searchField)
                print(type)
                self.createAnnotations(type: type)
                self.mapView.addAnnotations(self.searchedAnnotations_Array)
            }
        }
    }
    
    func searchStores() {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        searchField = "Pets Stores"
        
        searchedAnnotations_Array = []
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = mapView.region
        searchRequest.naturalLanguageQuery = searchField
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("ERROR")
            } else {
                self.matchingItems = response!.mapItems
                //print(self.matchingItems)
                let type = self.assignType(searchField: searchField)
                print(type)
                self.createAnnotations(type: type)
                self.mapView.addAnnotations(self.searchedAnnotations_Array)
            }
        }
    }
    
    func searchParks() {
        //Ignoring user
        UIApplication.shared.beginIgnoringInteractionEvents()
        searchField = "Dog Parks"
        
        searchedAnnotations_Array = []
        //Activity Indicator
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        self.view.addSubview(activityIndicator)
        //Create the search request
        let searchRequest = MKLocalSearch.Request()
        searchRequest.region = mapView.region
        searchRequest.naturalLanguageQuery = searchField
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        
        activeSearch.start { (response, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if response == nil {
                print("ERROR")
            } else {
                self.matchingItems = response!.mapItems
                //self.createAnnotations()
                let type = self.assignType(searchField: searchField)
                print(type)
                self.createAnnotations(type: type)
                self.mapView.addAnnotations(self.searchedAnnotations_Array)
            }
        }
    }
    
    ///////////////////////CREAR ANOTACIONES////////////////////////////////////////////
    func createAnnotations(type:LocationType){
        //var locations = matchingItems.count
        for location in matchingItems{
            let annotation = SearchedAnnotation(placemark: location.placemark, type: type)
            print(annotation)
            
            searchedAnnotations_Array.append(annotation)
        }
        //print(searchedAnnotations_Array)
    }
    
    class SearchedAnnotation:NSObject,MKAnnotation{
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var type: LocationType
        init(placemark:MKPlacemark, type:LocationType) {
            self.coordinate = placemark.coordinate
            self.title = placemark.name
            self.type = type
        }
    }
    
    func assignType(searchField:String) ->LocationType {
        switch searchField {
        case "Veterinarians":
            return .vet
        case "Pets Stores":
            return .store
        case "Dog Parks":
            return .park
        default:
            return .vet
        }
    }
    
    
    
    ///////////////////BOTONES DE FILTROS///////////////////////////////////////////////
    @IBAction func vetsFilter(_ sender: Any) {
        if (isVetsEnable == false) {
            isVetsEnable = true
            isStoresEnable = false
            isParksEnable = false
            updateButtonState()
            removeAnnotations()
            searchVeterinarians()
        }else {
            isVetsEnable = false
            updateButtonState()
            removeAnnotations()
        }
    }
    
    @IBAction func storesFilter(_ sender: Any) {
        if (isStoresEnable == false) {
            isStoresEnable = true
            isVetsEnable = false
            isParksEnable = false
            updateButtonState()
            removeAnnotations()
            searchStores()
        }else {
            isStoresEnable = false
            updateButtonState()
            removeAnnotations()
        }
    }
    
    @IBAction func parksFilter(_ sender: Any) {
        if (isParksEnable == false) {
            isParksEnable = true
            isVetsEnable = false
            isStoresEnable = false
            updateButtonState()
            removeAnnotations()
            searchParks()
        }else {
            isParksEnable = false
            updateButtonState()
            removeAnnotations()
        }
    }
    
    ////////////////////////ACTUALIZACIÓN DE LOS BOTONES SEGÚN SU ESTADO/////////////////
    func updateButtonState() {
        let titleColorNormal: UIColor = .black
        let titleColorHighlighted: UIColor = .white
        let backgroundColorNormal: UIColor = .white
        let backgroundColorHighlighted: UIColor = .blue
        
        switch isVetsEnable {
        case true:
            vetsButton.backgroundColor = #colorLiteral(red: 0.5532273054, green: 0.8006074429, blue: 0.8887786269, alpha: 1)
            vetsButton.tintColor = titleColorHighlighted
            break
        case false:
            vetsButton.backgroundColor = backgroundColorNormal
            vetsButton.tintColor = titleColorNormal
            break
        default:
            print("error")
        }
        
        switch isStoresEnable {
        case true:
            storesButton.backgroundColor = #colorLiteral(red: 0.5532273054, green: 0.8006074429, blue: 0.8887786269, alpha: 1)
            storesButton.tintColor = titleColorHighlighted
            break
        case false:
            storesButton.backgroundColor = backgroundColorNormal
            storesButton.tintColor = titleColorNormal
            break
        default:
            print("error")
        }
        
        switch isParksEnable {
        case true:
            parksButton.backgroundColor = #colorLiteral(red: 0.5532273054, green: 0.8006074429, blue: 0.8887786269, alpha: 1)
            parksButton.tintColor = titleColorHighlighted
            break
        case false:
            parksButton.backgroundColor = backgroundColorNormal
            parksButton.tintColor = titleColorNormal
            break
        default:
            print("error")
        }
    }
    
    //////////////////////ELIMINA LAS ANOTACIONES EXISTENTES
    func removeAnnotations(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    ////////////////////BOTÓN PARA RECARGAR LA BÚSQUEDA//////////////////////////////////
    @IBAction func reloadButtonBehaviour(_ sender: Any) {
        reloadButton.isHidden = true
        
        if (isVetsEnable == true) {
            removeAnnotations()
            searchVeterinarians()
        }
        
        if (isStoresEnable == true) {
            removeAnnotations()
            searchStores()
        }
        
        if (isParksEnable == true) {
            removeAnnotations()
            searchParks()
        }
    }
    ////////////////FUNCIONES DEL MAP VIEW///////////////////////////////////
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = MKMarkerAnnotationView()
        
        guard let annotation = annotation as? SearchedAnnotation else {return nil}
        var identifier = ""
        var color = UIColor.red
        switch annotation.type{
        case .vet:
            identifier = "Vet"
            color = .red
        case .store:
            identifier = "Store"
            color = .orange
        case .park:
            identifier = "Park"
            color = .green
        }
        if let dequedView = mapView.dequeueReusableAnnotationView(
            withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            annotationView = dequedView
        } else{
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView.markerTintColor = color
        
        var glyphIcon = ""
        switch annotation.type {
        case .vet:
            glyphIcon = "vet"
            break
        case .store:
            glyphIcon = "bone"
            break
        case .park:
            glyphIcon = "tree"
            break
        }
        annotationView.glyphImage = UIImage(named: glyphIcon)
        annotationView.glyphTintColor = .white
        annotationView.canShowCallout = true
        annotationView.calloutOffset = CGPoint(x: 0, y: 20)
        let carButton = UIButton()
        carButton.setImage(UIImage(named :"car")?.withRenderingMode(.alwaysTemplate), for: .normal)
        carButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        carButton.addTarget(self, action: #selector(getDirections), for: .touchUpInside)
        annotationView.rightCalloutAccessoryView = carButton
        //annotationView.clusteringIdentifier = identifier
        return annotationView
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        //print("region cambiada")
        //let hiddeReloadButton:Bool = true
        if hiddeReloadButton == true {
            reloadButton.isHidden = true
        } else {
            hiddeReloadButton = true
        }
        if animated == false {
            hiddeReloadButton = true
            reloadButton.isHidden = false
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print("Seleccionado")
        if let selectedAnnotationCoords = view.annotation?.coordinate
        {
            let coordinateOne = CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude:(locationManager.location?.coordinate.longitude)!)
            let coordinateTwo = CLLocationCoordinate2D(latitude: selectedAnnotationCoords.latitude, longitude:selectedAnnotationCoords.longitude)
            //self.getDirections(loc1: coordinateOne, loc2: coordinateTwo)
            global_coordinateOne = coordinateOne
            global_coordinateTwo = coordinateTwo
            
            let locationName = view.annotation?.title
            global_locationName = locationName as! String
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: (locationManager.location?.coordinate.latitude)!, longitude: (locationManager.location?.coordinate.longitude)!), addressDictionary: nil))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: selectedAnnotationCoords.latitude, longitude: selectedAnnotationCoords.longitude), addressDictionary: nil))
            request.requestsAlternateRoutes = false
            request.transportType = .automobile
            
            let directions = MKDirections(request: request)
            
            directions.calculate { [unowned self] response, error in
                guard let unwrappedResponse = response else { return }
                
                for route in unwrappedResponse.routes {
                    self.mapView.addOverlay(route.polyline)
                }
            }
        }
    }
    @objc func getDirections (){
        
        let regionDistance:CLLocationDistance = 2000;
        let coordinates = CLLocationCoordinate2DMake(global_coordinateOne.latitude, global_coordinateOne.longitude)
        let regionSpan = MKCoordinateRegion(center: coordinates, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        
        let options = [MKLaunchOptionsMapCenterKey: NSValue(mkCoordinate: regionSpan.center), MKLaunchOptionsMapSpanKey: NSValue(mkCoordinateSpan: regionSpan.span)]
        
        let placemark = MKPlacemark(coordinate: global_coordinateTwo)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = global_locationName
        mapItem.openInMaps(launchOptions: options)
    }
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5;
        renderer.alpha = 0.5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        mapView.removeOverlays(mapView.overlays)
    }
    
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        if firstLoad == true {
            firstLoad = false
            isVetsEnable = true
            updateButtonState()
            removeAnnotations()
            searchVeterinarians()
        }
    }
}
