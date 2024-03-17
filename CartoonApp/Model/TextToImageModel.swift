//
//  TextToImageModel.swift
//  CartoonApp
//
//  Created by Thanh Sau on 15/03/2024.
//

import Foundation

class TextToImageModel: Codable {

    let prompt: String
    let negativePrompt: String
    let seed: Int
    let samplerName: String
    let batchSize: Int
    let steps: Int
    let cfgScale: Double
    let width: Int
    let height: Int
    let doNotSaveSamples: Bool
    let doNotSaveGrid: Bool

    init(
        prompt: String,
        negativePrompt: String = negativePromt,
        seed: Int = -1,
        samplerName: String = "DPM++ 2M Karras",
        batchSize: Int = 1,
        steps: Int = 20,
        cfgScale: Double = 0.7,
        width: Int = 512,
        height: Int = 512,
        doNotSaveSamples: Bool = true,
        doNotSaveGrid: Bool = true
    ) {
        self.prompt = prompt
        self.negativePrompt = negativePrompt
        self.seed = seed
        self.samplerName = samplerName
        self.batchSize = batchSize
        self.steps = steps
        self.cfgScale = cfgScale
        self.width = width
        self.height = height
        self.doNotSaveSamples = doNotSaveSamples
        self.doNotSaveGrid = doNotSaveGrid
    }
    
    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case negativePrompt = "negative_prompt"
        case seed = "seed"
        case samplerName = "sampler_name"
        case batchSize = "batch_size"
        case steps = "steps"
        case cfgScale = "cfg_scale"
        case width = "width"
        case height = "height"
        case doNotSaveSamples = "do_not_save_samples"
        case doNotSaveGrid = "do_not_save_grid"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try values.decode(String.self, forKey: .prompt)
        negativePrompt = try values.decode(String.self, forKey: .negativePrompt)
        seed = try values.decode(Int.self, forKey: .seed)
        samplerName = try values.decode(String.self, forKey: .samplerName)
        batchSize = try values.decode(Int.self, forKey: .batchSize)
        steps = try values.decode(Int.self, forKey: .steps)
        cfgScale = try values.decode(Double.self, forKey: .cfgScale)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        doNotSaveSamples = try values.decode(Bool.self, forKey: .doNotSaveSamples)
        doNotSaveGrid = try values.decode(Bool.self, forKey: .doNotSaveGrid)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(negativePrompt, forKey: .negativePrompt)
        try container.encode(seed, forKey: .seed)
        try container.encode(samplerName, forKey: .samplerName)
        try container.encode(batchSize, forKey: .batchSize)
        try container.encode(steps, forKey: .steps)
        try container.encode(cfgScale, forKey: .cfgScale)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(doNotSaveSamples, forKey: .doNotSaveSamples)
        try container.encode(doNotSaveGrid, forKey: .doNotSaveGrid)
    }

}
