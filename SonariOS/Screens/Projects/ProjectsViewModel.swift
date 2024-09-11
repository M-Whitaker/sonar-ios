//
//  ProjectsViewModel.swift
//  SonariOS
//
//  Created by Matt Whitaker on 17/08/2024.
//

import Factory
import Foundation

class ProjectsViewModel: ObservableObject {
    @Injected(\.sonarClientFactory) var sonarClientFactory

    @Published var state: ViewLoadingState<[Project]> = .isLoading
    @Published var newItemsLoading = false

    var itemsLoadedCount: Int?
    var page: Page?
    private let itemsFromEndThreshold = 3

    @MainActor
    func getProjects(index: Int) async {
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
            await getProjects(requestedPage: p)
            newItemsLoading = false
        }
    }

    func getProjects() async {
        await getProjects(requestedPage: Page(pageSize: 20))
    }

    @MainActor
    func getProjects(requestedPage: Page) async {
        do {
            let projects = try await sonarClientFactory.current.retrieveProjects(page: requestedPage)
            page = projects.paging
            if var itemCount = itemsLoadedCount {
                itemCount += projects.items.count
                itemsLoadedCount = itemCount
            } else {
                itemsLoadedCount = projects.items.count
            }

            if case var .loaded(currProjects) = state {
                currProjects.append(contentsOf: projects.items)
                state = .loaded(currProjects)
            } else {
                state = .loaded(projects.items)
            }
        } catch {
            state = .failed(error)
        }
    }

    func resetProjects() {
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
