//
//  BuilderProtocol.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol BuilderProtocol {
    associatedtype Screen

    func build() -> Screen
}
