//
//  TextToImageView.swift
//  CartoonApp
//
//  Created by Thanh Sau on 15/03/2024.
//

import SwiftUI

struct TextToImageView: View {
    @State var text: String = "1 girl"
    @State var loading: Bool = false
    @State var uiImage: UIImage?
    
    var body: some View {
        VStack {
            TextField("placeHolder", text: $text)
                .textFieldStyle(.roundedBorder)
                .padding(.horizontal)
            
            Button {
                guard !text.isEmpty else { return }
                loading = true
                let txtToImg = TextToImageModel(prompt: text)
                Api.shared.textToImage(for: txtToImg) { response in
                    loading = false
                    if let response {
                        if let uiImage = imageFromBase64(base64String: response.images.first ?? "") {
                            DispatchQueue.main.async {
                                self.uiImage = uiImage
                            }
                        }
                    }
                }
            } label: {
                Text("Text to image")
                    .padding()
                    .background(.gray)
                    .cornerRadius(12)
                    .foregroundColor(.white)
            }
            
            if let uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            } else if loading {
                ProgressView("Loadinggggg")
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TextToImageView()
}
