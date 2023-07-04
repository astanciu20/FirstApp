import SwiftUI

struct TabItem: View {
    @ObservedObject var activityStore: ActivityStore
    @ObservedObject var profileStore: ProfileStore
    @State private var selectedTab = 1
    @State private var isPresentingNewActivityView = false
    @State private var selected: Pozitie = .frontend
    @State private var isPresentingEditProfile = false
    
    var pozitie: String {
        switch selected {
        case .frontend:
            return "frontend"
        case .backend:
            return "backend"
        case .devops:
            return "devops"
        case .android:
            return "android"
        case .ios:
            return "ios"
        }
    }
    
    enum Pozitie {
        case frontend
        case backend
        case devops
        case android
        case ios
    }
    
    var body: some View {
        NavigationView{
            VStack{
                if selectedTab == 1 {
                    if selected == .ios {
                        Text(pozitie.uppercased())
                            .padding(.top, 20)
                            .font(.title)
                    } else {
                        Text(pozitie.capitalized)
                            .padding(.top, 20)
                            .font(.title)
                    }
                }
                TabView(selection: $selectedTab) {
                    FavoritesView(activityStore: activityStore)
                        .tabItem {
                            Label("Favorites", systemImage: "star")
                        }
                        .tag(0)
                    
                    MainScreen(activityStore: activityStore)
                        .tabItem {
                            Label("Explore", systemImage: "safari.fill")
                        }
                        .tag(1)
                    
                    ProfileView(profileStore: profileStore)
                        .tabItem {
                            Label("Profile", systemImage: "person.crop.circle.fill")
                        }
                        .tag(2)
                }
                .toolbar {
                    if selectedTab == 1 {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Menu {
                                Button(action: { selected = .frontend
                                    activityStore.name = "frontend"
                                    Task {
                                        try await activityStore.loadActivity()
                                    }
                                }) {
                                    Label("Frontend", systemImage: selected == .frontend ? "checkmark.circle.fill" : "circle")
                                }
                                Button(action: { selected = .backend
                                    activityStore.name = "backend"
                                    Task {
                                        try await activityStore.loadActivity()
                                    }
                                }) {
                                    Label("Backend", systemImage: selected == .backend ? "checkmark.circle.fill" : "circle")
                                }
                                Button(action: { selected = .devops
                                    activityStore.name = "devops"
                                    Task {
                                        try await activityStore.loadActivity()
                                    }
                                }) {
                                    Label("DevOps", systemImage: selected == .devops ? "checkmark.circle.fill" : "circle")
                                }
                                Button(action: { selected = .android
                                    activityStore.name = "android"
                                    Task {
                                        try await activityStore.loadActivity()
                                    }
                                }) {
                                    Label("Android", systemImage: selected == .android ? "checkmark.circle.fill" : "circle")
                                }
                                Button(action: { selected = .ios
                                    activityStore.name = "ios"
                                    Task {
                                        try await activityStore.loadActivity()
                                    }
                                }) {
                                    Label("IOS", systemImage: selected == .ios ? "checkmark.circle.fill" : "circle")
                                }
                            }
                        label: {
                            Image(systemName: "arrow.up.arrow.down.circle")
                        }
                        .accessibilityLabel("Selectie")
                        .font(.system(size: 20))
                        .padding(5)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isPresentingNewActivityView = true
                            }) {
                                Image(systemName: "plus")
                            }
                            .accessibilityLabel("New Activity")
                            .font(.system(size: 20))
                            .padding(5)
                        }
                    }
                    if selectedTab == 0 {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                confirmationAlert()
                            }) {
                                Image(systemName: "trash.circle")
                            }
                            .accessibilityLabel("New Activity")
                            .font(.system(size: 20))
                            .padding(5)
                        }
                    }
                    if selectedTab == 2 {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                isPresentingEditProfile = true
                            }) {
                                Image(systemName: "square.and.pencil.circle.fill")
                            }
                            .accessibilityLabel("Edit Profile")
                            .font(.system(size: 20))
                            .padding(5)
                        }
                    }
                }
                .onChange(of: selectedTab) { tab in
                    switch tab {
                    case 0:
                        Task{
                            do {
                                try await activityStore.loadFavorite()
                            }
                        }
                    default:
                        break
                    }
                }
                .sheet(isPresented: $isPresentingNewActivityView){
                    NewActivitySheet(isPresentingNewActivity: $isPresentingNewActivityView, activityStore: activityStore, pozitie: pozitie)
                }
                .sheet(isPresented: $isPresentingEditProfile) {
                    ProfileFormView(isPresentingEditProfile: $isPresentingEditProfile, profileStore: profileStore)
                }
            }
        }
    }
    
    func confirmationAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }
        
        let alertController = UIAlertController(title: "Confirmation", message: NSLocalizedString("favorites_delete_message", comment: ""), preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            Task {
                    try await activityStore.clearFavorites()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        if let window = windowScene.windows.first {
            window.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}
