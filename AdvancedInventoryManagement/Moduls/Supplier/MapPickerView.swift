import SwiftUI
import MapKit

struct MapPickerView: View {
    @Binding var latitude: Double
    @Binding var longitude: Double
    @State private var region: MKCoordinateRegion

    init(latitude: Binding<Double>, longitude: Binding<Double>) {
        self._latitude = latitude
        self._longitude = longitude
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: latitude.wrappedValue, longitude: longitude.wrappedValue),
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        ))
    }

    var body: some View {
        VStack {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: true)
                .edgesIgnoringSafeArea(.all)
                .onChange(of: region.center) { newCenter in
                    latitude = newCenter.latitude
                    longitude = newCenter.longitude
                }

            Text("Selected Location: \(latitude), \(longitude)")
                .padding()
                .background(Color.white.opacity(0.8))
                .cornerRadius(10)
                .shadow(radius: 5)

            Button("Confirm Location") {
                // Action to confirm the location
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding()
        }
    }
}