//
//  HomeVC.swift
//  NewWeatherApp
//
//  Created by Arun on 28/09/23.
//

import UIKit
import Combine

class HomeVC: UIViewController {
    
    @IBOutlet var placeLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    @IBOutlet weak var windSpeedLbl: UILabel!
    
    @IBOutlet weak var windDirectionLbl: UILabel!
    @IBOutlet weak var tempIcon: UIImageView!
    @IBOutlet weak var windSpeedIcon: UIImageView!
    @IBOutlet weak var windDirectionIcon: UIImageView!
    @IBOutlet weak var sunIcon: UIImageView!
    private var backgroundGradient: CAGradientLayer!
    var viewModel : HomeViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureBackground()
        // Do any additional setup after loading the view.
    }
    func setupUI(){
        
        bind(viewModel.outputs)
        viewModel.inputs.fetchLocation()
        let buttonItem = UIBarButtonItem(image: UIImage(systemName:
        "note.text.badge.plus"), style: .plain, target: self, action:
                                            #selector(toDoBtnAction))
        buttonItem.tintColor = .white
        self.navigationItem.rightBarButtonItem = buttonItem
    }
    private func bind(_ outPuts: HomeViewModelOutputType){
        outPuts
            .currentWeather
            .sink{ [weak self] weather in
                guard let temp = weather?.currentWeather?.temperature,
                      let speed = weather?.currentWeather?.windspeed,
                      let direction = weather?.currentWeather?.winddirection,
                      let tempUnit = weather?.currentWeatherUnits?.temperature,
                      let windSpeedUnit = weather?.currentWeatherUnits?.windspeed,
                let windDirUnit = weather?.currentWeatherUnits?.winddirection
                else{ return }
                self?.temperatureLbl.text = "Temperature: \(temp) \(tempUnit)"
                self?.windSpeedLbl.text = "Wind Speed: \(speed) \(windSpeedUnit)"
                self?.windDirectionLbl.text = "Wind Direction: \(direction) \(windDirUnit)"
                self?.windSpeedIcon.image = UIImage(systemName:"wind")?
                    .withRenderingMode(.alwaysOriginal)
                
                self?.windDirectionIcon.image = UIImage(systemName:"tornado")?
                    .withRenderingMode(.alwaysOriginal)
            }
            .store(in:&cancellables)
        
        outPuts
            .place
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] place in
                
                self?.placeLbl.text = place
            }
            .store(in: &cancellables)
        outPuts
            .thermometerString
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] thermo in
                
                self?.tempIcon.image = UIImage(systemName: thermo)?
                    .withRenderingMode(.alwaysOriginal)
                
            }
            .store(in: &cancellables)
        
        outPuts.timeString
            .sink{ [weak self] timeString in
                if (!timeString.isEmpty){
                    if #available(iOS 17.0, *) {
                        self?.sunIcon.setSymbolImage( UIImage(systemName: timeString)!,
                                                      contentTransition: .replace.downUp)
                    } else {
                        self?.sunIcon.image = UIImage(systemName: timeString)?
                            .withRenderingMode(.alwaysOriginal)
                        
                    }
                }
            }
            .store(in: &cancellables)
        
        
    }
    private func configureBackground() {
        backgroundGradient = CAGradientLayer.gradientLayer(in: view.bounds)
        view.layer.insertSublayer(backgroundGradient, at: 0)
    }
    @objc func toDoBtnAction(_ sender: Any) {
        viewModel.inputs.didPressToDo()
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
