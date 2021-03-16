import SwiftUI

struct ConfirmView: View {
    var menuID: Int
    @ObservedObject var orderModel: OrderModel
    @Binding var isPresented: Bool
    @Binding var quantity: Int
    @Binding var size: Size

    @State var comment: String = ""

    var name: String {
        orderModel.menu(menuID)?.name ?? ""
    }
    
    func addItem() {
        orderModel.add(menuID: menuID, size: size, quantity: quantity)
        isPresented = false
    }
    
    var body: some View {
        VStack{
            Text("Confirm Order")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.leading)

            Divider()

            SelectedImageView(name: "\(menuID)_250w")
                .padding(10)
                // .onTapGesture(count: 2) {
                //     isPresented = false
                // }
                .gesture(
                    TapGesture(count: 2)
                        .onEnded {
                            isPresented = false
                        }
                )

            Divider()

            Text("Confirm your order of \(quantity) \(size.formatted()) \(name) pizza")
                .font(.headline)

            TextField("Add you comments here", text: $comment)
                .background(Color.white)
                .foregroundColor(.black)

            Spacer()

            HStack {
                Button(action: addItem){
                    Text("Add")
                        .font(.title)
                        .padding()
                        .background(Color("G4"))
                        .cornerRadius(10)
                }
                .padding([.bottom])

                Spacer()

                Button {
                    isPresented = false
                } label: {
                    Text("Cancel")
                        .font(.title)
                        .padding()
                        .background(Color("G4"))
                        .cornerRadius(10)
                }
                .padding([.bottom])
            }
            .padding()
        }
        .background(Color("G3"))
        .foregroundColor(Color("IP"))
        .cornerRadius(20)
    }
}

struct ConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ConfirmView(menuID: 1, orderModel: OrderModel(), isPresented: .constant(true), quantity: .constant(6), size: .constant(.medium), comment: "foo bar")
    }
}
