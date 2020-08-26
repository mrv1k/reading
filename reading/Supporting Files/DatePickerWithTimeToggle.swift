import SwiftUI

struct DatePickerWithTimeToggle: View {
    @Binding var selection: Date
    @State private var dateTimeToggle = false

    var displayedComponents: DatePickerComponents {
        var components: DatePickerComponents = .date
        if dateTimeToggle {
            components.insert(.hourAndMinute)
        }
        return components
    }
    
    var body: some View {
        Group {
            DatePicker(
                "Record on",
                selection: $selection,
                displayedComponents: displayedComponents)
            Toggle("Include time", isOn: $dateTimeToggle)
        }
    }
}

struct DatePickerWithTimeToggle_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DatePickerWithTimeToggle(selection: .constant(Date()))
        }.previewLayout(.sizeThatFits)
    }
}
