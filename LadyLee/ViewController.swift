//
//  ViewController.swift
//  LadyLeae
//
//  Created by Spence on 6/26/19.
//  Copyright © 2019 Olly. All rights reserved.
//

import UIKit

import Foundation


//array to collect JSON repsonse
//Woman Object
struct Woman {
    var name: String
    var imageUrl: String
    var desc: String
    var link: Any
}





class ViewController: UIViewController {

    @IBOutlet weak var nameOfPerson: UILabel!
    @IBOutlet weak var imageOfPerson: UIImageView!
    @IBOutlet weak var descriptionOfPerson: UILabel!

    @IBAction func loadNewName(_ sender: Any) {
      random()
    }
    
    var allWomen: [Woman?] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
   
      parseListOfWomen()
    
        
    }
    
    var womenList: String = "https://query.wikidata.org/sparql?query=SELECT%20%3Fperson%20%3Fname%20%3Fpic%20%3Flinkcount%0AWHERE%0A%7B%0A%20%20%3Fperson%20wdt%3AP31%20wd%3AQ5%20%3B%20%20%20%23%20human%0A%20%20%20%20%20wdt%3AP21%20wd%3AQ6581072%20%3B%20%20%23%20gender%3A%20female%0A%20%20%20%20%20wdt%3AP569%20%3Fborn%20.%0A%20%20FILTER%20(%3Fborn%20%3E%3D%20%221820-01-01T00%3A00%3A00Z%22%5E%5Exsd%3AdateTime)%20.%0A%20%20%3Fperson%20wdt%3AP18%20%3Fpic.%0A%20%20%3Fperson%20wikibase%3Asitelinks%20%3Flinkcount%20.%0A%20%20FILTER%20(%3Flinkcount%20%3E%2050)%20.%0A%20%20%3Fperson%20rdfs%3Alabel%20%3Fname%20FILTER(lang(%3Fname)%3D%22en%22).%0A%7D%0ALIMIT%20150%0A&format=json"
    
   
    
    func random (){
        let randWoman = allWomen.randomElement()!
       // var descString = randWoman.randomElement()
        let descString = randWoman!.desc
        let nameOfWomen = randWoman!.name
        let imageOfWomen = randWoman!.imageUrl
        let linkOfWomen = randWoman!.link
        
        let url = URL(string: imageOfWomen)!
        
            nameOfPerson.text = nameOfWomen
            descriptionOfPerson.text = descString
            imageOfPerson.load(url: url)

    }
    
    
    func makeRequestForWoman(url: String) -> NSArray {
        // Set the URL the request is being made to.
        var json: NSArray = []
        let request = URLRequest(url: NSURL(string: url)! as URL)
        do {
            // Perform the request
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
//            let data urlData = try NSURLSession.dataTaskWithRequest(request: request, completionHandler: <#((NSData!, NSURLResponse!, NSError!) -> Void)?##(NSData!, NSURLResponse!, NSError!) -> Void#>)

            // Convert the data to JSON
            json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! NSArray
            return json
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        return json
    }
    
    
    
    func getListOfWomen(url: String) -> [String:AnyObject]{
        // Set the URL the request is being made to.
        var json: [String:AnyObject] = [:]
        let request = URLRequest(url: NSURL(string: url)! as URL)
        
        
        do {
            // Perform the request
            let response: AutoreleasingUnsafeMutablePointer<URLResponse?>? = nil
            
            
            let data = try NSURLConnection.sendSynchronousRequest(request, returning: response)
            
            // Convert the data to JSON
            json = try JSONSerialization.jsonObject(with: data, options:.allowFragments) as! [String:AnyObject]
            return json
        }catch {
            print(error)
        }
        return json
    }
    
    
    
    
    
    func parseListOfWomen() {
        
        let lst = getListOfWomen(url: womenList)
        var url : URL = URL(string: "test")!

        
        if let results = lst["results"] as? [String:AnyObject] {
            
            if let people = results["bindings"] as? NSArray {
                for person in people {
                    
                    do {
                        var newPerson = Woman(name: "", imageUrl: "", desc: "", link: "")
                      
                        if let person = person as? [String:AnyObject] {
                            if let nameData = person["name"] as? [String:AnyObject] {
                                if let actualName = nameData["value"] as? String {
                                    newPerson.name = actualName
                                }
                            }
                            if let pictureData = person["pic"] as? [String: AnyObject] {
                                if let actualPicture = pictureData["value"] as? String {
                                    newPerson.imageUrl = actualPicture
                                    
                                    
                                    
                                    print(newPerson.imageUrl)
                                }
                            }
                        }
                         nameOfPerson?.text = newPerson.name
                        url = URL(string: newPerson.imageUrl)!
                        
                        
                        //print(descriptionOfPerson?.text)
                        var search = newPerson.name
                        
                        search = search.stringByAddingPercentEncodingForRFC3986() ?? " "
                        
                        if(!(search.isEmpty)){
                            print(search)
                           // print(url)
                          //  print(newPerson.desc)
                            var searchName = ""
                            for character in search {
                                if (character == " ") {
                                    searchName += "%20"
                                } else {
                                    searchName += String(character)
                                }
                            }
                            
                            let searchUrl = "https://en.wikipedia.org/w/api.php?action=opensearch&search=" + searchName + "&limit=1&format=json"
                            let data = makeRequestForWoman(url: searchUrl)
                            //print(searchUrl)
                            
                            
                            if let description = data[2] as? NSArray {
                                newPerson.desc = description[0] as! String
                                descriptionOfPerson?.text = newPerson.desc
                                //print(newPerson.desc)

                            }
                            
                            if let linkHolder = data[3] as? NSArray {
                                newPerson.link = linkHolder[0]
                            }
                            
                            allWomen.append(newPerson)
                            
                        } else {
                            print("error")
                        }
                    }
                } // Closes for loop
                imageOfPerson?.load(url: url)

            }
        }
    }
    
    

    
    
    

    
    

    


}

