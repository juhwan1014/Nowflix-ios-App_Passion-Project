//
//  SearchBarViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-09.
//

import UIKit
import Kingfisher
import AVFoundation
import Firebase

class SearchBarViewController: UIViewController {

    let db = Database.database().reference().child("searchHistory")
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    
    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}


extension SearchBarViewController: UICollectionViewDataSource{
   
    //how many?
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    //how represent?
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ResultCell", for: indexPath) as? ResultCell
      else {return UICollectionViewCell()}
        
        let movie = movies[indexPath.item]
       
        let url = URL(string: movie.thumnailPath)!
    
        cell.movieThumnail.kf.setImage(with: url)
      
        return cell
         
    }
    
  
    
   
}
extension SearchBarViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let url = URL(string: movie.previewURL)!
        let item = AVPlayerItem(url: url)
        
        let sb = UIStoryboard(name: "Player", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "PlayerViewController") as! PlayerViewController
        vc.modalPresentationStyle = .fullScreen
        
        vc.player.replaceCurrentItem(with: item)
        present(vc, animated: false, completion: nil)
    }
    
}
extension SearchBarViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let margin: CGFloat = 8
        let itemSpacing: CGFloat = 10
        
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing * 2) / 3
        let height = width * 10/7
        
        return CGSize(width: width, height: height)
        
    }
}



class ResultCell: UICollectionViewCell{
    @IBOutlet weak var movieThumnail: UIImageView!
}
    
    extension SearchBarViewController: UISearchBarDelegate{
        
        private func dismissKeyboard(){
            searchBar.resignFirstResponder()
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
          // Treat the keyboard to go down when it comes up
            dismissKeyboard()
         // whether or not the search term exists
            guard let searchTerm = searchBar.text,
                  searchTerm.isEmpty == false
            else {return}
            
            SearchAPI.search(searchTerm) { movies in
                // collectionView
                print("how many ? \(movies.count)")
                DispatchQueue.main.async {
                    self.movies = movies
                    self.resultCollectionView.reloadData()
                    
                    let timestamp: Double = Date().timeIntervalSince1970.rounded()
                    self.db.childByAutoId().setValue(["term": searchTerm, "timestamp": timestamp])
                    
                }
                
               
            }
            
            print("\(searchBar.text)")
        }
    }
   

class SearchAPI {
    static func search(_ term: String, completion: @escaping ([Movie])-> Void){
        let session = URLSession(configuration: .default)
        
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search?")!
    
        
        let mediaQuery = URLQueryItem(name: "media", value: "movie")
        let entityQuery = URLQueryItem(name: "entity", value: "movie")
        let termQuery = URLQueryItem(name: "term", value: term)
        urlComponents.queryItems?.append(mediaQuery)
        urlComponents.queryItems?.append(entityQuery)
        urlComponents.queryItems?.append(termQuery)
        
//        print("이거 바로 밑에가 유알엘 컴포넌트")
//        print(urlComponents)
        let requestURL = urlComponents.url!
        
        
        let dataTask = session.dataTask(with: requestURL) { data, response, error in
            let successRange = 200..<300
            
            guard error == nil,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode, successRange.contains(statusCode) else {
                completion([])
                return
            }
            
            guard let resultData = data else {
                completion([])
                return
            }
         
            let string = String(data: resultData, encoding: .utf8)
             
            let movies = SearchAPI.parseMovies(resultData)
            completion(movies)
            print("--> result: \(movies.count)")
//            completion([Movie])
            
        }
        dataTask.resume()
    }
    
    static func parseMovies(_ data: Data) -> [Movie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(Response.self, from: data)
//            print("하하하하하하하하하하하하하")
//            print("\(response)")
//            print("호호호호호호호호호호호호호")
            let movies = response.movies
            return movies
        }catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
        
    }
}

struct Response: Codable {
    let resultCount: Int
    let movies: [Movie]
    
    enum CodingKeys: String, CodingKey{
        case resultCount
        case movies = "results"
    }
}

struct Movie: Codable {
    let title: String
    let director: String
    let thumnailPath: String
    let previewURL: String
    
    
    enum CodingKeys: String, CodingKey{
        case title = "trackName"
        case director = "artistName"
        case thumnailPath = "artworkUrl100"
        case previewURL = "previewUrl"
        
     }
    
}

