import SwiftUI

struct FavoritesView: View {
    @ObservedObject var activityStore: ActivityStore
    
    var body: some View {
        ScrollView {
            VStack {
                if (activityStore.favorite == []) {
                    FavoriteViewNil()
                } else {
                    Section(header: Text("Frontend")) {
                        if activityStore.favorite.filter ({ $0.role == "frontend" }).count == 0 {
                            FavoritesCategoryNil()
                        } else {
                            ForEach(activityStore.favorite, id: \.title) { activity in
                                if activity.role == "frontend" {
                                    NavigationLink(destination: ActivityDetailsView(activity: activity)) {
                                        ActivityCard(activity: activity, color: .blue)
                                    }
                                }
                            }
                        }
                        Section(header: Text("Backend")) {
                            if activityStore.favorite.filter({ $0.role == "backend" }).count == 0 {
                                FavoritesCategoryNil()
                            } else {
                                ForEach(activityStore.favorite, id: \.title) { activity in
                                    if activity.role == "backend" {
                                        ActivityCard(activity: activity, color: .blue)
                                    }
                                }
                            }
                        }
                        Section(header: Text("DevOps")) {
                            if activityStore.favorite.filter({ $0.role == "devops" }).count == 0 {
                                FavoritesCategoryNil()
                            } else {
                                ForEach(activityStore.favorite, id: \.title) { activity in
                                    if activity.role == "devops" {
                                        ActivityCard(activity: activity, color: .blue)
                                    }
                                }
                            }
                        }
                        Section(header: Text("Android")) {
                            if activityStore.favorite.filter({ $0.role == "android" }).count == 0 {
                                FavoritesCategoryNil()
                            } else {
                                ForEach(activityStore.favorite, id: \.title) { activity in
                                    if activity.role == "android" {
                                        ActivityCard(activity: activity, color: .blue)
                                    }
                                }
                            }
                        }
                        Section(header: Text("IOS")) {
                            if activityStore.favorite.filter({ $0.role == "ios" }).count == 0 {
                                FavoritesCategoryNil()
                            } else {
                                ForEach(activityStore.favorite, id: \.title) { activity in
                                    if activity.role == "ios" {
                                        ActivityCard(activity: activity, color: .blue)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
        }
    }
}
struct FavoriteViewNil: View {
    var body: some View {
        HStack {
            Text(LocalizedStringKey("favorites_no_activity"))
            .multilineTextAlignment(.center)
            .padding(50)
            .font(.title2)
        }
    }
}

struct FavoritesCategoryNil: View {
    var body: some View {
        VStack(spacing: 10) {
            HStack {
                Spacer()
                Text(LocalizedStringKey("favorites_no_activity_on_category"))
                    .font(.title)
                    .multilineTextAlignment(.center)
                  
                Spacer()
            }
            .padding(.vertical, 5)
        }
        .padding(20)
        .background(Color.blue.opacity(0.5))
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(radius: 3)
    }
}
