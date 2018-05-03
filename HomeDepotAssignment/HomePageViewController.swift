//
//  HomePageViewController.swift
//  HomeDepotAssignment
//
//  Created by Swagat Mishra on 5/2/18.
//  Copyright © 2018 Swagat Mishra. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    let networkManager = NetworkManager()
    @IBOutlet weak var reposCollectionView: UICollectionView! {
        didSet {
            reposCollectionView.dataSource = self
            reposCollectionView.delegate = self
        }
    }
    
    var repos = [Repo]()
    var currentPage = 1
    var isListView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetchRepos() {
        self.networkManager.fetchRepos(page: currentPage) { [weak self] (repos) in
            guard repos != nil else { return }
            if (self?.currentPage)! == 1 {
                self?.repos = repos!
            }
            else {
                self?.repos.append(contentsOf: repos!)
            }
            DispatchQueue.main.async {
                self?.reposCollectionView.reloadData()
            }
        }
    }

    @IBAction func segmentedValueChanged(_ sender: UISegmentedControl) {
        guard let flowLayout = reposCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }

        if sender.selectedSegmentIndex == 0 {
            //Display collection view as list
            isListView = true
        }
        else {
            //Display collection view as grid
            isListView = false
        }
        flowLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = reposCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
}

extension HomePageViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Call GET service for repos
        self.networkManager.repoName = textField.text
        self.currentPage = 1
        fetchRepos()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Call GET service for repos
        textField.endEditing(true)
        return true
    }
}

extension HomePageViewController: UICollectionViewDelegate {
    
}

extension HomePageViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isListView {
            return CGSize(width: collectionView.frame.width, height: 150.0)
        }
        else {
            return CGSize(width: (collectionView.frame.width / 2) - 10, height: 150.0)
        }
    }
}

extension HomePageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return repos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row + 1 == self.repos.count {
            currentPage += 1
            fetchRepos()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if self.repos.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceHolderCellId", for: indexPath)
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReposCellId", for: indexPath) as! ReposCollectionViewCell
            cell.setValues(from: repos[indexPath.row])
            return cell
        }
    }
    
}
