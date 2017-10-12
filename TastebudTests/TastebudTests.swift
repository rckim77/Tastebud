//
//  TastebudTests.swift
//  TastebudTests
//
//  Created by Raymond Kim on 9/22/17.
//  Copyright © 2017 Raymond Kim. All rights reserved.
//

import XCTest
@testable import Tastebud

class TastebudTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testRecipeOverviewViewModelWithCharSiuRecipes() {
        let charSiuRecipeModel = RecipeModel(imageURL: "", title: "Char Siu Pork")
        let charSiuRecipeViewModel = RecipeOverviewViewModelWithRecipes([charSiuRecipeModel])
        
        XCTAssertEqual(charSiuRecipeViewModel.recipes[0].imageURL, "")
        XCTAssertEqual(charSiuRecipeViewModel.recipes[0].title, "Char Siu Pork")
        
    }
    
}
