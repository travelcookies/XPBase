import XCTest
import XPBase

class Tests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure() {
            // Put the code you want to measure the time of here.
        }
    }
    
    // MARK: - BaseModel Tests
    
    func testBaseModelInitialization() {
        let baseModel = BaseModel<String>()
        XCTAssertNotNil(baseModel, "BaseModel should be initialized successfully")
    }
    
    func testBaseModelProperties() {
        let baseModel = BaseModel<String>()
        baseModel.code = "200"
        baseModel.errCode = "0"
        baseModel.time = 1234567890
        baseModel.msg = "Success"
        baseModel.data = "Test Data"
        
        XCTAssertEqual(baseModel.code, "200", "Code should be set correctly")
        XCTAssertEqual(baseModel.errCode, "0", "ErrCode should be set correctly")
        XCTAssertEqual(baseModel.time, 1234567890, "Time should be set correctly")
        XCTAssertEqual(baseModel.msg, "Success", "Msg should be set correctly")
        XCTAssertEqual(baseModel.data, "Test Data", "Data should be set correctly")
    }
    
    func testCodeMsgModelInitialization() {
        let codeMsgModel = CodeMsgModel()
        XCTAssertNotNil(codeMsgModel, "CodeMsgModel should be initialized successfully")
        XCTAssertEqual(codeMsgModel.code, -1, "Default code should be -1")
    }
    
    func testCodeMsgModelProperties() {
        let codeMsgModel = CodeMsgModel()
        codeMsgModel.code = 200
        codeMsgModel.msg = "Success"
        
        XCTAssertEqual(codeMsgModel.code, 200, "Code should be set correctly")
        XCTAssertEqual(codeMsgModel.msg, "Success", "Msg should be set correctly")
    }
    
    func testBaseListModelInitialization() {
        let baseListModel = BaseListModel<String>()
        XCTAssertNotNil(baseListModel, "BaseListModel should be initialized successfully")
        XCTAssertEqual(baseListModel.records, [], "Default records should be empty array")
        XCTAssertEqual(baseListModel.pages, 0, "Default pages should be 0")
        XCTAssertEqual(baseListModel.current, 0, "Default current should be 0")
        XCTAssertEqual(baseListModel.total, 0, "Default total should be 0")
        XCTAssertEqual(baseListModel.size, 0, "Default size should be 0")
    }
    
    func testBaseListModelProperties() {
        let baseListModel = BaseListModel<String>()
        baseListModel.records = ["Item1", "Item2", "Item3"]
        baseListModel.pages = 5
        baseListModel.current = 2
        baseListModel.total = 100
        baseListModel.size = 20
        
        XCTAssertEqual(baseListModel.records, ["Item1", "Item2", "Item3"], "Records should be set correctly")
        XCTAssertEqual(baseListModel.pages, 5, "Pages should be set correctly")
        XCTAssertEqual(baseListModel.current, 2, "Current should be set correctly")
        XCTAssertEqual(baseListModel.total, 100, "Total should be set correctly")
        XCTAssertEqual(baseListModel.size, 20, "Size should be set correctly")
    }
    
    // MARK: - Extensions Tests
    
    // MARK: UIColor Extensions Tests
    
    func testUIColorHexConversion() {
        // Test hex to UIColor conversion
        let color = UIColor.xp.hex("#FF0000")
        XCTAssertNotNil(color, "Hex color should be converted successfully")
        
        let colorWithAlpha = UIColor.xp.hexa("#00FF00", a: 0.5)
        XCTAssertNotNil(colorWithAlpha, "Hex color with alpha should be converted successfully")
    }
    
    func testUIColorToHexString() {
        // Test UIColor to hex string conversion
        let redColor = UIColor.red
        let hexString = redColor.xp.toHexString()
        XCTAssertEqual(hexString, "#FF0000", "Red color should be converted to #FF0000")
        
        let greenColor = UIColor.green
        let greenHexString = greenColor.xp.toHexString()
        XCTAssertEqual(greenHexString, "#00FF00", "Green color should be converted to #00FF00")
        
        let blueColor = UIColor.blue
        let blueHexString = blueColor.xp.toHexString()
        XCTAssertEqual(blueHexString, "#0000FF", "Blue color should be converted to #0000FF")
    }
    
    func testUIColorHexWithDifferentFormats() {
        // Test different hex formats
        let color1 = UIColor.xp.hex("FF0000") // Without #
        XCTAssertNotNil(color1, "Hex without # should be converted successfully")
        
        let color2 = UIColor.xp.hex("#F00") // Short format
        XCTAssertNotNil(color2, "Short hex format should be converted successfully")
    }
    
    // MARK: - XPLogger Tests
    
    func testXPLoggerInitialization() {
        let logger = XPLogger(category: "TestCategory")
        XCTAssertNotNil(logger, "XPLogger should be initialized successfully")
    }
    
    func testXPLoggerWithCustomSubsystem() {
        let customSubsystem = "com.test.custom"
        let logger = XPLogger(subsystem: customSubsystem, category: "TestCategory")
        XCTAssertNotNil(logger, "XPLogger with custom subsystem should be initialized successfully")
    }
    
    func testXPLoggerDefaultSubsystem() {
        // Test that default subsystem is set correctly
        XCTAssertNotNil(XPLogger.defaultSubsystem, "Default subsystem should not be nil")
        
        // Test custom default subsystem
        let customDefaultSubsystem = "com.test.default"
        XPLogger.defaultSubsystem = customDefaultSubsystem
        XCTAssertEqual(XPLogger.defaultSubsystem, customDefaultSubsystem, "Custom default subsystem should be set correctly")
        
        // Reset to original for other tests
        XPLogger.defaultSubsystem = Bundle.main.bundleIdentifier ?? "com.yourapp.unknown"
    }
    
    func testXPLoggerLogMethods() {
        // Test that log methods can be called without crashing
        let logger = XPLogger(category: "TestCategory")
        
        // Test different log levels
        logger.log("Debug message", level: .debug)
        logger.log("Info message", level: .info)
        logger.log("Default message", level: .default)
        logger.log("Error message", level: .error)
        logger.log("Fault message", level: .fault)
        
        // Test default log level
        logger.log("Message with default level")
        
        // If we get here without crashing, the test passes
        XCTAssertTrue(true, "All log methods should be callable without crashing")
    }
}
