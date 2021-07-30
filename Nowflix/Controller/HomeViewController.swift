//
//  HomeViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-09.
//

import UIKit
import Kingfisher
import AVFoundation
import Firebase

class HomeViewController: UIViewController {

    
    @IBOutlet private weak var ImageHeader: UIImageView!
    
    
    var popularRecommendListViewController: RecommendListViewController!
    var ratedRecommendListViewController: RecommendListViewController!
    var nowPlayingRecommendListViewController: RecommendListViewController!

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popular" {
            let destinationVC = segue.destination as? RecommendListViewController
            popularRecommendListViewController = destinationVC
            popularRecommendListViewController.viewModel.updateType(.popular)
            popularRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "rated" {
            let destinationVC = segue.destination as? RecommendListViewController
            ratedRecommendListViewController = destinationVC
            ratedRecommendListViewController.viewModel.updateType(.rated)
            ratedRecommendListViewController.viewModel.fetchItems()
        } else if segue.identifier == "nowPlaying" {
            let destinationVC = segue.destination as? RecommendListViewController
            nowPlayingRecommendListViewController = destinationVC
            nowPlayingRecommendListViewController.viewModel.updateType(.nowPlaying)
            nowPlayingRecommendListViewController.viewModel.fetchItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var HeaderImageString: [String] = []
        var HeaderImageURL: [String] = []
        
        
        let semaphore = DispatchSemaphore(value: 0)

        MovieAPI.PopularMovieData
        { popMovies in
            for i in 0...10{
            HeaderImageString.append("http://image.tmdb.org/t/p/w300\(popMovies[i].posterImage!)")
        }
            semaphore.signal()
        }
        _ = semaphore.wait(wallTimeout: .distantFuture)

        let HeaderUrl = HeaderImageString[0]
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
        
//        var searchTerms: [SearchTerm] = []
//        let semaphore = DispatchSemaphore(value: 0)
//
//        let db = Database.database().reference().child("searchHistory")
//
//        db.observeSingleEvent(of: .value) { (snapshot) in
//            guard let searchHistory = snapshot.value as? [String: Any] else {return}
//
//
//            let data = try! JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
//            let decoder = JSONDecoder()
//            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
//              searchTerms.sorted(by: { (term1, term2) in
//             return term1.timestamp > term2.timestamp })
////            semaphore.signal()
////            _ = semaphore.wait(wallTimeout: .distantFuture)
//
//            SearchAPI.search(searchTerms[0].term) { movies in
//            guard let interstella = movies.first else { return }
//                HeaderImageString.append(interstella.thumnailPath)
//                semaphore.signal()
//    }
//            _ = semaphore.wait(wallTimeout: .distantFuture)
//
//            print(HeaderImageString[0])
//            print(HeaderImageString)
//            print("화아아아악인")
//            HeaderImageURL.append(HeaderImageString[0])
//            print(HeaderImageURL[0])
////            semaphore.signal()
//        }
////        _ = semaphore.wait(wallTimeout: .distantFuture)
//        print(HeaderImageURL[0])
//         print("와랄라랄라레")
        
        
        
        
        
        
        
        
        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        self.ImageHeader.setHeaderImage(HeaderUrl, placeholder: "placeholder")

//         Do any additional setup after loading the view.
    
        
    }
    
 
    
    
    @IBAction func playButtonTapped(_ sender: Any) {

        
        
//        var MovieIdString: [String] = []
//        let semaphore = DispatchSemaphore(value: 0)
//
//        MovieAPI.PopularMovieData
//        { popMovies in
//
//            for i in 0...10{
//                MovieIdString.append("\(popMovies[i].ID!)")
//        }
//            semaphore.signal()
//        }
//        _ = semaphore.wait(wallTimeout: .distantFuture)
//
//
//        func VideoMovieData(completion: @escaping ([TheMovie])-> Void){
//            let session = URLSession(configuration: .default)
//            let UrlComponents = URLComponents(string:
//                "  https://api.themoviedb.org/3/movie/\(MovieIdString[0])/videos?api_key=6e4ef717279fab32a9cd5fb1cda17e55&language=en-US")!
//            let RequestURL = UrlComponents.url!
//            let DataTask = session.dataTask(with: RequestURL) {
//                data, response, error in
//                let successRange = 200..<300
//                guard error == nil,
//                      let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
//                    completion([])
//                    return
//                }
//                guard let resultData = data else {
//                    completion([])
//                    return
//                }
//    //            let string = String(data: resultData, encoding: .utf8)
//
//                let nowplayingMovies = MovieAPI.parseTheMovies(resultData)
//                completion(nowplayingMovies)
//                print("--> result: \(nowplayingMovies.count)")
//            }
//
//            DataTask.resume()
//
//        }
        
//        VideoMovieData { Movies in
            
            
//            DispatchQueue.main.async {
//                let url = URL(string: interstella.previewURL)!
//                let item = AVPlayerItem(url: url)
//                let sb = UIStoryboard(name: "Player", bundle: nil)
//                let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
//                vc.player.replaceCurrentItem(with: item)
//
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: false, completion: nil)    }
//        }
        
        
//        func parseTheMovies(_ data: Data) -> [TheMovie] {
//            let decoder = JSONDecoder()
//
//            do {
//                let response = try decoder.decode(MoviesData.self, from: data)
//
//                let movies = response.TheMovies
//                return movies
//            }catch let error {
//                print("--> parsing error: \(error.localizedDescription)")
//                return []
//            }
//
//        }
        var searchTerms: [SearchTerm] = []

        
        let db = Database.database().reference().child("searchHistory")
       
        db.observeSingleEvent(of: .value) { (snapshot) in
            guard let searchHistory = snapshot.value as? [String: Any] else {return}
            
            
            let data = try! JSONSerialization.data(withJSONObject: Array(searchHistory.values), options: [])
            let decoder = JSONDecoder()
            let searchTerms = try! decoder.decode([SearchTerm].self, from: data)
              searchTerms.sorted(by: { (term1, term2) in
             return term1.timestamp > term2.timestamp })
            
            
            
            SearchAPI.search(searchTerms[0].term) { movies in
            guard let interstella = movies.first else { return }
  
            DispatchQueue.main.async {
                let url = URL(string: interstella.previewURL)!
                let item = AVPlayerItem(url: url)
                let sb = UIStoryboard(name: "Player", bundle: nil)
                let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
                vc.player.replaceCurrentItem(with: item)

                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)    }
    }

        
        }
        

        

}
    
    
    
    
}
  

extension UIImageView{
    func setHeaderImage(_ imageUrl: String, placeholder: String){
        
        
        self.kf.setImage(with: URL(string: imageUrl), placeholder: UIImage(named: placeholder))
        
//        ImageHeader.kf.indicatorType = .activity
//        ImageHeader.kf.setImage(with: URL(string: "http://image.tmdb.org/t/p/w300/pgqgaUx1cJb5oZQQ5v0tNARCeBp.jpg") , placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil )
//
        
    }
}
