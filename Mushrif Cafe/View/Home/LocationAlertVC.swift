//
//  LocationAlertVC.swift
//  Mushrif Cafe
//
//  Created by bhikhu on 20/07/25.
//

import UIKit

class LocationAlertVC: UIViewController , Instantiatable {
    @IBOutlet weak var btnYes: UIButton!
    
    @IBOutlet weak var lblSelectTable: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var viewSelection: UIStackView!
    @IBOutlet weak var txtName: UITextField!
    static var storyboard: AppStoryboard = .home
  
    @IBOutlet weak var btnCancel: UIButton!
    var objHallResponseModel: HallResponseModel?
    var arrSections =  [SectionModel]()
    var hallID: Int?
    var objHallAssignmentResponse: HallAssignmentResponse?
    var comletionBlock: ((HallAssignment?) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        lbltitle.text = "lbl_location_title".localized()
        btnCancel.setTitle("cancel".localized(), for: .normal)
        btnYes.setTitle("btn_Yes".localized(), for: .normal)
        lblSelectTable.text = "lbl_select_table".localized()
        txtName.placeholder =  "lbl_AreaName".localized()
        
        setupView()
    }
    
    
    private func setupView() {
        viewSelection.isHidden = true
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        getProfile()
    }
    
    @IBAction func btnYesTapped(_ sender: Any) {
        viewSelection.isHidden = false

    }
    private func getProfile() {
        let aParams: [String: Any] = [:]
        
        APIManager.shared.getCallWithParams(APPURL.gteGalls, params: aParams) { [self] responseJSON in
                    
            self.objHallResponseModel = HallResponseModel(json: responseJSON) // ✅ Use your initializer
                self.arrSections = self.objHallResponseModel?.sections ?? []
        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
    @IBAction func btnCancelTapped(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func showHalles()   {
             let arrStore = arrSections.map { $0.name }
        if arrStore.count > 0 {
            PickerView.sharedInstance.addPicker(self, onTextField: txtName, pickerArray: arrStore as? [String] ?? [] ) { [self] index, value, isDismiss in
                if !isDismiss {
                    self.txtName.text  = value
                    if let index = self.arrSections.firstIndex(where: { $0.name == value }) {
                        self.hallID = self.arrSections[index].id ?? 0
                        autoselecttableAPI()
                    }
                }
                self.txtName.resignFirstResponder()
            }
        } else {
            self.showEmptyPicker(txtField: txtName)
        }
      
    }
    
    private func autoselecttableAPI() {
        var aParams: [String: Any] = [:]
         aParams["hall_id"] = self.hallID

        APIManager.shared.postCall(APPURL.autoselecttable, params: aParams, withHeader: true) { [self] responseJSON in
            self.objHallAssignmentResponse = HallAssignmentResponse(json: responseJSON) // ✅ Use your initializer
            if self.objHallAssignmentResponse?.success ?? false {
                self.dismiss(animated: true, completion: { [self] in
                    self.comletionBlock?(objHallAssignmentResponse?.data)
                })
            }
            
        } failure: {error in
            print("Error \(error.localizedDescription)")
        }
    }
}


// MARK: - UITextFieldDelegate delegates and datasource method
extension LocationAlertVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if arrSections.count > 0 {
            showHalles()
        }
    }
}
