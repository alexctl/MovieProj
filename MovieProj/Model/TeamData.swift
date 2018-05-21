//
//  TeamData.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 04/04/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
struct TeamData {
    //titre, realisateur, date de sortie, image,
    var nameRealisateur: String
    
    init(nameRealisateur: String){
        self.nameRealisateur = nameRealisateur
    }
    
    init(_ data: [String: AnyObject]) {
        self.nameRealisateur = (data["name"] as? String) ?? ""
    }
}

