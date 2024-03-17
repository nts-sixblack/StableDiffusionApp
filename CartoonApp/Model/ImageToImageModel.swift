//
//  ImageToImageModel.swift
//  CartoonApp
//
//  Created by Thanh Sau on 15/03/2024.
//

import Foundation

struct ImageToImageModel: Codable {
    
    let prompt: String
    let negativePrompt: String
    let seed: Int
    let batchSize: Int
    let steps: Int
    let cfgScale: Double
    let width: Int
    let height: Int
    let doNotSaveSamples: Bool
    let doNotSaveGrid: Bool
    let denoisingStrength: Double
    let initImages: [String]
    let mask: String?
    let samplerIndex: String
    let sendImages: Bool
    let saveImages: Bool
    
    private enum CodingKeys: String, CodingKey {
        case prompt = "prompt"
        case negativePrompt = "negative_prompt"
        case seed = "seed"
        case batchSize = "batch_size"
        case steps = "steps"
        case cfgScale = "cfg_scale"
        case width = "width"
        case height = "height"
        case doNotSaveSamples = "do_not_save_samples"
        case doNotSaveGrid = "do_not_save_grid"
        case denoisingStrength = "denoising_strength"
        case initImages = "init_images"
        case mask = "mask"
        case samplerIndex = "sampler_index"
        case sendImages = "send_images"
        case saveImages = "save_images"
    }
    
    init(
        prompt: String = lora,
        negativePrompt: String = negativePromt,
        seed: Int = -1,
        batchSize: Int = 1,
        steps: Int = 20,
        cfgScale: Double = 6.5,
        width: Int = 512,
        height: Int = 512,
        doNotSaveSamples: Bool = true,
        doNotSaveGrid: Bool = true,
        denoisingStrength: Double = 0.7,
        initImages: [String], /// array image, start with "data:image/"
        mask: String? = nil,
        samplerIndex: String = "DPM++ 2M Karras",
        sendImages: Bool = true,
        saveImages: Bool = false
    ) {
        self.prompt = prompt
        self.negativePrompt = negativePrompt
        self.seed = seed
        self.batchSize = batchSize
        self.steps = steps
        self.cfgScale = cfgScale
        self.width = width
        self.height = height
        self.doNotSaveSamples = doNotSaveSamples
        self.doNotSaveGrid = doNotSaveGrid
        self.denoisingStrength = denoisingStrength
        self.initImages = initImages
        self.mask = mask
        self.samplerIndex = samplerIndex
        self.sendImages = sendImages
        self.saveImages = saveImages
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        prompt = try values.decode(String.self, forKey: .prompt)
        negativePrompt = try values.decode(String.self, forKey: .negativePrompt)
        seed = try values.decode(Int.self, forKey: .seed)
        batchSize = try values.decode(Int.self, forKey: .batchSize)
        steps = try values.decode(Int.self, forKey: .steps)
        cfgScale = try values.decode(Double.self, forKey: .cfgScale)
        width = try values.decode(Int.self, forKey: .width)
        height = try values.decode(Int.self, forKey: .height)
        doNotSaveSamples = try values.decode(Bool.self, forKey: .doNotSaveSamples)
        doNotSaveGrid = try values.decode(Bool.self, forKey: .doNotSaveGrid)
        denoisingStrength = try values.decode(Double.self, forKey: .denoisingStrength)
        initImages = try values.decode([String].self, forKey: .initImages)
        mask = try values.decodeIfPresent(String.self, forKey: .mask)
        samplerIndex = try values.decode(String.self, forKey: .samplerIndex)
        sendImages = try values.decode(Bool.self, forKey: .sendImages)
        saveImages = try values.decode(Bool.self, forKey: .saveImages)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(prompt, forKey: .prompt)
        try container.encode(negativePrompt, forKey: .negativePrompt)
        try container.encode(seed, forKey: .seed)
        try container.encode(batchSize, forKey: .batchSize)
        try container.encode(steps, forKey: .steps)
        try container.encode(cfgScale, forKey: .cfgScale)
        try container.encode(width, forKey: .width)
        try container.encode(height, forKey: .height)
        try container.encode(doNotSaveSamples, forKey: .doNotSaveSamples)
        try container.encode(doNotSaveGrid, forKey: .doNotSaveGrid)
        try container.encode(denoisingStrength, forKey: .denoisingStrength)
        try container.encode(initImages, forKey: .initImages)
        try container.encodeIfPresent(mask, forKey: .mask)
        try container.encode(samplerIndex, forKey: .samplerIndex)
        try container.encode(sendImages, forKey: .sendImages)
        try container.encode(saveImages, forKey: .saveImages)
    }
}
