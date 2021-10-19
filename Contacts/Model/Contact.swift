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
