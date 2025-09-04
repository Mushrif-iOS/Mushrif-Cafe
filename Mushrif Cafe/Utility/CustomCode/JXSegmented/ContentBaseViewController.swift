//
//  ContentBaseViewController.swift
//  JXSegmentedView
//
//  Created by jiaxin on 2018/12/26.
//  Copyright © 2018 jiaxin. All rights reserved.
//

import UIKit
import EasyNotificationBadge

class ContentBaseViewController: UIViewController , Instantiatable{
    @IBOutlet weak var lblTable: UILabel!
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var btnCart: UIButton!
    static var storyboard: AppStoryboard = .home

    @IBOutlet weak var viewContainer: UIView!
    var subCategoriesArr : [SubCategory] = [SubCategory]()
    var foodItemArr : [FoodItemData] = [FoodItemData]()

    var categoryId = String()
    var categoryName = String()
    var subCategoryId = String()

    var segmentedDataSource: JXSegmentedBaseDataSource?
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    var strTitle = String()
    var subTitle = String()

    @IBOutlet weak var bottomView: UIView!
    @IBOutlet var heightBottom: NSLayoutConstraint!

    @IBOutlet weak var totalLabel: UILabel! {
        didSet {
            totalLabel.font = UIFont.poppinsMediumFontWith(size: 18)
            totalLabel.text = ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        lblTable.font = UIFont.poppinsSemiBoldFontWith(size: 15)
        lblTitle.text = strTitle
        lblTitle.font = UIFont.poppinsRegularFontWith(size: 15)
        lblSubTitle.font = UIFont.poppinsSemiBoldFontWith(size: 16)
        lblTable.text = ""
        if (UserDefaultHelper.tableId ?? "").isBlank  == false {
            //self.selectTableLabel.text = UserDefaultHelper.tableName
            self.lblTable.text = UserDefaultHelper.tableName
            self.lblTable.textColor = .black
        }
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
        
        viewContainer.addSubview(segmentedView)
        if UserDefaultHelper.language == "ar" {
            segmentedView.semanticContentAttribute = .forceLeftToRight
            segmentedView.collectionView.semanticContentAttribute = .forceLeftToRight
        }
        
        

        segmentedView.listContainer = listContainerView
        viewContainer.addSubview(listContainerView)
        btnBack.setArabic()
    
    }
        private func setupBadge() {
            var badgeAppearance = BadgeAppearance()
            badgeAppearance.backgroundColor = UIColor.appRed
            badgeAppearance.textColor = UIColor.white
            badgeAppearance.textAlignment = .center
            badgeAppearance.font = UIFont.poppinsLightFontWith(size: 12)
            badgeAppearance.distanceFromCenterX = 13
            badgeAppearance.distanceFromCenterY = -13
            badgeAppearance.allowShadow = true
            badgeAppearance.borderColor = UIColor.white
            badgeAppearance.borderWidth = 0.5
            if "\(UserDefaultHelper.totalItems ?? 0)" == "0" {
                self.btnCart.badge(text: nil)
            } else {
                self.btnCart.badge(text: "\(UserDefaultHelper.totalItems ?? 0)", appearance: badgeAppearance)
            }
        }


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
        if !(UserDefaultHelper.authToken ?? "").isBlank {
            self.getCartItem()
        }


        if UserDefaultHelper.totalItems ?? 0 == 0 {
            self.heightBottom.constant = 0
            self.bottomView.isHidden = true
            setupBadge()

        } else {
            self.heightBottom.constant = 90
            self.bottomView.isHidden = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        //离开页面的时候，需要恢复屏幕边缘手势，不能影响其他页面
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        segmentedView.frame = CGRect(x: 0, y: 0, width: viewContainer.bounds.size.width, height: 50)
        segmentedView.backgroundColor = UIColor.appBackground
        listContainerView.frame = CGRect(x: 0, y: 50, width: viewContainer.bounds.size.width, height: viewContainer.bounds.size.height - 50)
        bottomView.applyGradient(isVertical: true, colorArray: [UIColor.primaryBrown, UIColor.borderPink])

    }
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    private func getCartItem() {
        
        var cartData: CartResponse?
        
        let aParams = ["locale": UserDefaultHelper.language == "en" ? "English---us" : "Arabic---ae"]
        print(aParams)
        
        APIManager.shared.postCall(APPURL.get_cart, params: aParams, withHeader: true) { [self] responseJSON in
            print("Response JSON \(responseJSON)")
            let dataDict = responseJSON["response"]
            cartData = CartResponse(fromJson: dataDict)
            
            let totalCost = "\(cartData?.subTotal != "" ? cartData?.subTotal ?? "" : "")"
            let amt = Double("\(totalCost)") ?? 0.0
            
            self.totalLabel.text = UserDefaultHelper.language == "en" ? "\(UserDefaultHelper.totalItems ?? 0) \("item_added".localized()) - \(amt) \("kwd".localized())" : "\("kwd".localized()) \(UserDefaultHelper.totalItems ?? 0) \("item_added".localized()) - \(amt)"
            setupBadge()
            
        } failure: { error in
            print("Error \(error.localizedDescription)")
        }
    }
    
    @IBAction func btnCartTapped(_ sender: Any) {
        if UserDefaultHelper.authToken != "" {
            let cartVC = CartVC.instantiate()
            self.navigationController?.pushViewController(cartVC, animated: true)
        } else {
            let profileVC = LoginVC.instantiate()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }

    }

}

extension ContentBaseViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            //先更新数据源的数据
            dotDataSource.dotStates[index] = false
            //再调用reloadItem(at: index)
            segmentedView.reloadItem(at: index)
        }

        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension ContentBaseViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
    let categoryVC = CategoryViewController.instantiate()
        categoryVC.didRemoveBlock = { [self] in
            getCartItem()
        }
        categoryVC.subCategoryId = String(subCategoriesArr[index].id)
        lblSubTitle.text  = String(subCategoriesArr[index].name)
        categoryVC.categoryId = categoryId
        categoryVC.pageNo = 1
    categoryVC.subCategoriesArr = self.subCategoriesArr
    categoryVC.categoryName = categoryName
        categoryVC.titleName = String(subCategoriesArr[index].name)
        
        return categoryVC
    }
}

