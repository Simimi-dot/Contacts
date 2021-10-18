//
//  ViewController.swift
//  Contacts
//
//  Created by Егор Астахов on 18.10.2021.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Получаем экземпляр ячейки
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
        // Конфигурируем ячейку
        // Метод возвращает пустую конфигурацию ячейки
        var configuration = cell.defaultContentConfiguration()
        // Данная пустая конфигурация наполняется данными
        configuration.text = "Строка \(indexPath.row)"
        // Наполненная конфигурация передется ячейке
        cell.contentConfiguration = configuration
        // Возвращаем сконфигурированный экземпляр ячейки
        return cell
    }
}

