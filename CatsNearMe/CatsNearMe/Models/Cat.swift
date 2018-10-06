//
//  Cat.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

let host = "127.0.0.1"

class Cat: NSObject {
    var name:String
    var color:String
    var locations:[(Double,Double)]
    var neutered:Bool
    var owner:String
    var breed:String
    
    var images:[UIImage]
    
    init(name:String, color:String, locations:[(Double,Double)],images:[UIImage], neutered:Bool, owner:String, breed:String) {
        self.name = name
        self.color = color
        self.locations = locations
        self.images = images
        self.neutered = neutered
        self.owner = owner
        self.breed = breed
    }
    
    class func allcats(lon:Double,lat:Double,completion : @escaping ([Cat]) -> Void) -> Void {
        let params = [
            "lon": String(lon),
            "lat": String(lat)
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        
        let url = URL(string: host+"/allcats?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                print("Failed to load cats!")
                return
            }
            print("Got our cats!")
            var cats : [Cat] = []
            let result = try? JSONSerialization.jsonObject(with: data!, options: []) as! Array<Dictionary<String, Any>>
            for r in result! {
                var neutered = false
                if (r["neutered"]as!String=="true") {
                    neutered = true
                }
                let ldata = r["locations"] as! Array<Dictionary<String,String>>
                var locations : [(Double, Double)] = []
                for l in ldata {
                    locations.append((Double(l["lon"]!) ?? 0, Double(l["lat"]!) ?? 0))
                }
                let idata = r["images"] as! Array<String>
                var images : [UIImage] = []
                for i in idata {
                    let imageURL = URL(string: i)
                    let image = UIImage(data: try! Data(contentsOf: imageURL!))
                    images.append(image!)
                }
                let cat = Cat.init(name: r["name"] as! String, color: r["color"] as! String, locations: locations, images: images, neutered: neutered, owner: r["owner"] as! String,breed:r["breed"] as! String)
                cats.append(cat)
            }
            
            completion(cats)
        }
        task.resume()
    }

}
