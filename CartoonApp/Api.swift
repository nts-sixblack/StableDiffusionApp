//
//  Api.swift
//  CartoonApp
//
//  Created by Thanh Sau on 15/03/2024.
//
import SwiftUI
import Alamofire
import Foundation

let host = "http://127.0.0.1:7860/sdapi/v1/"
//let host = "http://103.20.97.111:116/sdapi/v1/"

let lora: String = "<lora:gakuen_anime:1>"
let negativePromt: String = "easynegative, bad-image-v2-39000, bad_quality, vile_prompt3, bad-hands-5, (mature, fat:1.1), gloves, fat, paintings, sketches, (worst quality:2), (low quality:2), (normal quality:2), lowres, bad anatomy, text, error, cropped, worst quality, low quality, normal quality, jpeg artifacts, signature, watermark, username, blurry, bad feet, poorly drawn face, bad proportions, gross proportions, pubic hair, normal quality, ((monochrome)), ((grayscale)), (((bad_nipples))), (((bad_pussy))), artifacts, skin artifacts, (((crossed_eyes)))"

class Api {
    static var shared: Api = .init()
    
    private var alamofireSessionManager: Session
    
    private init() {
        let timeoutInterval: TimeInterval = 60*60*12
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutInterval

        alamofireSessionManager = Alamofire.Session(configuration: configuration)
    }
    
    func textToImage(for model: TextToImageModel, onComplete: @escaping (ImageResponse?) -> Void) {
        alamofireSessionManager.request(host + "txt2img", method: .post, parameters: model, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(_):
                
                guard let res = response.response else { onComplete(nil); return }
                
                if res.statusCode == 200 {
                    let data = response.data
                    
                    do {
                        let model = try JSONDecoder().decode(ImageResponse.self, from: data!)
                        
                        onComplete(model)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("statusCode: \(res.statusCode)")
                    onComplete(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
    
    func imageToImage(for model: ImageToImageModel, onComplete: @escaping (ImageResponse?) -> Void) {
        alamofireSessionManager.request(host + "img2img", method: .post, parameters: model, encoder: JSONParameterEncoder.default).response { response in
            switch response.result {
            case .success(_):
                
                guard let res = response.response else { onComplete(nil); return }
                
                if res.statusCode == 200 {
                    let data = response.data
                    
                    do {
                        let model = try JSONDecoder().decode(ImageResponse.self, from: data!)
                        
                        onComplete(model)
                    } catch {
                        print(error.localizedDescription)
                        onComplete(nil)
                    }
                } else {
                    print("statusCode: \(res.statusCode)")
                    onComplete(nil)
                }
            case .failure(let error):
                print(error.localizedDescription)
                onComplete(nil)
            }
        }
    }
}

func imageFromBase64(base64String: String) -> UIImage? {
    // Convert Base64 string to Data
    guard let imageData = Data(base64Encoded: base64String) else {
        return nil
    }
    
    // Convert Data to UIImage
    guard let image = UIImage(data: imageData) else {
        return nil
    }
    
    return image
}
