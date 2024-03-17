//
//  TextToImageResponse.swift
//  CartoonApp
//
//  Created by Thanh Sau on 15/03/2024.
//

import Foundation

struct ImageResponse: Codable {

    let images: [String]
    let parameters: Parameters

    private enum CodingKeys: String, CodingKey {
        case images = "images"
        case parameters = "parameters"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        images = try values.decode([String].self, forKey: .images)
        parameters = try values.decode(Parameters.self, forKey: .parameters)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(images, forKey: .images)
        try container.encode(parameters, forKey: .parameters)
    }

}

struct Parameters: Codable {

    let prompt: String
    let negativePrompt: String

    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case negativePrompt = "negative_prompt"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try values.decode(String.self, forKey: .prompt)
        negativePrompt = try values.decode(String.self, forKey: .negativePrompt)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(negativePrompt, forKey: .negativePrompt)
    }

}
