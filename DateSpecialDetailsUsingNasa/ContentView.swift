//
//  ContentView.swift
//  DateSpecialDetailsUsingNasa
//
//  Created by Onkar Verule on 14/10/23.
//

import SwiftUI

struct ContentView: View {

    @State var selectedDate = Date()
    @StateObject var viewModel = ViewModel()
    @State var status: ResponseStatus = .Failure
    @State var showSheet = false

    private var dateProxy:Binding<Date> {
        Binding<Date>(get: {self.selectedDate }, set: {
            self.selectedDate = $0
            self.showSheet = false
            let formattedDate = self.viewModel.getDateByFormatting(date: selectedDate)
            self.viewModel.fetchDataForDate(startDate: formattedDate, endDate: formattedDate, completion: { status in
                self.status = status
            })
        })
     }

    var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea()

            VStack {
                Spacer()
                Text(viewModel.dateText)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Spacer(minLength: 4)
                Text(viewModel.titleText)
                    .font(.largeTitle)
                    .foregroundStyle(.white)
                Spacer()
                Image(uiImage: viewModel.image)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(40)
                    .padding()
                Spacer()
                ScrollView(showsIndicators: false, content: {
                    Text(viewModel.descriptionText)
                        .foregroundStyle(.white)
                })
                .padding()
                Spacer()
                buttonView
            }
            .padding()

        }
    }

    var backgroundView: some View {
        let colors = [Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)), Color(#colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)) ,Color(#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))]
        return AngularGradient(colors: colors,
                               center: .topLeading,
                               angle: Angle(degrees: 180))
    }

    var buttonView: some View {
        Button(action: {
            self.showSheet.toggle()
        }, label: {
            Text("Select Date")
                .font(.title2)
                .foregroundStyle(Color.black)
        })
        .padding()
        .background {
            Color.white
        }
        .cornerRadius(30)
        .shadow(radius: 10)
        .sheet(isPresented: $showSheet, content: {
            DatePicker(selection: dateProxy, displayedComponents: [.date]) {
                Text("Test")
            }
            .datePickerStyle(GraphicalDatePickerStyle())
        })
    }
}

#Preview {
    ContentView()
}
