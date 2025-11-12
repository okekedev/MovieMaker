import SwiftUI
import AuthenticationServices

struct AppConfigurationView: View {
    @Binding var isPresented: Bool



    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isPresented = false
                }

            VStack(spacing: 0) {
                HStack {
                    Text("App Settings")
                        .font(.title2.bold())
                    Spacer()
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {



                    }
                    .padding()
                }
            }
            .background(Color(.systemBackground))
            .cornerRadius(20)
            .shadow(radius: 20)
            .padding(30)
        }
    }


}

struct AppConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        AppConfigurationView(isPresented: .constant(true))
    }
}
