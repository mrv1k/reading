//
//  ViewModelProtocols.swift
//  reading
//
//  Created by Viktor Khotimchenko on 2020-11-17.
//  Copyright © 2020 mrv1k. All rights reserved.
//
import Combine

import SwiftUI

protocol ViewModel: ObservableObject {}

protocol ViewModelObserver {
    associatedtype ObjectType: ViewModel
    var viewModel: ObjectType { get }
}
