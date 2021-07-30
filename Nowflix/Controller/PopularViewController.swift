//
//  DetailViewController.swift
//  Nowflix
//
//  Created by APPLE on 2021-04-15.
//

import UIKit

class PopularViewController: UIViewController {


    
    @IBOutlet weak var PopularTableView: UITableView!
    
    
    private var viewModel = RecommentListViewModel()
        
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
            loadPopularMoviesData()
        
        // Do any additional setup after loading the view.
       
    }
    

    private func loadPopularMoviesData() {
        
//        let semaphore = DispatchSemaphore(value: 0)
        
           viewModel.fetchPopularMoviesData {
            [weak self] in
           
            DispatchQueue.main.sync(execute: {
                self?.PopularTableView.dataSource = self
                self?.PopularTableView.reloadData()
            })
          
                
            
//            semaphore.signal()
           }
        
//        _ = semaphore.wait(wallTimeout: .distantFuture)
       }

}

extension PopularViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return viewModel.numberOfRowsInSection(section: section)
     
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = PopularTableView.dequeueReusableCell(withIdentifier: "DetailCell", for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        
        
        let movie = viewModel.cellForRowAt(indexPath: indexPath)
            
        cell.setCellWithValuesOf(movie)
        
        return cell
    }
    
    
}
