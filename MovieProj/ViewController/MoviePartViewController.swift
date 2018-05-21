//
//  MoviePartViewController.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 16/04/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit

class MoviePartViewController: UIViewController {

    var urlImageBandeau : String?
    var urlImagePoster : String?
    var movie : MovieSeen?
    
    
    @IBOutlet var bandeauFilmImg: UIImageView?
    @IBOutlet var posterFilm: UIImageView?
    
    @IBOutlet var realisateurLabel: UILabel?
    @IBOutlet var dateSortieLabel: UILabel?
    @IBOutlet var dateVuLabel: UILabel?
    @IBOutlet var titreFilmLabel: UILabel?
    
    @IBOutlet var resumeTextView: UITextView?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let session = URLSession.shared
        guard let urlImageBandeau = movie?.bandeauFilm else {
            return
        }
        let urlString = "https://image.tmdb.org/t/p/w185\(urlImageBandeau)"
        let url = URL(string: urlString)
        
        
        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data{
                    DispatchQueue.main.async {
                        self.bandeauFilmImg?.image = UIImage(data: data) ?? UIImage(named: "imageFail")
                    }
                }
            }
            task.resume()
        }

        guard let urlImagePoster = movie?.afficheFilm else {
            return
        }
        let urlStringPoster = "https://image.tmdb.org/t/p/w185\(urlImagePoster)"
        let url2 = URL(string: urlStringPoster)
        if let url2 = url2 {
            let task = session.dataTask(with: url2) {
                (data, response, error) in
                
                if let data = data{
                    DispatchQueue.main.async {
                        self.posterFilm?.image = UIImage(data: data) ?? UIImage(named: "imageFail")
                    }
                }
            }
            task.resume()
        }
        
        
        guard let realisateurName = movie?.realisateur else{
            return
        }
        
        guard let dateSortie = movie?.dateSortie else{
            return
        }
        guard let dateVu = movie?.dateVuFilm else{
            return
        }
        guard let resume = movie?.resume else{
            return
        }
        
        guard let titreFilm = movie?.name else{
            return
        }
        
        realisateurLabel?.text = "Réalisé par : \(realisateurName)"
        dateSortieLabel?.text = "Sortie en salle le \(dateSortie)"
        dateVuLabel?.text = "Vu le : \(dateVu)"
        resumeTextView?.text = resume
        titreFilmLabel?.text = titreFilm

    }

}
