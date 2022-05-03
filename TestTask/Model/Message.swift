//
//  Message.swift
//  TestTask
//
//  Created by Vadim Novikov on 18.04.2022.
//

import UIKit

protocol MessageProtocol {
    var message: String {get}
}
struct Message: MessageProtocol {
    var message: String
}
