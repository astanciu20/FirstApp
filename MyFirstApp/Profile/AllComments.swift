import SwiftUI

struct AllComments: View {
    @ObservedObject var commentsStore: ActivityDetailStore
    
    var body: some View {
        VStack(alignment: .trailing) {
            List {
                commentsList
            }
        }
    }
    
    @ViewBuilder private var commentsList: some View {
        ForEach(commentsStore.allComments.reversed(), id: \.id) { commentInAllComments in
            NavigationLink(destination: ActivityDetailsView(activity: commentInAllComments.activity, commentsStore: commentsStore)) {
                CommentCard(activityInStore: commentInAllComments)
            }
            .padding(.vertical, 5)
        }
    }
}
