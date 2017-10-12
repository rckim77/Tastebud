//
//  ProcedureStepModel.swift
//  Tastebud
//
//  Created by Raymond Kim on 10/8/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import Foundation

enum ProcedureStepType {
    case header
    case headerPic
    case headerSub
    case headerSubPic
    case headerSubVid
}

class ProcedureStepModel {
    var type: ProcedureStepType
    var header: String
    var subheader: String?
    var image: UIImage?
    var videoURL: String?
    
    init(type: ProcedureStepType, header: String, subheader: String? = nil, image: UIImage? = nil, videoURL: String? = nil) {
        self.type = type
        self.header = header
        self.subheader = subheader
        self.image = image
        self.videoURL = videoURL
    }
}
