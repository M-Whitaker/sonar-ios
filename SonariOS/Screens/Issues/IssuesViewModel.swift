//
//  IssuesViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 07/12/2024.
//

import Factory
import Foundation

class IssuesViewModel: ObservableObject {
    @Injected(\.sonarClientFactory) var sonarClientFactory

    @Published var state: ViewLoadingState<[Issue]> = .isLoading
    @Published var newItemsLoading = false

    var itemsLoadedCount: Int?
    var page: Page?
    private let itemsFromEndThreshold = 3

    @MainActor
    func getIssues(index: Int) async {
        guard let itemsLoadedCount,
              var p = page
        else {
            return
        }

        if thresholdMeet(itemsLoadedCount, index),
           moreItemsRemaining(itemsLoadedCount, p.total)
        {
            newItemsLoading = true
            p.pageIndex += 1
            await getIssues(requestedPage: p)
            newItemsLoading = false
        }
    }

    func getIssues() async {
        await resetIssues()
        await getIssues(requestedPage: Page(pageSize: 20))
    }

    @MainActor
    func getIssues(requestedPage: Page) async {
        do {
            let issues = try await sonarClientFactory.current.retrieveIssues(page: requestedPage)
            page = issues.paging
            if var itemCount = itemsLoadedCount {
                itemCount += issues.items.count
                itemsLoadedCount = itemCount
            } else {
                itemsLoadedCount = issues.items.count
            }

            if case var .loaded(currIssues) = state {
                currIssues.append(contentsOf: issues.items)
                state = .loaded(currIssues)
            } else {
                state = .loaded(issues.items)
            }
        } catch {
            state = .failed(error)
        }
    }

    @MainActor
    func resetIssues() {
        itemsLoadedCount = nil
        page = nil
        state = .loaded([])
    }

    /// Determines whether we have meet the threshold for requesting more items.
    private func thresholdMeet(_ itemsLoadedCount: Int, _ index: Int) -> Bool {
        (itemsLoadedCount - index) == itemsFromEndThreshold
    }

    /// Determines whether there is more data to load.
    private func moreItemsRemaining(_ itemsLoadedCount: Int, _ totalItemsAvailable: Int) -> Bool {
        itemsLoadedCount < totalItemsAvailable
    }
}
