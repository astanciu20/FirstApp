import SwiftUI

struct ProfileCard: View {
    let profile: ProfileStruct
    @State var dailyReminderTime = Date(timeIntervalSince1970: 0)
    
    var body: some View {
        VStack {
            VStack {
                Image(systemName: "person.crop.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 120, height: 120)
                Text(profile.name)
                    .font(.largeTitle)
                    .foregroundColor(.black)
                    .bold()
                HStack{
                    Text(LocalizedStringKey("profile_role"))
                        .foregroundColor(.gray)
                    Text(profile.role)
                }
                .font(.title2)
            }
            .padding(.top, 30)
            Spacer()
            List{
                VStack{
                    Section{
                        HStack{
                            Text(LocalizedStringKey("profile_gender"))
                            Spacer()
                            Text(profile.gender)
                        }
                    }
                }
                VStack{
                    Section{
                        HStack{
                            Text(LocalizedStringKey("profile_date_of_birth"))
                            Spacer()
                            Text(formatDate(profile.dateOfBirth))
                        }
                    }
                }
                VStack{
                    Section{
                        HStack{
                            Text(LocalizedStringKey("profile_email"))
                            Spacer()
                            Text(profile.email)
                        }
                    }
                }
            }
            Spacer()
        }
    }
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct ProfileView: View {
    @ObservedObject var profileStore: ProfileStore

    var body: some View {
        VStack {
            if let person = profileStore.profile {
                ProfileCard(profile: person)
            } else {
                Text("No profile found")
            }
        }

    }
}
