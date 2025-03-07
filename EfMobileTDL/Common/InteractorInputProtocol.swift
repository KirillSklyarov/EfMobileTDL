//
//  InteractorInputProtocol.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol InteractorInputProtocol: AnyObject {
    var output: ViewOutputProtocol? { get set }
}
