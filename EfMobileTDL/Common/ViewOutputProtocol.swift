//
//  ViewOutputProtocol.swift
//  EfMobileTDL
//
//  Created by Kirill Sklyarov on 07.03.2025.
//

import Foundation

protocol ViewOutputProtocol: AnyObject {
    var view: EditItemViewInput? { get set }
    var interactor: EditItemInteractorInput { get set }

    func viewLoaded()

}
