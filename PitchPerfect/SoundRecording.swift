//
//  SoundRecording.swift
//  PitchPerfect
//
//  Created by Michael Main on 2/17/16.
//  Copyright © 2016 Michael Main. All rights reserved.
//

import Foundation

class SoundRecording {
    var filePath:NSURL!
    var title:String!
    
    init(filePath : NSURL!, title : String!) {
        self.filePath = filePath
        self.title = title
    }
}