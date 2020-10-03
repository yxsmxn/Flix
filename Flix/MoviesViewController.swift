//
//  ViewController.swift
//  Flix
//
//  Created by Yasmin Hernandez on 9/25/20.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var Movies = [[String: Any]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //Taken from Assignment page
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { [self] (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            Movies = dataDictionary["results"] as! [[String : Any]]
            
            self.tableView.reloadData()
            
            //print(dataDictionary)
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(Movies.count)
        return Movies.count
        // eventually return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCellTableViewCell") as! MovieCellTableViewCell
        
        let movie = Movies[indexPath.row]
        let title = movie["title"] as! String
        let overview = movie["overview"] as! String
        
        cell.TitleLabel.text = title
        cell.DescriptionLabel.text = overview
        
        let baseURL = "https://image.tmdb.org/t/p/w185"
        let posterPath = movie["poster_path"] as! String
        
        let posterURl = URL(string: baseURL + posterPath)
        
        cell.PosterView.af_setImage(withURL: posterURl!)
        
        return cell
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        print("Loading up the details screen")
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)!
        
        let movie = Movies[indexPath.row]
        
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    


}
