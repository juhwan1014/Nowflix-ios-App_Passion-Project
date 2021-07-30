//
//  RecommendListViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-09.
//

import UIKit
import Kingfisher

class RecommendListViewController: UIViewController {
    
    
    
    @IBOutlet weak var sectionTitle: UILabel!
    
    let viewModel = RecommentListViewModel()
    
    
    
    //    var apiCalling = MovieAPI()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        //        MovieAPI.PopularMovieData{(result) in print("쿨쿨 여기서 부터 리절트 \(result)")}
        //
        //
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    func updateUI() {
        sectionTitle.text = viewModel.type.title
    }
    
}


extension RecommendListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("화긴화긴화긴화긴화화긴화긴")
        print(viewModel.numOfItems)
        return viewModel.numOfItems
      
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecommendCell", for: indexPath) as? RecommendCell else {
            return UICollectionViewCell()
        }
        
        let movie = viewModel.item(at: indexPath.item)
        print("랜딩의 무비 바로 요 밑에")
        print(movie)
        print("이거 밑에 무비닷썹네일랑 셀")
        print(movie.thumbnail)
        let url = URL(string: "\(movie.thumbnail)")!
        //        print(url)
        
        cell.thumbnailImage.kf.setImage(with: url)
        print(cell)
        //        cell.updateUI(movie: movie)
        return cell
    }
}

extension RecommendListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 160)
    }
}

class RecommentListViewModel {
    
    
    private var popularMovies = [TheMovie]()
    
    
    func fetchPopularMoviesData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        MovieAPI.PopularMovieData { [weak self] (popMovies) in
         
            self?.popularMovies = popMovies
         
            completion()
        }
    }
    
    
    func fetchRatedMoviesData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        MovieAPI.TopRatedMovieData { [weak self] (Movies) in
         
            
            self?.popularMovies = Movies
            
         
            completion()
        }
    }
    
    
    func fetchNowPlayingMoviesData(completion: @escaping () -> ()) {
        
        // weak self - prevent retain cycles
        MovieAPI.NowPlayingMovieData { [weak self] (Movies) in
        
            self?.popularMovies = Movies
            self?.popularMovies.reverse()
            completion()
        }
    }
     

    func numberOfRowsInSection(section: Int) -> Int {
          if popularMovies.count != 0 {
              return popularMovies.count
          }
          return 0
      }
    
    
    func cellForRowAt (indexPath: IndexPath) -> TheMovie {
           return popularMovies[indexPath.row]
       }
    
    enum RecommendingType {
        case popular
        case rated
        case nowPlaying
        
        var title: String {
            switch self {
            case .popular: return "Popular Movies"
            case .rated: return "Top Rated Movies"
            case .nowPlaying: return "Now Plaing Movies in theatres"
                
            }
        }
    }
    
    private (set) var type: RecommendingType = .popular
    
    private var items: [DummyItem] = []
    
    var numOfItems: Int {
        return items.count
    }
    
    func item(at index: Int) -> DummyItem {
        return items[index]
    }
    
    func updateType(_ type: RecommendingType) {
        self.type = type
    }
    
    func fetchItems() {
        
        self.items = MovieFetcher.fetch(type)
        //        print("요긴 아이템 아래참고")
        //        print(items)
        //        print("요긴 아이텐 위에참고")
        
    }
    
    
    
}


class RecommendCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImage: UIImageView!
    
}

class MovieFetcher {
    
    static func fetch(_ type: RecommentListViewModel.RecommendingType) -> [DummyItem] {
        
        switch type {
        
        case .popular:
            var ImageURL: [String] = []
            var movies: [DummyItem] = []
            let semaphore = DispatchSemaphore(value: 0)
            
            MovieAPI.PopularMovieData
            { popMovies in
//                print("popular movies count 꽈랑꽈랑")
//                print(popMovies.count)
                for i in 0...19{
                    ImageURL.append("http://image.tmdb.org/t/p/w300\(popMovies[i].posterImage!)")
                    movies.append(DummyItem(thumbnail: ImageURL[i]))
                }
                semaphore.signal()
            }
            _ = semaphore.wait(wallTimeout: .distantFuture)
            
//            print("오오오오오오오오오오오")
//            print(movies.count)
//            print("아아아아아아아아아아아")
            
            return movies
            
            
        case .rated:
            var ImageURL: [String] = []
            var movies: [DummyItem] = []
            let semaphore = DispatchSemaphore(value: 0)
            
            MovieAPI.TopRatedMovieData
            { ratedMovies in
//                print("TopRatedMovies count 꽈랑꽈랑")
//                print(ratedMovies.count)
                for i in 0...19{
                    ImageURL.append("http://image.tmdb.org/t/p/w300\(ratedMovies[i].posterImage!)")
                    movies.append(DummyItem(thumbnail: ImageURL[i]))
                }
                semaphore.signal()
            }
            _ = semaphore.wait(wallTimeout: .distantFuture)
            
//            print("오오오오오오오오오오오")
//            print(movies)
//            print("아아아아아아아아아아아")
//
            return movies
            
        case .nowPlaying:
            var ImageURL: [String] = []
            var movies: [DummyItem] = []
            let semaphore = DispatchSemaphore(value: 0)
            
            MovieAPI.NowPlayingMovieData
            { nowplayingMovies in
//                print("TopRatedMovies count 꽈랑꽈랑")
//                print(ratedMovies.count)
                for i in 0...19{
                    ImageURL.append("http://image.tmdb.org/t/p/w300\(nowplayingMovies[i].posterImage!)")
                    movies.append(DummyItem(thumbnail: ImageURL[i]))
                }
                semaphore.signal()
            }
            _ = semaphore.wait(wallTimeout: .distantFuture)
            
//            print("오오오오오오오오오오오")
//            print(movies)
//            print("아아아아아아아아아아아")
         
             movies.reverse()
            
            return movies
            
            
        }
    }
}






class MovieAPI {
    
    //    static func PopularMovieData(completion: @escaping ([TheMovie])-> [DummyItem]){
    static func PopularMovieData(completion: @escaping ([TheMovie])-> Void){
        let session = URLSession(configuration: .default)
        let UrlComponents = URLComponents(string: "https://api.themoviedb.org/3/movie/popular?api_key=6e4ef717279fab32a9cd5fb1cda17e55&language=en-US&page=1")!
        let RequestURL = UrlComponents.url!
        let DataTask = session.dataTask(with: RequestURL) {
            data, response, error in
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
//            let string = String(data: resultData, encoding: .utf8)
            
            let popMovies = MovieAPI.parseTheMovies(resultData)
            completion(popMovies)
            print("--> result: \(popMovies.count)")
        }
        
        DataTask.resume()
        
    }
    
   
    
    
    
    
    
    static func TopRatedMovieData(completion: @escaping ([TheMovie])-> Void){
        let session = URLSession(configuration: .default)
        let UrlComponents = URLComponents(string:
            "https://api.themoviedb.org/3/movie/top_rated?api_key=6e4ef717279fab32a9cd5fb1cda17e55&language=en-US&page=1")!
        let RequestURL = UrlComponents.url!
        let DataTask = session.dataTask(with: RequestURL) {
            data, response, error in
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
//            let string = String(data: resultData, encoding: .utf8)
            
            let ratedMovies = MovieAPI.parseTheMovies(resultData)
            completion(ratedMovies)
            print("--> result: \(ratedMovies.count)")
        }
        
        DataTask.resume()
        
    }
    
    
    
    
    static func NowPlayingMovieData(completion: @escaping ([TheMovie])-> Void){
        let session = URLSession(configuration: .default)
        let UrlComponents = URLComponents(string:
            "https://api.themoviedb.org/3/movie/now_playing?api_key=6e4ef717279fab32a9cd5fb1cda17e55&language=en-US&page=1")!
        let RequestURL = UrlComponents.url!
        let DataTask = session.dataTask(with: RequestURL) {
            data, response, error in
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
//            let string = String(data: resultData, encoding: .utf8)
            
            let nowplayingMovies = MovieAPI.parseTheMovies(resultData)
            completion(nowplayingMovies)
            print("--> result: \(nowplayingMovies.count)")
        }
        
        DataTask.resume()
        
    }
    
    

    
    
    
    
    static func parseTheMovies(_ data: Data) -> [TheMovie] {
        let decoder = JSONDecoder()
        
        do {
            let response = try decoder.decode(MoviesData.self, from: data)
            
            let movies = response.TheMovies
            return movies
        }catch let error {
            print("--> parsing error: \(error.localizedDescription)")
            return []
        }
        
    }
    
}




struct MoviesData: Codable {
    let TheMovies: [TheMovie]
    
    private enum CodingKeys: String, CodingKey{
        case TheMovies = "results"
    }
}

struct TheMovie: Codable{
    let title: String?
    let year: String?
    let rate: Double?
    let posterImage: String?
    let overview: String?
    let ID: String?
    
    private enum CodingKeys: String, CodingKey{
        case title, overview
        case year = "release_date"
        case rate = "vote_average"
        case posterImage = "poster_path"
        case ID = "movie_id"
    }
}



//struct DummyItem {
//    let thumbnail: UIImage
//}

struct DummyItem {
    let thumbnail: String
}


