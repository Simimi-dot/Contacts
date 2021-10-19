//
//  Contact.swift
//  Contacts
//
//  Created by Егор Астахов on 19.10.2021.
//

import Foundation

protocol ContactProtcol {
    /// Имя
    var title: String { get set }
    /// Номер телефона
    var phone: String { get set }
}

struct Contact: ContactProtcol {
    var title: String
    var phone: String
}

protocol ContactStorageProtocol {
    // Загрузка списка контактов
    func load() -> [ContactProtcol]
    // Обновление списка контактов
    func save(contacts: [ContactProtcol])
}

class ContactStorage: ContactStorageProtocol {
    // Ссылка на хранилище
    private var storage = UserDefaults.standard
    // Ключ по которому будет происходить сохранение хранилища
    private var storageKey = "contacts"
    
    // Перечисление с ключами для записи в User Defaults
    private enum ContactKey: String {
        case title
        case phone
    }
    // Загрузка списка контактов
    func load() -> [ContactProtcol] {
        // создаем пустой массив типа ContactProtocol
        var resultContacts: [ContactProtcol] = []
        // создаем константу и инициализируем ей массив с ключом и приводим к читаемому user Defaults типу словаря string : string
        let contactsFromStorage = storage.array(forKey: storageKey) as? [[String : String]] ?? []
        
        for contact in contactsFromStorage {
            guard let title = contact[ContactKey.title.rawValue], let phone = contact[ContactKey.phone.rawValue] else {
                continue
            }
            resultContacts.append(Contact(title: title, phone: phone))
        }
        return resultContacts
    }
    // Обновление списка контактов
    func save(contacts: [ContactProtcol]) {
        var arrayForStorage: [[String : String]] = []
        contacts.forEach { contact in
            var newElementForStorage: Dictionary<String, String> = [:]
            newElementForStorage[ContactKey.title.rawValue] = contact.title
            newElementForStorage[ContactKey.phone.rawValue] = contact.phone
            arrayForStorage.append(newElementForStorage)
        }
        // Записываем в userDefaults значения словаря arrayForStorage c ключом storageKey
        storage.set(arrayForStorage, forKey: storageKey)
    }
}
