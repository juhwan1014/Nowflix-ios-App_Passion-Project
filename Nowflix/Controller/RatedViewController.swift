//
//  RatedViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-15.
//

import UIKit

class RatedViewController: UIViewController {

   
    @IBOutlet weak var RatedTableView: UITableView!
    
    
    private var viewModel = RecommentListViewModel()
        
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
            loadPopularMoviesData()
        
        // Do any additional setup after loading the view.
       
    }
    

    private func loadPopularMoviesData() {
        
//        let semaphore = DispatchSemaphore(value: 0)
        
           viewModel.fetchRatedMoviesData {
            [weak self] in
           
            DispatchQueue.main.sync(execute: {
                self?.RatedTableView.dataSource = self
                self?.RatedTableView.reloadData()
            })
          
                
            
//            semaphore.signal()
           }
        
//        _ = semaphore.wait(wallTimeout: .distantFuture)
       }

}

extension RatedViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return viewModel.numberOfRowsInSection(section: section)
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = RatedTableView.dequeueReusableCell(withIdentifier: "RatedCell", for: indexPath) as? RatedTableViewCell else {
            return UITableViewCell()
        }
        
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
            
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    
}
