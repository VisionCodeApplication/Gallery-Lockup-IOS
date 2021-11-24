//
//  SettingVC.swift
//  Gallery Lockup
//
//  Created by iMac on 15/11/21.
//

import UIKit
import GoogleMobileAds
import Firebase
import LocalAuthentication

class SettingVC: UIViewController {

    @IBOutlet var Mainview: UIView!
    @IBOutlet var Subview: UIView!
    @IBOutlet var Fingerprintswitch: UISwitch!
    @IBOutlet var Numberbtn: UIButton!
    @IBOutlet var Fingerbtn: UIButton!
    @IBOutlet var Patternbtn: UIButton!
    
    
    var DBvalue = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Subview.layer.cornerRadius = 20
        Fingerbtn.layer.cornerRadius = 7
        Numberbtn.layer.cornerRadius = 7
        Patternbtn.layer.cornerRadius = 7
        
        let database = Database.database().reference()
        
        database.child("hidedata").observe(.value) { snapshot in
            print(snapshot.value!)
            self.DBvalue = snapshot.value as! Int
            if(self.DBvalue == 1){
                self.Launchbannerad()
            }
        }
        var use = UserDefaults.standard
        if use.value(forKey: "Fingerpass") != nil {
            Fingerprintswitch.isOn = use.value(forKey: "Fingerpass") as! Bool
        }
        Fingerprintswitch.set()
    }
    
    
    func Launchbannerad(){
        baneer = GADBannerView(adSize: kGADAdSizeBanner)
        baneer.adUnitID = Bannerad
        baneer.rootViewController = self
        addBannerViewToView(baneer)
        baneer.load(GADRequest())
    }
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        view.addConstraints(
          [NSLayoutConstraint(item: bannerView,
                              attribute: .bottom,
                              relatedBy: .equal,
                              toItem: bottomLayoutGuide,
                              attribute: .top,
                              multiplier: 1,
                              constant: 0),
           NSLayoutConstraint(item: bannerView,
                              attribute: .centerX,
                              relatedBy: .equal,
                              toItem: view,
                              attribute: .centerX,
                              multiplier: 1,
                              constant: 0)
          ])
    }
    
    @IBAction func SwitchPress(_ sender: Any) {
        if Fingerprintswitch.isOn {
            Fingerprintswitch.thumbTintColor = .white
            let context = LAContext()
            var error : NSError?
            if context.canEvaluatePolicy(LAPolicy.deviceOwnerAuthenticationWithBiometrics, error:&error) {
                let user = UserDefaults.standard
            user.setValue(Fingerprintswitch.isOn, forKey: "Fingerpass")
            print("is on")
            }else{
                let alert = UIAlertController(title: "Error", message: "Please set your finger print in phone using setting.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { UIAlertAction in
                    self.Fingerprintswitch.isOn = false
                    self.Fingerprintswitch.thumbTintColor = UIColor(red: 0.52, green: 0.61, blue: 0.59, alpha: 1)
                }))
                self.present(alert, animated: true, completion: nil)
            }
        }else{
            Fingerprintswitch.thumbTintColor = UIColor(red: 0.52, green: 0.61, blue: 0.59, alpha: 1)
            let user = UserDefaults.standard
            user.setValue(Fingerprintswitch.isOn, forKey: "Fingerpass")
            print("is off")
        }
    }
    @IBAction func Petternbtnclick(_ sender: Any) {
        var nxt = storyboard?.instantiateViewController(withIdentifier: "PatternVC") as! PatternVC
        navigationController?.pushViewController(nxt, animated: true)
    }
    
    @IBAction func Numberbtnclick(_ sender: Any) {
        var nxt = storyboard?.instantiateViewController(withIdentifier: "LockScreenVC") as! LockScreenVC
        navigationController?.pushViewController(nxt, animated: true)
    }
    @IBAction func Backbtnclick(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
}
extension UISwitch {

    func set() {

        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51

        let heightRatio = 20 / standardHeight
        let widthRatio = 40 / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
