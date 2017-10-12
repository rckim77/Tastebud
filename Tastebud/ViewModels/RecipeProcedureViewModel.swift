//
//  RecipeProcedureViewModel.swift
//  Tastebud
//
//  Created by Raymond Kim on 10/8/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import UIKit

protocol RecipeProcedureViewModel {
    var procedure: ProcedureModel { get }
}

class RecipeProcedureViewModelWithProcedure: NSObject, RecipeProcedureViewModel {
    var procedure: ProcedureModel
    
    init(_ procedure: ProcedureModel) {
        self.procedure = procedure
    }
}
