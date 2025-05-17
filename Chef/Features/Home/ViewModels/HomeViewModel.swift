//
//  HomeViewModel.swift
//  ChefHelper
//
//  Created by 羅辰澔 on 2025/5/8.
//

import Foundation
import Combine
import SwiftUI

// MARK: - View State
enum ViewState {
    case loading
    case error(message: String)
    case dataLoaded
}

// MARK: - Strings
enum Strings {
    static let somethingWentWrong = "Something went wrong!"
    static let requestTimeout = "Request timeout, please retry"
    static let fetchingRecords = "Fetching dishes, Please Be Patient"
    static let fetchingMoreRecords = "Fetching more records"
    static let noInternet = "Internet not available, please check internet connection"
    static let noCharactersFound = "No character found!"
}

final class HomeViewModel: ObservableObject {

    private let service: NetworkServiceProtocol
    private var cancellables = Set<AnyCancellable>()
    @Published var viewState: ViewState = .loading
    @Published var allDishes: AllDishes?

    init(service: NetworkServiceProtocol = NetworkService()) {
        self.service = service
    }

    func fetchAllDishes() {
        self.viewState = .loading
        service.request(url: "https://yummie.glitch.me/dish-categories", decodeType: APIResponse.self)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    if let error = error as? URLError,
                       error.code == .timedOut {
                        self.viewState = .error(message: Strings.requestTimeout)
                    } else {
                        self.viewState = .error(message: Strings.somethingWentWrong)
                    }
                case .finished:
                    print("Finished")
                }
            } receiveValue: { [weak self] responseData in
                self?.allDishes = responseData.data
                self?.viewState = .dataLoaded
            }
            .store(in: &cancellables)
    }

}
