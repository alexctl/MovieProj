//
//  CastPartViewController.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 16/04/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class CastPartViewController: UIViewController {


    @IBOutlet var collectionView: UICollectionView?
    
    
    var idMovie : Int32?
    var cast : [CastData] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let session = URLSession.shared
        let api_key = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        guard let idMovie = idMovie else{
            return
        }
        let urlString = "https://api.themoviedb.org/3/movie/\(idMovie)/credits?api_key=\(api_key)"
        let url = URL(string: urlString)
        
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let dataCast = json["cast"] as? [[String: AnyObject]]{
                    
                    self.cast = dataCast.reduce([]) {
                        (result, data) in
                        
                        var res = result
                        
                        let actor = CastData(data)
                        
                        res.append(actor)
                        
                        return res
                    }
                    
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                    
                }
            }
            
            task.resume()
        }
        // Do any additional setup after loading the view.
    }

}
extension CastPartViewController : UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cast.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let actorDetail = self.cast[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nomActeurLabel?.text = actorDetail.nomActeur
        cell.roleLabel?.text = actorDetail.role
     
        let session = URLSession.shared
        
        guard let urlImage = cast[indexPath.row].urlImageProfil else {
            return cell
        }
        let urlString = "https://image.tmdb.org/t/p/w185\(urlImage)"
        let url = URL(string: urlString)
        
        
        if let url = url {
            cell.tag = indexPath.row
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data{
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row && self.cast[indexPath.row].urlImageProfil != ""{
                            cell.imageView?.image = UIImage(data: data) //?? UIImage(named: "imageFail")
                            
                        }else{
                            cell.imageView?.image = UIImage(named: "No-image-found")
                        }
                        //self.collectionView?.reloadData()
                    }
                }
            }
            task.resume()
        }
        
        
        
        return cell
    }
}
