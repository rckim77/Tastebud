//
//  ProcedureModel.swift
//  sousChef
//
//  Created by Raymond Kim on 10/8/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import Foundation

class ProcedureModel {
    var recipeTitle: String
    var steps: [ProcedureStepModel]
    
    // TODO: init with title and steps
    init() {
        self.recipeTitle = "Char Siu Pork"
        
        let step1 = ProcedureStepModel(type: .headerPic, header: "1. Heat sous vide to 140F (or 60C) in a container of water.", image: #imageLiteral(resourceName: "charsiuporksousvide"))
        let step2 = ProcedureStepModel(type: .headerSub, header: "2. Slice pork into steaks", subheader: "Slice pork shoulder into steaks about 1.5\" (38mm) thick.")
        let step3 = ProcedureStepModel(type: .headerSubPic, header: "3. Season pork", subheader: "Season pork with salt and let rest, allowing salt to dissolve into meat for 20 to 30 minutes.", image: #imageLiteral(resourceName: "charsiuporksalt"))
        let step4 = ProcedureStepModel(type: .headerSubPic, header: "4. Bag it up", subheader: "Fill sous vide bag with sauce, then add meat. You can cook meat right away or store in the fridge for up to 24 hours.", image: #imageLiteral(resourceName: "charsiuporkbag"))
        let step5 = ProcedureStepModel(type: .headerSubPic, header: "5. Cook for 8 hours", subheader: "Lower the bag into the cooking water and cook for 8 hours.", image: #imageLiteral(resourceName: "charsiuporkbag2"))
        let step6 = ProcedureStepModel(type: .headerSubPic, header: "6. Finish", subheader: "Sear steaks on each side until they reach a deep mahogany color. Remove right away.", image: #imageLiteral(resourceName: "charsiuporkfinish"))
        let step7 = ProcedureStepModel(type: .headerSubPic, header: "7. Serve", subheader: "Serve your pork right away–we like to offer it alongside dipping bowls of mustard, green onions, and sesame seeds.", image: #imageLiteral(resourceName: "charsiupork"))
        
        self.steps = [step1, step2, step3, step4, step5, step6, step7]
    }
}
