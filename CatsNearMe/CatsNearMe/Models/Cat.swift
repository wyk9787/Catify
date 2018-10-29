//
//  Cat.swift
//  CatsNearMe
//
//  Created by Ziwen Chen on 10/6/18.
//  Copyright © 2018 Ziwen Chen. All rights reserved.
//

import UIKit

let host = "http://garrettwyk.com"
let img_path = host + "/pic/"

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
    
    static func imageOrientation(_ src:UIImage)->UIImage {
        if src.imageOrientation == UIImage.Orientation.up {
            return src
        }
        var transform: CGAffineTransform = CGAffineTransform.identity
        switch src.imageOrientation {
        case UIImage.Orientation.down, UIImage.Orientation.downMirrored:
            transform = transform.translatedBy(x: src.size.width, y: src.size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
            break
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored:
            transform = transform.translatedBy(x: src.size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
            break
        case UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            transform = transform.translatedBy(x: 0, y: src.size.height)
            transform = transform.rotated(by: CGFloat(-Double.pi / 2))
            break
        case UIImage.Orientation.up, UIImage.Orientation.upMirrored:
            break
        }
        
        switch src.imageOrientation {
        case UIImage.Orientation.upMirrored, UIImage.Orientation.downMirrored:
            transform.translatedBy(x: src.size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
            break
        case UIImage.Orientation.leftMirrored, UIImage.Orientation.rightMirrored:
            transform.translatedBy(x: src.size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case UIImage.Orientation.up, UIImage.Orientation.down, UIImage.Orientation.left, UIImage.Orientation.right:
            break
        }
        
        let ctx:CGContext = CGContext(data: nil, width: Int(src.size.width), height: Int(src.size.height), bitsPerComponent: (src.cgImage)!.bitsPerComponent, bytesPerRow: 0, space: (src.cgImage)!.colorSpace!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue)!
        
        ctx.concatenate(transform)
        
        switch src.imageOrientation {
        case UIImage.Orientation.left, UIImage.Orientation.leftMirrored, UIImage.Orientation.right, UIImage.Orientation.rightMirrored:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.height, height: src.size.width))
            break
        default:
            ctx.draw(src.cgImage!, in: CGRect(x: 0, y: 0, width: src.size.width, height: src.size.height))
            break
        }
        
        let cgimg:CGImage = ctx.makeImage()!
        let img:UIImage = UIImage(cgImage: cgimg)
        
        return img
    }
    
    static func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    static func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: Data, boundary: String) -> Data {
        let body = NSMutableData();
        
        let mimetype = "image/jpg"
        
        body.append("------\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"tmp.jpg\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageDataKey)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("------\(boundary)--".data(using: String.Encoding.utf8)!)
        
        return body as Data
    }
    
    //------------
    // helper for converting dict to cats
    static func convert(result:Array<Dictionary<String, Any>>) -> [Cat] {
        var cats : [Cat] = []
        for r in result {
            /*TO BE CHANGED*/
            let neutered = false
            /*
            if (r["neutered"]as!String=="true") {
                neutered = true
            }
 */
            let ldata = r["location"] as! Array<NSDictionary>
            var locations : [(Double, Double)] = []
            for l in ldata {
                locations.append((l["lat"]! as! Double, l["lon"]! as! Double))
            }
            let idata = r["images"] as! Array<String>
            var images : [UIImage] = []
            for i in idata {
                let imageURL = URL(string: img_path+i)
                let image = UIImage(data: try! Data(contentsOf: imageURL!))
                images.append(image!)
            }
            let cdata = r["center"] as! NSDictionary
            let center = (cdata["lat"]! as! Double,cdata["lon"]! as! Double)
            
            let cat = Cat.init(id: r["id"] as! Int, name: r["name"] as! String, color: r["color"] as! String, locations: locations, center:center, images: images, neutered: neutered, /*TO BE CHANGED*/owner: "None",breed:r["breed"] as! String)
            cats.append(cat)
        }
        return cats
    }
    //--------------------
    
    class func debug(completion : @escaping () -> Void) -> Void {
        let params = [
            "test": "testttt"
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        let url = URL(string: host+"/debug?"+urlParams)
        print("URLLLLLLLL"+host+"/debug?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            print(String(decoding: data!, as: UTF8.self))
            if (error != nil) {
                print("Failure in debug!")
                completion()
                return
            }
            
            completion()
        })
        task.resume()
    }
    
    class func newcat(name:String,completion : @escaping (Bool) -> Void) -> Void {
        
        let params = [
            "name": name
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        let url = URL(string: host+"/newcat?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
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
 
    }
    
    class func confirm(id:Int,completion : @escaping (Bool) -> Void) -> Void {
        //completion(true)
        
        
        let params = [
            "id": String(id)
        ]
        let urlParams = params.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        let url = URL(string: host+"/confirm?"+urlParams)
        let session = URLSession(configuration: .default)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
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
    }
    
    class func findsimilar(lon:Double,lat:Double,color:String,image:UIImage,completion : @escaping ([Cat]) -> Void) -> Void {
    
        /*
        var cats : [Cat] = []
        let cat1 = Cat.init(id: 1, name: "Michelangelo", color: "mixed", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "446")], neutered: false, owner: "None", breed: "American shorthair")
        cats.append(cat1)
        
        let cat2 = Cat.init(id: 2, name: "Cosimo", color: "mixed", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "448")], neutered: true, owner: "Micheal", breed: "American shorthair")
        cats.append(cat2)
        
        let cat3 = Cat.init(id: 3, name: "Sera", color: "grey", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "447")], neutered: true, owner: "None", breed: "American shorthair")
        cats.append(cat3)
        
        let cat4 = Cat.init(id: 4, name: "Molly", color: "grey", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "438")], neutered: false, owner: "None", breed: "American shorthair")
        cats.append(cat4)
        
        completion(cats)
 */
        
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
        
        request.setValue("multipart/form-data; boundary=----\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let image_oriented = imageOrientation(image)
        
        let imageData = image_oriented.jpegData(compressionQuality: 1)
        
        if (imageData == nil){
            print("nil image data")
        }
        
        let fullData = createBodyWithParameters(parameters:nil, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        request.setValue(String(fullData.count), forHTTPHeaderField: "Content-Length")
        
        request.httpBody = fullData
        request.httpShouldHandleCookies = false
        
        let task = session.dataTask(with: request,completionHandler: {
            (data, response, error) -> Void in
            if (error != nil) {
                print("Failed to load similar cats!")
                return
            }
            print("Got similar cats!")
            //print(String(decoding: data!, as: UTF8.self))
            let result = try? JSONSerialization.jsonObject(with: data!, options: []) as! Array<Dictionary<String, Any>>
            let cats : [Cat] = convert(result: result!)
            
            completion(cats)
        })
        task.resume()
 
    }
    
    class func allcats(lon:Double,lat:Double,completion : @escaping ([Cat]) -> Void) -> Void {
        /*
        
        var cats : [Cat] = []
        let cat1 = Cat.init(id: 1, name: "Michelangelo", color: "mixed", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "446")], neutered: false, owner: "None", breed: "American shorthair")
        cats.append(cat1)
        
        let cat2 = Cat.init(id: 2, name: "Cosimo", color: "mixed", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "448")], neutered: true, owner: "Micheal", breed: "American shorthair")
        cats.append(cat2)
        
        let cat3 = Cat.init(id: 3, name: "Sera", color: "grey", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "447")], neutered: true, owner: "None", breed: "American shorthair")
        cats.append(cat3)
        
        let cat4 = Cat.init(id: 4, name: "Molly", color: "grey", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "438")], neutered: false, owner: "None", breed: "American shorthair")
        cats.append(cat4)
        
        let cat5 = Cat.init(id: 6, name: "Coconut", color: "yellow", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "cat4")], neutered: false, owner: "Garrett", breed: "Domestic shorthair")
        cats.append(cat5)
        
        let cat6 = Cat.init(id: 6, name: "Saseme", color: "black", locations: [(41.755,-92.725),(41.75,-92.715),(41.748,-92.72),(41.74,-92.72)], center: (41.74915,-92.7201), images:[#imageLiteral(resourceName: "cat")], neutered: false, owner: "Garrett", breed: "Domestic shorthair")
        cats.append(cat6)
        
        completion(cats)
 */
 
        let params = [
            "lon": String(lon),
            "lat": String(lat),
            "dis": "10000"
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
            //print(String(decoding: data!, as: UTF8.self))
            let result = try? JSONSerialization.jsonObject(with: data!, options: []) as! Array<Dictionary<String, Any>>
            let cats : [Cat] = convert(result: result!)
            
            completion(cats)
        }
        task.resume()
 
    }
 

}
