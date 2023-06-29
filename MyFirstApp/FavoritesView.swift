import SwiftUI

struct FavoritesView: View {
    @StateObject var activityStore: ActivityStore
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(activityStore.activitati.filter { $0.status }, id: \.titlu) { activity in
                    ActivityCard(activity: activity, color: .blue)
                }
                .padding(5)
            }
        }
        .padding(.horizontal, 10)
    }
}
