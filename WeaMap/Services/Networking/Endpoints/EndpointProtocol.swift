//
//  EndpointProtocol.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation

protocol EndpointProtocol {

    var baseURL: URL { get }
    var absoluteURL: URL { get }
}
