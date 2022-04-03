//
//  ForecastViewController.swift
//  weather
//
//  Created by MJ on 8/8/2564 BE.
//

import UIKit
import Foundation

class ForecastViewController: UIViewController {
    private let apiKey = "0b10de1e5ce99c31cd7017f3dfa3d37e"
    private var model: ForecastModel?
    
    public var city: String?
    public var isFahrenheit: Bool?

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("City: \(city ?? "")")
        let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast?q=\(city ?? "")&appid=\(apiKey)")
        getForecast(url: url)
    }
    
    private func getForecast (url: URL?) {
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
            let jsonData = try JSONDecoder().decode(ForecastModel.self, from: JSONData)
            print(jsonData)
            self.model = jsonData
            handleData()
        } catch let error as NSError {
            print(error)
        }
    }
    
    private func handleData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func onTouchBackButton(_ sender: Any) {
        navigationController?.popViewController(animated: false)
    }
}

extension ForecastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableViewHeight.constant = tableView.contentSize.height + 20
        if #available(iOS 13.0, *) { tableView.layoutIfNeeded() }
    }
}

extension ForecastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(model?.list?.count ?? 0)
        return model?.list?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastTableViewCell",
                                                 for: indexPath) as? ForecastTableViewCell
        let data = model?.list?[indexPath.row]
        cell?.bindData(date: data?.dtTxt,
                       temperature: data?.main?.temp,
                       humidity: data?.main?.humidity,
                       icon: data?.weather?[0].icon,
                       isFahrenheit: isFahrenheit ?? true)
        return cell!
    }
}
