//
//  SearchViewController.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 14/03/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import Foundation

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var movies : [MovieData] = []
    var isFiltered : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = 150
        title = "Recherche film"
        
        let session = URLSession.shared
        let api_key = "b753bea3c6fd7e64a2e07a4538ee6aa9"
        let urlString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(api_key)&language=fr"
        let url = URL(string: urlString)


        if let url = url {
            let task = session.dataTask(with: url) {
                (data, response, error) in

                if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let dataMovies = json["results"] as? [[String: AnyObject]]{

                    self.movies = dataMovies.reduce([]) {
                        (result, data) in

                        var res = result
                        let movie = MovieData(data)
                        res.append(movie)
                        
                        return res
                    }
                   DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }

            task.resume()
        }
    }
}
extension SearchViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            //let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
            
        let movie = self.movies[indexPath.row]
        
        let title = movie.titre
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CustomTableViewCell
        
        cell.movieTitle?.text = "\(title)"
        cell.movieImageView?.image = UIImage(named: "No-image-found")
        
        let session = URLSession.shared
        let urlString = "https://image.tmdb.org/t/p/w185\(movies[indexPath.row].afficheFilm)"
        let url = URL(string: urlString)
        
        
        if let url = url {
            cell.tag = indexPath.row
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data{
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row && self.movies[indexPath.row].afficheFilm != ""{
                            
                            
                                cell.movieImageView?.image = UIImage(data: data) //?? UIImage(named: "imageFail")
                           
                        }else{
                            cell.movieImageView?.image = UIImage(named: "No-image-found")
                        }
                    }
                }
            }
            task.resume()
        }
       
        //cell.movieImageView.imag
        //
        
        //let imgName = imgs[indexPath.row%4]
        
        //cell.customImageView.image = UIImage(named: imgName)
            return cell
        
        
        }
}


extension SearchViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let movie = self.movies[indexPath.row]
        print("\(movie.idMovie)")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addVc = storyboard.instantiateViewController(withIdentifier: "addMovieViewController") as! AddMovieViewController
        addVc.movie = movie
        addVc.dateSortie?.text = movie.dateSortie
        
        self.present(addVc, animated: true, completion: nil)
    }
}


extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty{
            isFiltered = true
            var query = searchText
            if(query.contains(" "))
            {
                query = query.replacingOccurrences(of: " ", with: "%20")
            }
            //dispatch_group_wait()
            let dispatch_group : DispatchGroup =  DispatchGroup()
            
            
            
            
            let session = URLSession.shared
            let api_key = "b753bea3c6fd7e64a2e07a4538ee6aa9"
            let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(api_key)&query=\(query)&language=fr"
            let url = URL(string: urlString)
            
            
            if let url = url {
                let task = session.dataTask(with: url) {
                    (data, response, error) in
                    
                    if let data = data, let json = try! JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject], let movieRes = json["results"] as? [[String : AnyObject]]{
                    
                        self.movies = movieRes.reduce([]) {
                            (result, data) in
                            
                            var res = result
                            let movie = MovieData(data)
                            print("ID du film recherché : \(movie.idMovie)")
                            
                            res.append(movie)
                            
                            self.SearchAutorMovie(movie.idMovie)
                            
                            //DispatchGroup.wait(dispatch_group)
                            
                            
                            
                            return res
                        }
                        
                        
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.tableView.setContentOffset(.zero, animated: true)
                        }
                        
                    } else {
                        // if error
                    }
                }
                
                task.resume()
            }
        }
        else {
            isFiltered = false
        }
    }
    func SearchMovieDetail(){
        
    }
    
    func SearchAutorMovie(_ idMovie: Int){
        
    }

}
