//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Angela Yu on 23/01/2016.
//  Copyright © 2016 London App Brewery. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencySymbol = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""
    var currentRow = 0
    typealias JSON = [String: Any]

    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentRow = row
        finalURL = baseURL + currencyArray[row]
        getBitcoinData(url: finalURL)
    }

    //MARK: - Networking

    private func getBitcoinData(url: String) {
        guard let url = URL(string: url) else {
            bitcoinPriceLabel.text = "URL ERROR"
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if data != nil && error == nil {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? JSON {
                    self.updateBitcoinData(json: json!)
                } else {
                    self.bitcoinPriceLabel.text = "JSON ERROR"
                }
            } else {
                self.bitcoinPriceLabel.text = "JSON ERROR"
            }
        }
        task.resume()
    }

    //MARK: - Parse Data

    private func updateBitcoinData(json: JSON) {
        DispatchQueue.main.async {
            if let priceDouble = json["last"] as? Double {
                self.bitcoinPriceLabel.text = self.currencySymbol[self.currentRow] + String(Int(priceDouble))
            }
        }
    }
}

