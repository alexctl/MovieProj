//
//  AddMovieViewController.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 28/03/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData

class AddMovieViewController: UIViewController {

    @IBOutlet weak var titleMovie: UILabel!
    @IBOutlet weak var realisateur: UILabel!
    @IBOutlet weak var dateSortie: UILabel!
    @IBOutlet var resumeMovie: UITextView!
    @IBOutlet weak var dateVuMovie: UIDatePicker!
    @IBOutlet var viewContent: UIView!
    
    @IBOutlet var btSave: UIButton!
    
    @IBAction func annuler(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveMovie(_ sender: Any) {
        
        
        if let movieDB = self.dataController.newObject(NSStringFromClass(MovieSeen.self)) as? MovieSeen {
            
            //                    product.brandId = self.brand?.id
            movieDB.idFilm = Int32(idMovie)
            movieDB.name = titleMovie.text
            movieDB.dateSortie = dateSortie.text
            movieDB.bandeauFilm = movie?.bandeauFilm
            movieDB.afficheFilm = movie?.afficheFilm
            
            dateVuMovie.datePickerMode = UIDatePickerMode.date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy"
            movieDB.dateVuFilm = dateFormatter.string(from: dateVuMovie.date)
            
            movieDB.resume = resumeMovie.text
            movieDB.realisateur = realisateur.text
            
            self.dataController.save()
    
            let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
            toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
            toastLabel.textColor = UIColor.white
            toastLabel.textAlignment = .center;
            toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
            toastLabel.text = "Le Film à été enregistrer"
            toastLabel.alpha = 1.0
            toastLabel.layer.cornerRadius = 10;
            toastLabel.clipsToBounds  =  true
            self.view.addSubview(toastLabel)
            UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }, completion: {(isCompleted) in
                toastLabel.removeFromSuperview()
            })
    }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var backImage: UIImageView!
    var idMovie: Int = 0
    
    
    var movie : MovieData?
    var teamMovie : [TeamData] = []
    let dataController = DataController.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        idMovie = (movie?.idMovie)!
        
        titleMovie.text = movie?.titre
        var dateString = movie?.dateSortie
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = dateFormatter.date(from: dateString!)
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateString = dateFormatter.string(from: date!)
        
        //dateFormatter.locale = Locale(identifier: "fr_FR")
        
        
        dateSortie.text = dateString
        
        
        resumeMovie.text = movie?.resumeFilm
        resumeMovie.layer.borderWidth = 1
        resumeMovie.layer.borderColor = UIColor.darkGray.cgColor
        
        dateVuMovie.setValue(UIColor.white, forKeyPath: "textColor")
        
        
        let dateNow = Date()
        
        if dateNow > date!{
            dateVuMovie.minimumDate = dateFormatter.date(from: dateString!)
            dateVuMovie.date = dateNow
        }else{
            dateVuMovie.minimumDate = dateFormatter.date(from: dateString!)
            dateVuMovie.date = dateFormatter.date(from: dateString!)!
            //btSave.isEnabled = false
            //btSave.setTitle("Film non visible", for: .normal)
            btSave.isHidden = true
        }
        
        
        
        
        //auteur.text = movie?.nameRealisateur
        
        
        
        if !UIAccessibilityIsReduceTransparencyEnabled() {
            viewContent.backgroundColor = .clear
            
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = self.viewContent.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            backImage.addSubview(blurEffectView)
            
        } else {
            viewContent.backgroundColor = .black
        }
        
        
        
        guard let urlPoster = movie?.afficheFilm else {
            return
        }
        if urlPoster != nil{
            let session = URLSession.shared
            let urlString = "https://image.tmdb.org/t/p/w185\(urlPoster)"
            let url = URL(string: urlString)
            
            
            if let url = url {
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    
                    if let data = data{
                        DispatchQueue.main.async {
                            self.backImage?.image = UIImage(data: data) //?? UIImage(named: "imageFail")
                        }
                    }
                }
                task.resume()
            }
        }
        print("Id movie add movie : \(idMovie)")
        
        let session = URLSession.shared
        let api_key = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        let urlString = "https://api.themoviedb.org/3/movie/\(idMovie)/credits?api_key=\(api_key)"
        let url = URL(string: urlString)
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let dataMovie = json["crew"] as? [[String: AnyObject]]{
                    
                    self.teamMovie = dataMovie.reduce([]) {
                        (result, data) in
                        var res = result
                        
                        for (key, value) in data{
                            if key == "job" && value as! String == "Director"
                            {
                                let nameDirector = TeamData(data)
                                res.append(nameDirector)
                                break
                            }
                        }
                        return res
                    }
                    DispatchQueue.main.async {
                        self.realisateur.text = self.teamMovie[0].nameRealisateur

                    }
                    
                }
            }
            
            task.resume()
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
