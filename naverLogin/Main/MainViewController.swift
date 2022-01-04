//
//  MainViewController.swift
//  naverLogin
//
//  Created by 김민종 on 2021/12/22.
//

import UIKit
import Alamofire

class MainViewController: BaseViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var foods = [item]()
    var images: [String] = ["배너1", "배너2", "배너3", "배너4", "배너5", "배너6"]
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    var foodImages: [String] = ["음식1", "음식2", "음식3", "음식4", "음식5", "음식1", "음식2", "음식3", "음식4", "음식5"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Nib Register
        let nibCell = UINib(nibName: "MainCollectionViewCell", bundle: nil)
        collectionView.register(nibCell, forCellWithReuseIdentifier: "cell")
        
        //Page Control
        pageControl.numberOfPages = images.count
        for index in 0..<images.count {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let imgView = UIImageView(frame: frame)
            imgView.contentMode = .scaleAspectFit
            imgView.image = UIImage(named: images[index])
            self.scrollView.addSubview(imgView)
        }
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(images.count)), height: scrollView.frame.size.height)
        
        configureItem()
        FoodDataManager().getFoodData(self)

        //Delegate
        scrollView.delegate = self
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    //Navigation Bar
    private func configureItem() {
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "map"),
                style: .done,
                target: self,
                action: nil
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .done,
                target: self,
                action: nil
                )
        ]
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "부산∨", style: .done, target: self, action: nil)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
    }
    // FoodDataManager Response
    func didSuccess(_ response: FoodResponse) {
        let data = response.getSafeRestaurantList.item
        self.foods = data
        self.collectionView.reloadData()
    }
}

//MARK: - Delegate, Datasource

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foods.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MainCollectionViewCell
        cell.nameLabel.text = foods[indexPath.row].biz_nm
        cell.image.image = UIImage(named: "\(foodImages[indexPath.row])")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("click\(indexPath.row)")
        let vc = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController
        vc?.restaurantId = self.foods[indexPath.row].biz_nm!
        vc?.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width / 2, height: 240)
    }
    
}
