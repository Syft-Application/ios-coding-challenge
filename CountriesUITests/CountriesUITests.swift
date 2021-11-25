//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Syft on 03/03/2020.
//  Copyright © 2020 Syft. All rights reserved.
//

import XCTest

class CountriesUITests: XCTestCase {

    let kTimeOut = 10.0
    let app = XCUIApplication()
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        XCUIApplication().launchArguments += ["-AppleLocale", "en_GB"]
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPopulationFormat() {
        
        // The purpose of this test is to check that the population is formatted with comma separators.
        // It assumes a UK locale, and:
        //   1,000,000 <= Afghan population <= 999,999,999.
        //   1,000,000,000 <= China population <= 999,999,999,999
        //   1,000 <= Antarctica population <= 9,999
        
        let afghanPopulation = app.staticTexts["Afghanistan-Population"]
        XCTAssertTrue(afghanPopulation.waitForExistence(timeout: kTimeOut))
        var commas = afghanPopulation.label.filter({return $0 == ","}).count
        XCTAssertEqual(2, commas)
        
        let chinaPopulation = app.staticTexts["China-Population"]
        XCTAssertTrue(afghanPopulation.waitForExistence(timeout: kTimeOut))
        commas = chinaPopulation.label.filter({return $0 == ","}).count
        XCTAssertEqual(3, commas)
        
        let antarcticaPopulation = app.staticTexts["Antarctica-Population"]
        XCTAssertTrue(antarcticaPopulation.waitForExistence(timeout: kTimeOut))
        commas = antarcticaPopulation.label.filter({return $0 == ","}).count
        XCTAssertEqual(1, commas)
    }

    func testCapitals() {
        
        // The purpose of this test is to check cpital cities are correct,
        // and that we don't try and display non-existent capitals, such as for Antarctica.
        
        let algeriaCapital = app.staticTexts["Algeria-Capital"]
        XCTAssertTrue(algeriaCapital.waitForExistence(timeout: kTimeOut))
        XCTAssertEqual("Algiers", algeriaCapital.label)
        
        let andorraCapital = app.staticTexts["Andorra-Capital"]
        XCTAssertTrue(andorraCapital.waitForExistence(timeout: kTimeOut))
        XCTAssertEqual("Andorra la Vella", andorraCapital.label)

        let antarcticaCapital = app.staticTexts["Antarctica-Capital-Label"]
        XCTAssertFalse(antarcticaCapital.waitForExistence(timeout: kTimeOut))
    }
    
}
