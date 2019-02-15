
import XCTest

class HuafengUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["2015 Winter"]/*[[".cells.staticTexts[\"2015 Winter\"]",".staticTexts[\"2015 Winter\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["2015 Winter"].buttons["Magazines"].tap()
        
        let staticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["2015 Spring"]/*[[".cells.staticTexts[\"2015 Spring\"]",".staticTexts[\"2015 Spring\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        staticText.tap()
        
        let navigationBar = app.navigationBars["2015 Spring"]
        navigationBar.buttons["Bookmarks"].tap()
        app.navigationBars["Add to Shelf"].buttons["Add"].tap()
        app.navigationBars["Add Category"].buttons["Save"].tap()
        
        let newShelfStaticText = tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["New Shelf"]/*[[".cells.staticTexts[\"New Shelf\"]",".staticTexts[\"New Shelf\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        newShelfStaticText.tap()
        navigationBar.buttons["Magazines"].tap()
        
        let tabBarsQuery = app.tabBars
        let shelfButton = tabBarsQuery.buttons["Shelf"]
        shelfButton.tap()
        newShelfStaticText.tap()
        staticText.tap()
        navigationBar.buttons["Back"].tap()
        tabBarsQuery.buttons["Writers"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Benhao Li"]/*[[".cells.staticTexts[\"Benhao Li\"]",".staticTexts[\"Benhao Li\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["2015 Fall"]/*[[".cells.staticTexts[\"2015 Fall\"]",".staticTexts[\"2015 Fall\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["2015 Fall"].buttons["Back"].tap()
        shelfButton.tap()
        
        let huafengShelfmagazinelistviewNavigationBar = app.navigationBars["HuaFeng.ShelfMagazineListView"]
        huafengShelfmagazinelistviewNavigationBar.buttons["Edit"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete 2015 Spring, Vol.6 Issue 3"]/*[[".cells.buttons[\"Delete 2015 Spring, Vol.6 Issue 3\"]",".buttons[\"Delete 2015 Spring, Vol.6 Issue 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.buttons["Delete"].tap()
        huafengShelfmagazinelistviewNavigationBar.buttons["Shelf"].tap()
        
        let shelfNavigationBar = app.navigationBars["Shelf"]
        shelfNavigationBar.buttons["Edit"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.buttons["Delete New Shelf"]/*[[".cells.buttons[\"Delete New Shelf\"]",".buttons[\"Delete New Shelf\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        tablesQuery.buttons["Remove"].tap()
        shelfNavigationBar.buttons["Done"].tap()
        tabBarsQuery.buttons["Info"].tap()
        
    }
    
}
