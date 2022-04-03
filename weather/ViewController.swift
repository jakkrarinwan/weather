//
//  ViewController.swift
//  weather
//
//  Created by MJ on 2/8/2564 BE.
//

import UIKit
import Foundation
import SwiftUI

class ViewController: UIViewController {
    private let apiKey = "0b10de1e5ce99c31cd7017f3dfa3d37e"
    private var model: WeatherModel?
    private var isFahrenheit = false

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var convertLabel: UILabel!
    @IBOutlet weak var convertButtonView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        convertButtonView.isHidden = true
        // Do any additional setup after loading the view.
    }

    private func getWeather (url: URL?) {
        let task = URLSession.shared.dataTask(with: url!) { data, response, error in
            if let error = error {
                print("Error : \(error.localizedDescription)")
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200
            else {
                print("Error : HTTP Response Code Error")
                return
            }
            
            guard let data = data else {
                print("Error : No Response")
                return
            }
            self.decodeJSONData(JSONData: data)
        }
        task.resume()
    }
    
    private func decodeJSONData(JSONData: Data) {
        do {
            let jsonData = try JSONDecoder().decode(WeatherModel.self, from: JSONData)
            print(jsonData)
            self.model = jsonData
            handleData()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func handleData() {
        let celsius = (self.model?.main?.temp ?? 0.00) - 273
        let fahrenheit = (9/5*celsius)+32
        let temerature = String(format: "%.1f", isFahrenheit ? fahrenheit : celsius)
        DispatchQueue.main.async {
            self.convertButtonView.isHidden = false
            self.temperatureLabel.text = self.isFahrenheit ? "\(temerature) °F" : "\(temerature) °C"
            self.humidityLabel.text = "\(self.model?.main?.humidity ?? 0) %"
            self.weatherImageView.image = UIImage(named: self.model?.weather?[0].icon ?? "")
        }
    }
    
    @IBAction func onTouchSubmitButton(_ sender: Any) {
        if (cityTextField.text?.isEmpty ?? false) {
            let alert = UIAlertController(title: "Alert",
                                          message: "Please enter your city",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        } else {
            let cityName = cityTextField.text ?? ""
            let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(apiKey)")
            getWeather(url: url)
        }
    }
    
    @IBAction func onTouchConvertButton(_ sender: Any) {
        isFahrenheit.toggle()
        convertLabel.text = isFahrenheit ? "convert fahrenheit to celsius" : "convert celsius to fahrenheit"
        handleData()
    }
    
    @IBAction func onTouchNextButton(_ sender: Any) {
        if (cityTextField.text?.isEmpty ?? false) {
            let alert = UIAlertController(title: "Alert",
                                          message: "Please enter your city",
                                          preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Done", style: .cancel, handler: nil))
            self.present(alert, animated: false, completion: nil)
        } else {
            let vc = ForecastViewController.instantiate(storyboardName: .main)
            vc.city = cityTextField.text
            vc.isFahrenheit = isFahrenheit
            navigationController?.pushViewController(vc, animated: false)
        }
    }
}


