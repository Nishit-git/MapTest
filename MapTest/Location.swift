//
//  Location.swift
//  MapTest
//
//  Created by Nishit on 2017-10-15.
//  Copyright © 2017 Nishit. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class Location {
    var name: String?
    var boundary: [CLLocationCoordinate2D] = []
     var midCoordinate = CLLocationCoordinate2D()
    
    //Get the file name and property list
    class func plist(_ plist: String) -> Any? {
        
        let filePath = Bundle.main.path(forResource: plist, ofType: "plist")!
        let data = FileManager.default.contents(atPath: filePath)!
        return try! PropertyListSerialization.propertyList(from: data, options: [], format: nil)
        
    }
    //Get the Coordinate values from the properties
    static func parseCoord(dict: [String: Any], fieldName: String) -> CLLocationCoordinate2D {
        guard let coord = dict[fieldName] as? String else {
            return CLLocationCoordinate2D()
        }
        let point = CGPointFromString(coord)
        return CLLocationCoordinate2DMake(CLLocationDegrees(point.x), CLLocationDegrees(point.y))
    }
    
    //Initializer
    init(filename: String) {
        guard let properties = Location.plist(filename) as? [String : Any],
            let boundaryPoints = properties["boundary"] as? [String] else { return }
        
        //midCoordinate = Location.parseCoord(dict: properties, fieldName: "midCoord")
        
        let cgPoints = boundaryPoints.map { CGPointFromString($0) }
        boundary = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
    }
    
    init(loc: Location) {
       
    }
}
