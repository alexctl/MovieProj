//
//  CastData.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 20/04/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation

struct CastData {
    //titre, realisateur, date de sortie, image,
    var nomActeur : String?
    var role: String?
    var urlImageProfil: String?
    
    init(nomActeur: String, role: String, urlImageProfil: String){
        self.nomActeur = nomActeur
        self.role = role
        self.urlImageProfil = urlImageProfil
    }
    
    init(_ data: [String: AnyObject]) {
        self.nomActeur = (data["name"] as? String) ?? ""
        self.role = (data["character"] as? String) ?? ""
        self.urlImageProfil = (data["profile_path"] as? String) ?? ""
        
    }
}
