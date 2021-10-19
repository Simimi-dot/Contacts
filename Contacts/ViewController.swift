//
//  ViewController.swift
//  Contacts
//
//  Created by Егор Астахов on 18.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private var contacts = [ContactProtcol]()
    
    // Приватный метод наполняющий свойство тестовыми данными
    private func loadContacts() {
        contacts.append(Contact(title: "Саня техосмотр", phone: "+799912312323"))
        contacts.append(Contact(title: "Владимир Анатольевич", phone: "+781213342321"))
        contacts.append(Contact(title: "Сильвестр", phone: "+7000911112"))
        contacts.sort { $0.title < $1.title }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadContacts()
    }
    
    
}

extension ViewController: UITableViewDataSource {
    
    private func configure(cell: inout UITableViewCell, for indexPath: IndexPath) {
        // Конфигурируем ячейку
        // Метод возвращает пустую конфигурацию ячейки
        var configuration = cell.defaultContentConfiguration()
        // Имя контакта
        configuration.text = contacts[indexPath.row].title
        // Номер телефона контакта
        configuration.secondaryText = contacts[indexPath.row].phone
        // Наполненная конфигурация передется ячейке
        cell.contentConfiguration = configuration
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращает количество строк равное количеству контактов
        return contacts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        // производим попытку загрузки переиспользуемой ячейки
        if let reuseCell = tableView.dequeueReusableCell(withIdentifier: "MyCell") {
            print("Используем старую ячейку для строки с индексом \(indexPath.row)")
            // инициализируем ячейке переиспользованную ячейку
            cell = reuseCell
        } else {
            print("Создаем новую ячейку для строки с индексом \(indexPath.row)")
            // Получаем экземпляр ячейки
            cell = UITableViewCell(style: .default, reuseIdentifier: "MyCell")
        }
        // конфигуриуем ячейку
        configure(cell: &cell, for: indexPath)
        // возвращаем сконфигурированный экземпляр
        return cell
    }
    
}

extension ViewController: UITableViewDelegate {
    // Метод определяет действия по свайпу влево для конкретной строки
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Действие удаления
        let actionDelete = UIContextualAction(style: .destructive, title: "Удалить") { _,_,_ in
            // удаляем контакт
            self.contacts.remove(at: indexPath.row)
            // Заново формируем табличное представление
            tableView.reloadData()
        }
        // Формируем экземпляр описывающий доступные действия
        let actions = UISwipeActionsConfiguration(actions: [actionDelete])
        return actions
    }
}

