//
//  Cat.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

let host = "127.0.0.1"

extension NSMutableData {
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

class Cat: NSObject {
    var id:Int
    var name:String
    var color:String
    var locations:[(Double,Double)]
    var center:(Double,Double)
    var neutered:Bool
    var owner:String
    var breed:String
    
    var images:[UIImage]
    
    init(id:Int, name:String, color:String, locations:[(Double,Double)],center:(Double,Double),images:[UIImage], neutered:Bool, owner:String, breed:String) {
        self.id = id
        self.name = name
        self.color = color
        self.locations = locations
        self.center = center
        self.images = images
        self.neutered = neutered
        self.owner = owner
        self.breed = breed
    }
    
    //helpers for image---------
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    static func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString(string: "--\(boundary)\r\n")
                body.appendString(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString(string: "\(value)\r\n")
            }
        }
        
        let filename = "user-profile.jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString(string: "--\(boundary)\r\n")
        body.appendString(string: "Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString(string: "Content-Type: \(mimetype)\r\n\r\n")
        body.append(imageDataKey)
        body.appendString(string: "\r\n")
        
        body.appendString(string: "--\(boundary)--\r\n")
        
        return body as Data
    }
    
    //------------
    // helper for converting dict to cats
    static func convert(result:Array<Dictionary<String, Any>>) -> [Cat] {
        var cats : [Cat] = []
        for r in result {
            var neutered = false
            if (r["neutered"]as!String=="true") {
                neutered = true
            }
            let ldata = r["locations"] as! Array<Dictionary<String,String>>
            var locations : [(Double, Double)] = []
            for l in ldata {
                locations.append((Double(l["lat"]!) ?? 0, Double(l["lon"]!) ?? 0))
            }
            let idata = r["images"] as! Array<String>
            var images : [UIImage] = []
            for i in idata {
                let imageURL = URL(string: i)
                let image = UIImage(data: try! Data(contentsOf: imageURL!))
                images.append(image!)
            }
            let cdata = r["center"] as! Dictionary<String,String>
            let center = (Double(cdata["lat"]!)!,Double(cdata["lon"]!)!)
            
            let cat = Cat.init(id: Int(r["id"] as! String)!, name: r["name"] as! String, color: r["color"] as! String, locations: locations, center:center, images: images, neutered: neutered, owner: r["owner"] as! String,breed:r["breed"] as! String)
            cats.append(cat)
        }
        return cats
    }
    //--------------------
    
    class func newcat(name:String,completion : @escaping (Bool) -> Void) -> Void {
        completion(true)
        /*
        let params = [
            "name": name
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        let url = URL(string: host+"/newcat?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                print("Failed to add this cat!")
                completion(false)
                return
            }
            print("Added this cat!")
            completion(true)
        })
        task.resume()
 */
    }
    
    class func confirm(id:Int,completion : @escaping (Bool) -> Void) -> Void {
        completion(true)
        /*
        let params = [
            "id": String(id)
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        let url = URL(string: host+"/confirm?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        let task = session.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                print("Failed to confirm this cat!")
                completion(false)
                return
            }
            print("Confirmed this cat!")
            completion(true)
        })
        task.resume()
 */
    }
    
    class func findsimilar(lon:Double,lat:Double,color:String,image:UIImage,completion : @escaping ([Cat]) -> Void) -> Void {
        var cats : [Cat] = []
        let cat = Cat.init(id: 1, name: "Michelangelo", color: "mixed", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "1")], neutered: false, owner: "None", breed: "Domestic shorthair")
        
        cats.append(cat)
        
        completion(cats)
        
        /*
        let params = [
            "lon": String(lon),
            "lat": String(lat),
            "color": color
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        let url = URL(string: host+"/similarcats?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = image.jpegData(compressionQuality: 1)
        
        request.httpBody = createBodyWithParameters(parameters: [:], filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        //myActivityIndicator.startAnimating();
        
        let task = session.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                print("Failed to load similar cats!")
                return
            }
            print("Got similar cats!")
            let result = try? JSONSerialization.jsonObject(with: data!, options: []) as! Array<Dictionary<String, Any>>
            let cats : [Cat] = convert(result: result!)
            
            completion(cats)
        })
        task.resume()
 */
    }
    
    class func allcats(lon:Double,lat:Double,completion : @escaping ([Cat]) -> Void) -> Void {
        
        var cats : [Cat] = []
        let cat = Cat.init(id: 1, name: "Michelangelo", color: "mixed", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "1")], neutered: false, owner: "None", breed: "Domestic shorthair")
        
        cats.append(cat)
        
        completion(cats)
        
        /*
        let params = [
            "lon": String(lon),
            "lat": String(lat),
            "dis": "10"
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
            
            let result = try? JSONSerialization.jsonObject(with: data!, options: []) as! Array<Dictionary<String, Any>>
            let cats : [Cat] = convert(result: result!)
            
            completion(cats)
        }
        task.resume()
 */
    }

}
