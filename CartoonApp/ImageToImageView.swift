//
//  ImageToImageView.swift
//  CartoonApp
//
//  Created by Thanh Sau on 15/03/2024.
//

import SwiftUI
import AlertToast

struct ImageToImageView: View {
    
    @State private var image: Image?
    @State private var isShowingImagePicker = false
    @State private var selectedImage: UIImage?
    @State var loading: Bool = false
    @State var imageBase64: String = ""
    @State var alertSaveSuccess: Bool = false
    @State var maxSize: CGFloat = 512
    
    var body: some View {
        VStack {
            VStack {
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                } else if loading {
                    ProgressView("Loadingggg")
                }
                
                if let image {
                    Text("\(maxSize)")
                    Slider(value: $maxSize, in: 128...2048) {
                        Text("Size Scale")
                    } minimumValueLabel: {
                        Text("128")
                    } maximumValueLabel: {
                        Text("2048")
                    }
                    
                    Button {
                        guard let selectedImage else { return }
                        loading = true
                        self.image = nil
                        let size = resizeCGSize(selectedImage.size, maxSize: maxSize)
                        print(size)
                        let model = ImageToImageModel(prompt: lora, width: Int(size.width), height: Int(size.height), initImages: [imageBase64])
                        Api.shared.imageToImage(for: model) { response in
                            loading = false
                            if let response {
                                if let uiImage = imageFromBase64(base64String: response.images.first ?? "") {
                                    DispatchQueue.main.async {
                                        self.selectedImage = uiImage
                                        self.image = Image(uiImage: uiImage)
                                    }
                                }
                            }
                        }
                    } label: {
                        Text("Image to image")
                            .padding()
                            .background(.gray)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }
                    
                    Button {
                        if let selectedImage {
                            CustomPhotoAlbum.save(image: .normal(selectedImage)) { error in
                                if let error {
                                    print("error")
                                } else {
                                    alertSaveSuccess = true
                                }
                            }
                        }
                        
                    } label: {
                        Text("Save")
                            .padding()
                            .background(.gray)
                            .cornerRadius(12)
                            .foregroundColor(.white)
                    }

                }
            }
            
            Button("Select Image") {
                self.isShowingImagePicker = true
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(selectedImage: self.$selectedImage, isPresented: self.$isShowingImagePicker)
        }
        .onChange(of: selectedImage) { _,_ in
            loadImage()
        }
        .toast(isPresenting: $alertSaveSuccess) {
            AlertToast(displayMode: .alert, type: .complete(.green))
        }
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
        
        // Convert the UIImage to Data
        if let imageData = selectedImage.jpegData(compressionQuality: 1.0) {
            // Convert Data to base64 string
            let base64String = imageData.base64EncodedString()
            self.imageBase64 = base64String
        }
    }
    
    func resizeCGSize(_ size: CGSize, maxSize: CGFloat) -> CGSize {
        let widthRatio = maxSize / size.width
        let heightRatio = maxSize / size.height
        var newSize: CGSize

        if widthRatio < heightRatio {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        } else {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        }

        return newSize
    }
}

#Preview {
    ImageToImageView()
}
