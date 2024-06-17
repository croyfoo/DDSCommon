// New View

import SwiftUI

struct PodcastScrollView: View {
    var content: [Podcast]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(content, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .foregroundColor(Color.blue)
                        .frame(width: 120, height: 120)
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct Podcast: Hashable {
    
}

struct HomeView: View {
    
    let featuredPodcasts: [Podcast]
    let popularPodcasts: [Podcast]
    let yourPodcasts: [Podcast]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                Text("Welcome to SwiftUI")
                    .font(.subheadline)
                    .bold()
                    .padding()
                PodcastScrollView(content: featuredPodcasts)
                PodcastScrollView(content: popularPodcasts)
                PodcastScrollView(content: yourPodcasts)
                Spacer()
            }
//            .navigationBarTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {

    static var previews: some View {
        HomeView(featuredPodcasts: [Podcast](), popularPodcasts: [Podcast](), yourPodcasts: [Podcast]())
    }
}
