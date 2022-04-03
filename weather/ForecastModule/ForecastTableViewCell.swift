//
//  ForecastTableViewCell.swift
//  weather
//
//  Created by MJ on 8/8/2564 BE.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func bindData(date: String?, temperature: Double?, humidity: Int?, icon: String?, isFahrenheit: Bool) {
        let celsius = (temperature ?? 0.00) - 273
        let fahrenheit = (9/5*celsius)+32
        let temerature = String(format: "%.1f", isFahrenheit ? fahrenheit : celsius)
        dayLabel.text = date
        temperatureLabel.text = isFahrenheit ? "\(temerature) °F" : "\(temerature) °C"
        humidityLabel.text = "\(humidity ?? 0) %"
        weatherImageView.image = UIImage(named: icon ?? "")
    }

}
