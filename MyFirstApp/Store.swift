import SwiftUI

@MainActor
class AccountsStore: ObservableObject {
    @Published var accounts: [Account] = []
    
    private func fileURL() throws -> URL {
        try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("accounts.data")
    }
    
    func loadAccounts() throws {
        let fileURL = try fileURL()
        guard let data = try? Data(contentsOf: fileURL) else {
            return
        }
        let decodedAccounts = try JSONDecoder().decode([Account].self, from: data)
        accounts = decodedAccounts
    }
    
    func saveAccounts() async throws {
        let fileURL = try fileURL()
        let encodedAccounts = try JSONEncoder().encode(accounts)
        try encodedAccounts.write(to: fileURL)
    }
    
    func saveAccount(_ account: Account) async throws {
        accounts.append(account)
        try await saveAccounts()
    }
    
    func updateAccountDetails(for account: Account) async throws {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index] = account
            try await saveAccounts()
        }
        try loadAccounts()
    }
    
    func saveNewActivity(for activity: Activity, in account: Account) async throws {
        let task = Task {
            try loadAccounts()
            if let accountIndex = accounts.firstIndex(where: { $0.id == account.id }) {
                accounts[accountIndex].activities.append(activity)
                try await saveAccounts()
            }
        }
        _ = try await task.value
    }
    
    func updateActivityStatusTrue(for activity: Activity, in account: Account) async throws {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].activities = accounts[index].activities.map { storedActivity in
                if storedActivity.id == activity.id {
                    var updatedActivity = storedActivity
                    updatedActivity.status = true
                    return updatedActivity
                } else {
                    return storedActivity
                }
            }
            try await saveAccounts()
            
            if !accounts[index].favorites.contains(where: { $0.id == activity.id }) {
                accounts[index].favorites.append(activity)
                try await saveAccounts()
            }
        }
    }
    
    func updateActivityStatusFalse(for activity: Activity, in account: Account) async throws {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].activities = accounts[index].activities.map { storedActivity in
                if storedActivity.id == activity.id {
                    var updatedActivity = storedActivity
                    updatedActivity.status = false
                    return updatedActivity
                } else {
                    return storedActivity
                }
            }
            try await saveAccounts()
        }
    }

    func addComment(newComment: Comment, for activity: Activity, in account: Account) async throws {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].comments.append(newComment)
        }
        
        if let accountIndex = accounts.firstIndex(where: { $0.id == account.id }),
           let activityIndex = accounts[accountIndex].activities.firstIndex(where: { $0.id == activity.id }) {
            accounts[accountIndex].activities[activityIndex].comments.append(newComment)
        
            if accounts[accountIndex].favorites.contains(where: { $0.id == activity.id }) {
                if let favoriteIndex = accounts[accountIndex].favorites.firstIndex(where: { $0.id == activity.id }) {
                    accounts[accountIndex].favorites[favoriteIndex].comments.append(newComment)
                }
            }
        }
        try await saveAccounts()
    }
    
    func clearFavorites(for account: Account) async throws {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].favorites = []
            try await saveAccounts()
        }
    }
    
    func clearComments(for account: Account) async throws {
        if let index = accounts.firstIndex(where: { $0.id == account.id }) {
            accounts[index].comments = []
            try await saveAccounts()
        }
    }
    
}
