//
//  MovieData.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 21/03/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation

struct MovieData {
    //titre, realisateur, date de sortie, image,
    var titre: String
    var idMovie: Int
    var nameRealisateur: String
    var dateSortie: String
    var afficheFilm : String
    var bandeauFilm: String
    var resumeFilm: String
    
    init(titre: String, afficheFilm: String, idMovie: Int,dateSortie: String, bandeauFilm: String, nameRealisateur: String,
         resumeFilm: String){
        self.titre = titre
        self.idMovie = idMovie
        self.nameRealisateur = nameRealisateur
        self.dateSortie = dateSortie
        self.afficheFilm = afficheFilm
        self.bandeauFilm = bandeauFilm
        self.resumeFilm = resumeFilm
    }
    
    init(_ data: [String: AnyObject]) {
        self.titre = (data["title"] as? String) ?? ""
        self.afficheFilm = (data["poster_path"] as? String) ?? ""
        self.bandeauFilm = (data["backdrop_path"] as? String) ?? ""
        self.idMovie = (data["id"] as? Int) ?? 0
        self.dateSortie = (data["release_date"] as? String) ?? ""
        self.nameRealisateur = (data["name"] as? String) ?? ""
        self.resumeFilm = (data["overview"] as? String) ?? ""
        
        
        //release_date
        
        //self.productsCount = (data["products"] as? Int) ?? 0
        //self.id = (data["id"] as? String) ?? ""
    }
}

