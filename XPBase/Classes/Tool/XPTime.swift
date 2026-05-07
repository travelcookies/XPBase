import Foundation

/// 时间工具类（XP命名空间版本）
/// 提供日期格式化、时间戳转换、日期比较等常用时间操作功能
///
/// 使用示例：
/// ```swift
/// // 获取最近N天的日期列表（格式：MM-dd）
/// let recentDays = XPTime.returnNearByMonth(count: 7)
/// 
/// // 获取最近N个月的日期列表（格式：yyyy-MM）
/// let recentMonths = XPTime.returnNearByYear(count: 12)
/// 
/// // 获取当前年份
/// let year = XPTime.returnYear()
/// 
/// // 时间戳转日期字符串
/// let dateStr = XPTime.dateTimeYYYYMMDD(time: 1620000000)
/// 
/// // 日期字符串转时间戳
/// let timestamp = XPTime.dateTimeYYYYMMDD(string: "2021-05-03 10:30:00")
/// 
/// // 获取当前日期组件
/// let currentYear = XPTime.currentYear()
/// let currentMonth = XPTime.currentMonth()
/// let currentDay = XPTime.currentDay()
/// 
/// // 获取当前日期字符串
/// let today = XPTime.currentDate() // "2021-05-03"
/// let todayMM = XPTime.currentDateMM() // "2021-05"
/// 
/// // 获取时间戳
/// let stamp = XPTime.getStamp()
/// 
/// // 日期转字符串
/// let formattedDate = XPTime.dateToDateString(Date(), dateFormat: "yyyy-MM-dd HH:mm:ss")
/// 
/// // 计算两个日期相差天数
/// let daysDiff = XPTime.dateDifference(dateA, from: dateB)
/// 
/// // 比较两个日期
/// let compareResult = XPTime.compareOneDay(oneDay: dateA, withAnotherDay: dateB)
/// 
/// // 时间戳转详细日期字符串
/// let detailStr = XPTime.timeStampToStringDetail("1620000000")
/// 
/// // 格式化相对时间（如：5分钟前、3小时前）
/// let relativeTime = XPTime.compareCurrentTime(str: "2021-05-03 08:00:00")
/// ```
public struct XPTime {
    public static func returnNearByMonth(count: Int) -> [String] {
        let time = Date().timeIntervalSince1970
        var arr = [String]()
        
        for i in 0 ..< count {
            let timeNow = time - TimeInterval(i * 3600 * 24)
            let date = Date(timeIntervalSince1970: timeNow)
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd"
            let str = dateFormatter.string(from: date)
            arr.append(str)
        }
        
        return arr.reversed()
    }
    
    public static func returnNearByYear(count: Int) -> [String] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let str = dateFormatter.string(from: Date())
        var month = Int(str)!
        var year = Int(returnYear())!
        var arr = [String]()
        for _ in 0 ..< count {
            if month == 0 {
                month = 12
                year -= 1
            }
            arr.append("\(year)-\(String(format: "%02d", month))")
            month -= 1
        }
        
        return arr
    }
    
    public static func returnYear() -> String {
        let date = Date()
        let calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute]
        let comp = (calendar as NSCalendar).components(unitFlags, from: date)
        let year = String(format: "%d", comp.year!)
        return "\(year)"
    }
    
    public static func dateTimeYYYYMMDD(time: Int64, formatString: String? = "yyyy.MM.dd") -> String {
        let format = DateFormatter()
        format.dateFormat = formatString
        let date = Date(timeIntervalSince1970: TimeInterval(time))
        return format.string(from: date)
    }
    
    public static func dateTimeYYYYMMDD(string: String, formatString: String? = "yyyy-MM-dd HH:mm:ss") -> TimeInterval {
        let format = DateFormatter()
        format.dateFormat = formatString
        format.locale = Locale(identifier: "zh_CN")
        let willDate = format.date(from: string)!
        return willDate.timeIntervalSince1970
    }
    
    public static func returnMonthDayHourMinute(timeStr: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "zh_CN")
        
        let date = dateFormatter.date(from: timeStr)
        let calendar = Calendar.current
        let unitFlags: NSCalendar.Unit = [.year, .month, .day, .hour, .minute]
        let comp = (calendar as NSCalendar).components(unitFlags, from: date!)
        let month = String(format: "%02d", comp.month!)
        let day = String(format: "%02d", comp.day!)
        let hour = String(format: "%02d", comp.hour!)
        let minute = String(format: "%02d", comp.minute!)
        return "\(month)月\(day)日\(hour):\(minute)"
    }
    
    public static func currentYear() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return com.year!
    }
    
    public static func currentMonth() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return com.month!
    }
    
    public static func currentDay() -> Int {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return com.day!
    }
    
    public static func currentDateMM() -> String {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return String(format: "%d-%02d", com.year!, com.month!)
    }
    
    public static func currentDate() -> String {
        let calendar = NSCalendar.current
        let com = calendar.dateComponents([.year, .month, .day], from: Date())
        return String(format: "%d-%02d-%02d", com.year!, com.month!, com.day!)
    }
    
    public static func currentDetailsDate() -> String {
        let currStamp = getStamp()
        return timeStampToStringDetail(String(format: "%d", currStamp))
    }
    
    public static func currentWeekDay() -> Int {
        return weekDay(Date())
    }
    
    public static func weekDay(_ date: Date) -> Int {
        let interval = Int(date.timeIntervalSince1970)
        let days = Int(interval / 86400)
        let weekday = ((days + 4) % 7 + 7) % 7
        return weekday == 0 ? 7 : weekday
    }
    
    public static func weekdayStringWithDate(_ date: Date) -> String {
        let componets = NSCalendar.current.component(.weekday, from: date)
        let m = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
        return m[componets - 1]
    }
    
    public static func countOfDaysInCurrentMonth() -> Int {
        let calendar = Calendar(identifier: .gregorian)
        let range = (calendar as NSCalendar?)?.range(of: .day, in: .month, for: Date())
        return (range?.length)!
    }
    
    public static func firstWeekDayInCurrentMonth() -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(Date().xp.year) + "-" + String(Date().xp.month))
        let calender = Calendar(identifier: .gregorian)
        let comps = (calender as NSCalendar?)?.components(.weekday, from: date!)
        var week = comps?.weekday
        if week == 1 {
            week = 8
        }
        return week! - 1
    }
    
    public static func getCountOfDaysInMonth(year: Int, month: Int) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year) + "-" + String(month))
        let calendar = Calendar(identifier: .gregorian)
        let range = (calendar as NSCalendar?)?.range(of: .day, in: .month, for: date!)
        return (range?.length)!
    }
    
    public static func getfirstWeekDayInMonth(year: Int, month: Int) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM"
        let date = dateFormatter.date(from: String(year) + "-" + String(month))
        let calendar = Calendar(identifier: .gregorian)
        let comps = (calendar as NSCalendar?)?.components(.weekday, from: date!)
        let week = comps?.weekday
        return week! - 1
    }
    
    public static func dateToDateString(_ date: Date, dateFormat: String) -> String {
        let timeZone = NSTimeZone.local
        let formatter = DateFormatter()
        formatter.timeZone = timeZone
        formatter.dateFormat = dateFormat
        return formatter.string(from: date)
    }
    
    public static func dateStringToDate(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: dateStr)!
    }
    
    public static func timeStringToDate(_ dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd  HH:mm:ss"
        return dateFormatter.date(from: dateStr)!
    }
    
    public static func dateDifference(_ dateA: Date, from dateB: Date) -> Double {
        let interval = dateA.timeIntervalSince(dateB)
        return interval / 86400
    }
    
    public static func compareOneDay(oneDay: Date, withAnotherDay anotherDay: Date) -> Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let oneDayStr = dateFormatter.string(from: oneDay)
        let anotherDayStr = dateFormatter.string(from: anotherDay)
        let dateA = dateFormatter.date(from: oneDayStr)
        let dateB = dateFormatter.date(from: anotherDayStr)
        let result = dateA?.compare(dateB!)
        
        if result == .orderedDescending {
            return 1
        } else if result == .orderedAscending {
            return 2
        } else {
            return 0
        }
    }
    
    public static func stringToTimeStamp(_ stringTime: String) -> Int {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dfmatter.locale = Locale.current
        
        let date = dfmatter.date(from: stringTime)
        let dateStamp = date!.timeIntervalSince1970
        return Int(dateStamp)
    }
    
    public static func timeStampToString(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    public static func timeStampToStringDetail(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    public static func timeStampToStringDetailHHMM(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    public static func timeStampToHHMMSS(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "HH:mm:ss"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    public static func timeStampToHHMM(_ timeStamp: String) -> String {
        let string = NSString(string: timeStamp)
        let timeSta = string.doubleValue
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "HH:mm"
        let date = Date(timeIntervalSince1970: timeSta)
        return dfmatter.string(from: date)
    }
    
    public static func getStamp() -> Int {
        let date = Date()
        return Int(date.timeIntervalSince1970)
    }
    
    public static func numberToChina(monthNum: Int) -> String {
        let ChinaArray = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
        return ChinaArray[monthNum - 1]
    }
    
    public static func add0BeforeNumber(_ number: Int) -> String {
        return number >= 10 ? String(number) : "0" + String(number)
    }
    
    public static func compareCurrentTime(str: String) -> String {
        let timeDate = timeStringToDate(str)
        let currentDate = NSDate()
        let timeInterval = currentDate.timeIntervalSince(timeDate)
        var temp: Double = 0
        var result: String = ""
        
        if timeInterval / 60 < 1 {
            result = String(timeInterval)
        } else if timeInterval / 60 < 60 {
            temp = timeInterval / 60
            result = "\(Int(temp))分钟前"
        } else if timeInterval / 60 / 60 < 24 {
            temp = timeInterval / 60 / 60
            result = "\(Int(temp))小时前"
        } else if timeInterval / (24 * 60 * 60) < 30 {
            temp = timeInterval / (24 * 60 * 60)
            result = "\(Int(temp))天前"
        } else if timeInterval / (30 * 24 * 60 * 60) < 12 {
            temp = timeInterval / (30 * 24 * 60 * 60)
            result = "\(Int(temp))个月前"
        } else {
            temp = timeInterval / (12 * 30 * 24 * 60 * 60)
            result = "\(Int(temp))年前"
        }
        
        return result
    }
    
    public static func comparePastTime(startTime: String) -> String {
        let timestamp = Date().timeIntervalSince1970
        let timeStamp2 = CLongLong(round(timestamp * 1000))
        let startTime2 = CLongLong(startTime)!
        let difference = CLongLong((timeStamp2 - startTime2) / 1000)
        
        var formattingStr = ""
        if difference < 60 {
            formattingStr = String(format: "00时00分%02d秒", difference)
        } else if difference >= 60 && difference < 3600 {
            let min = Int(difference / 60)
            let sec = difference - CLongLong(min * 60)
            formattingStr = String(format: "00时%02d分%02d秒", min, sec)
        } else {
            let hour = Int(difference / 3600)
            let min = Int((difference - CLongLong(hour * 60 * 60)) / 60)
            let sec = difference - CLongLong(hour * 60 * 60) - CLongLong(min * 60)
            formattingStr = String(format: "%d时%02d分%02d秒", hour, min, sec)
        }
        
        return formattingStr
    }
    
    public static func durationBetween(beginTime: String, endTime: String) -> String {
        let dfmatter = DateFormatter()
        dfmatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let bt = dfmatter.date(from: beginTime), let et = dfmatter.date(from: endTime) else {
            return ""
        }
        
        let timestamp = bt.timeIntervalSince1970
        let timeStamp2 = CLongLong(round(timestamp * 1000))
        let endTimeStamp = CLongLong(round(et.timeIntervalSince1970 * 1000))
        let difference = CLongLong((endTimeStamp - timeStamp2) / 1000)
        
        var formattingStr = ""
        if difference < 60 {
            formattingStr = String(format: "00时00分%02d秒", difference)
        } else if difference >= 60 && difference < 3600 {
            let min = Int(difference / 60)
            let sec = difference - CLongLong(min * 60)
            formattingStr = String(format: "00时%02d分%02d秒", min, sec)
        } else {
            let hour = Int(difference / 3600)
            let min = Int((difference - CLongLong(hour * 60 * 60)) / 60)
            let sec = difference - CLongLong(hour * 60 * 60) - CLongLong(min * 60)
            formattingStr = String(format: "%d时%02d分%02d秒", hour, min, sec)
        }
        
        return formattingStr
    }
}