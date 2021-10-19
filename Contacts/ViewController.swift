//
//  ViewController.swift
//  Contacts
//
//  Created by Егор Астахов on 18.10.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    private var contacts: [ContactProtcol] = [] {
        // Добавляем наблюдатель к свойству, чтобы при введении новых контактов они располагались в алфавитном порядке
        didSet {
            // Сортировка массива в алфавитном порядке
            contacts.sort { $0.title < $1.title}
            // Сохранение контактов в хранилище
            storage.save(contacts: contacts)
        }
    }
    
    // Свойство которое содержит в себе ссылку на хранилище
    var storage: ContactStorageProtocol!
    
    // Приватный метод наполняющий свойство тестовыми данными
    private func loadContacts() {
        contacts = storage.load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storage = ContactStorage()
        loadContacts()
    }
    
    // Экшн для появления алерта и добавления контактов
    @IBAction func showNewContactAlert() {
        // Создание алерт контроллера
        let alertController = UIAlertController(title: "Создайте новый контакт", message: "Введите имя и телефон", preferredStyle: .alert)
        // Добавляем первое текстовое поле в алерт контроллер
        alertController.addTextField { textField in
            textField.placeholder = "Имя"
        }
        // Добавляем второе текстовое поле в алерт контроллер
        alertController.addTextField { textField in
            textField.placeholder = "Номер телефона"
        }
        // Создаем кнопки
        // Кнопка создания контакта
        let createButton = UIAlertAction(title: "Создать", style: .default) { _ in
            guard let contactName = alertController.textFields?[0].text, let contactPhone = alertController.textFields?[1].text else {
                      return
                  }
            // создаем новый контакт
            let contact = Contact(title: contactName, phone: contactPhone)
            self.contacts.append(contact)
            self.tableView.reloadData()
        }
        // Кнопка отмены
        let cancelButton = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)
        // Добавлям кнопки в alertController
        alertController.addAction(cancelButton)
        alertController.addAction(createButton)
        // Отображаем alertController
        self.present(alertController, animated: true, completion: nil)
    }
    
}

// Расширение для добавления строк, ячеек, и базы данных для этих ячеек
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

// Расширение для возможности добавления действий строки по свайпу
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

