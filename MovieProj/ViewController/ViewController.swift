//
//  ViewController.swift
//  MovieProj
//
//  Created by Alexandre Cantal on 14/03/2018.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

   
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var searchMovie: UIBarButtonItem!
   
    @IBOutlet var labelEmpty: UILabel!
    @IBOutlet var emptyImageView: UIImageView!
    @IBAction func toSearchView(_ sender: Any) {
        performSegue(withIdentifier: "searchViewController", sender: self)
    }
    let dataController = DataController.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 150
        
        title = "Mes Films"
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellIdentifier")
        
        hiddenObject()
        
       
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewDidAppear(_ animated: Bool) {
        hiddenObject()
        tableView.reloadData()
    }
    
    func hiddenObject(){
        
        let tmpMovies = dataController.movies()
        labelEmpty.isHidden = true
        emptyImageView.isHidden = true
        
        
        if tmpMovies.isEmpty{
            tableView.isHidden = true
            labelEmpty.isHidden = false
            emptyImageView.isHidden = false
        }
        else {
            labelEmpty.isHidden = true
            emptyImageView.isHidden = true
            tableView.isHidden = false
            
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView:UITableView!, numberOfRowsInSection section:Int) -> Int
    {
        let tmpMovies = dataController.movies()
        
        return tmpMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tmpMovies = dataController.movies()
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath) as! CustomTableViewCell
        
        
        cell.movieTitle?.text = tmpMovies[indexPath.row].name
        
        cell.movieDate?.text = "Vu le : \(tmpMovies[indexPath.row].dateVuFilm ?? "")"
        let img = tmpMovies[indexPath.row].bandeauFilm ?? ""
        
        
        let session = URLSession.shared
        let urlString = "https://image.tmdb.org/t/p/w185\(img)"
        let url = URL(string: urlString)
        
        
        if let url = url {
            cell.tag = indexPath.row
            let task = session.dataTask(with: url) {
                (data, response, error) in
                
                if let data = data{
                    DispatchQueue.main.async {
                        if cell.tag == indexPath.row && tmpMovies[indexPath.row].bandeauFilm != ""{
                            
                            
                            cell.movieImageView?.image = UIImage(data: data) //?? UIImage(named: "imageFail")
                            
                        }else{
                            cell.movieImageView?.image = UIImage(named: "No-image-found")
                        }
                    }
                }
            }
            task.resume()
        }
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "cellIdentifier", for: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let tmpMovies = dataController.movies()
            dataController.delete(deleterow: tmpMovies[indexPath.row] as NSManagedObject)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        }
    }

}
extension ViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tmpMovies = dataController.movies()
        
        let movieSelect = tmpMovies[indexPath.row]
        //let movie = self.movies[indexPath.row]
        //print("\(movie.idMovie)")
        
        //let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarViewController") as! UITabBarController
        
        // You should access the `imageController` through your `tabBarController`,
        // not instantiate it from storyboard.
        //if let viewControllers = tabBarController.viewControllers,
            //let imageController = viewControllers.first as? ImageController {
            //imageController.recivedData1 = media.bannerImages
        //}
        if let viewControllers = tabBarController.viewControllers,
            let moviePartController = viewControllers.first as? MoviePartViewController{
            moviePartController.movie = movieSelect
        }
        
        if let viewControllers = tabBarController.viewControllers,
            let castPartController = viewControllers[1] as? CastPartViewController{
            castPartController.idMovie = movieSelect.idFilm
        }
        
        
        self.navigationController?.pushViewController(tabBarController, animated: true)
        
        
        //let moviePartVc = storyboard.instantiateViewController(withIdentifier: "moviePartViewController") as! MoviePartViewController
        //moviePartVc.urlImage = tmpMovies[indexPath.row].bandeauFilm
        //detailVc.movie = tmpMovies[indexPath.row]
        
        //addVc.movie = movie
        //addVc.dateSortie?.text = movie.dateSortie
        
        //self.navigationController?.pushViewController(moviePartVc, animated: true)
        //self.present(addVc, animated: true, completion: nil)
        
        
    }
}

