//
//  NowPlayingViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-15.
//

import UIKit

class NowPlayingViewController: UIViewController {

    
     @IBOutlet weak var NowPlayTableView: UITableView!
     
     
     private var viewModel = RecommentListViewModel()
         
     
         
     override func viewDidLoad() {
         super.viewDidLoad()
         

         
             loadPopularMoviesData()
         
         // Do any additional setup after loading the view.
        
     }
     

     private func loadPopularMoviesData() {
         
 //        let semaphore = DispatchSemaphore(value: 0)
         
            viewModel.fetchNowPlayingMoviesData {
             [weak self] in
            
             DispatchQueue.main.sync(execute: {
                 self?.NowPlayTableView.dataSource = self
                 self?.NowPlayTableView.reloadData()
             })
           
                 
             
 //            semaphore.signal()
            }
         
 //        _ = semaphore.wait(wallTimeout: .distantFuture)
        }

 }

 extension NowPlayingViewController: UITableViewDataSource{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
         return viewModel.numberOfRowsInSection(section: section)
      
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = NowPlayTableView.dequeueReusableCell(withIdentifier: "NowPlayingCell", for: indexPath) as? NowPlayingTableViewCell else {
             return UITableViewCell()
         }
         
         
         let movie = viewModel.cellForRowAt(indexPath: indexPath)
             
        cell.setCellWithValuesOf(movie)
         
         return cell
     }
     

   

}
