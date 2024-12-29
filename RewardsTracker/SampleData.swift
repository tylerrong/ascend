import Foundation
import CoreData

struct SampleData {
    static func loadSampleData(context: NSManagedObjectContext) {
        // Sample Airlines Programs
        let united = MembershipEntity(context: context)
        united.id = UUID()
        united.name = "United MileagePlus"
        united.tier = "Premier Gold"
        united.tier_progress = 0.75
        united.type = "Airline"
        united.benefits = [
            "Complimentary access to Economy Plus seats",
            "Priority check-in",
            "2 free checked bags",
            "Star Alliance Gold status"
        ]
        united.upcomingBenefits = ["Free Upgrade Available"]
        united.statusProgress = EliteProgressInfo(
            current: 75,
            required: 100,
            remaining: 25,
            metric: "Points"
        )

        let delta = MembershipEntity(context: context)
        delta.id = UUID()
        delta.name = "Delta SkyMiles"
        delta.tier = "Platinum Medallion"
        delta.tier_progress = 0.85
        delta.type = "Airline"
        delta.benefits = [
            "Unlimited Complimentary Upgrades",
            "Sky Priority",
            "3 free checked bags",
            "SkyTeam Elite Plus status"
        ]
        delta.upcomingBenefits = ["Choice Benefit Selection"]
        delta.statusProgress = EliteProgressInfo(
            current: 85,
            required: 100,
            remaining: 15,
            metric: "Points"
        )

        let amex = MembershipEntity(context: context)
        amex.id = UUID()
        amex.name = "American Express Platinum"
        amex.tier = "Platinum Card Member"
        amex.tier_progress = 1.0
        amex.type = "Membership"
        amex.benefits = [
            "Airport Lounge Access",
            "$200 Airline Fee Credit",
            "Global Entry/TSA PreCheck Credit",
            "Uber Credits"
        ]
        amex.upcomingBenefits = ["Hotel Status Update"]
        amex.statusProgress = EliteProgressInfo(
            current: 100,
            required: 100,
            remaining: 0,
            metric: "Points"
        )

        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
