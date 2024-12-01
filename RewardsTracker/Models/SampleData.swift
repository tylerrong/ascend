import Foundation
import CoreData

struct SampleData {
    static func loadSampleData(context: NSManagedObjectContext) {
        // American Airlines
        let aa = MembershipEntity(context: context)
        aa.id = UUID()
        aa.name = "American Airlines"
        aa.type = "airline"
        aa.tier = "Gold"
        aa.membership_number = "AA123456"
        aa.tier_progress = 0.75
        
        let aaBenefits = [
            "Priority Check-in",
            "Complimentary Upgrades",
            "Lounge Access",
            "Extra Baggage Allowance"
        ]
        aa.benefits = aaBenefits
        
        let aaUpcomingBenefits = [
            "Executive Platinum Status",
            "Unlimited Upgrades",
            "Global Upgrades"
        ]
        aa.upcomingBenefits = aaUpcomingBenefits
        
        let aaProgress = EliteProgressInfo(
            current: 75000,
            required: 100000,
            remaining: 25000,
            metric: "miles"
        )
        aa.statusProgress = aaProgress
        
        // Marriott Bonvoy
        let marriott = MembershipEntity(context: context)
        marriott.id = UUID()
        marriott.name = "Marriott Bonvoy"
        marriott.type = "hotel"
        marriott.tier = "Platinum Elite"
        marriott.membership_number = "MB789012"
        marriott.tier_progress = 0.85
        
        let marriottBenefits = [
            "Room Upgrades",
            "Late Checkout",
            "Welcome Gift",
            "Lounge Access",
            "Enhanced Internet"
        ]
        marriott.benefits = marriottBenefits
        
        let marriottUpcomingBenefits = [
            "Ambassador Status",
            "Your24",
            "Annual Choice Benefit"
        ]
        marriott.upcomingBenefits = marriottUpcomingBenefits
        
        let marriottProgress = EliteProgressInfo(
            current: 85,
            required: 100,
            remaining: 15,
            metric: "nights"
        )
        marriott.statusProgress = marriottProgress
        
        // Amex Platinum
        let amex = MembershipEntity(context: context)
        amex.id = UUID()
        amex.name = "American Express Platinum"
        amex.type = "membership"
        amex.tier = "Platinum Card"
        amex.membership_number = "AMEX3456"
        amex.tier_progress = 1.0
        
        let amexBenefits = [
            "$200 Airline Credit",
            "$200 Hotel Credit",
            "Airport Lounge Access",
            "Global Entry Credit",
            "Uber Credits",
            "Saks Fifth Avenue Credit"
        ]
        amex.benefits = amexBenefits
        
        let amexProgress = EliteProgressInfo(
            current: 695,
            required: 695,
            remaining: 0,
            metric: "annual fee"
        )
        amex.statusProgress = amexProgress
        
        // Save the context
        do {
            try context.save()
        } catch {
            print("Error saving sample data: \(error.localizedDescription)")
        }
    }
}
