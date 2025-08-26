//
//  TextInputProtocol.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 26.08.2025.
//

import Foundation

protocol TextInputProtocol: AnyObject {
    func handleTitleChange(title: String)
    func handleSubTitleChange(subTitle: String)
}
