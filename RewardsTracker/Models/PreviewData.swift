import CoreData

struct PreviewData {
    static let shared = PreviewData()
    static var preview: NSManagedObjectContext { shared.context }
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "RewardsTracker")
        
        // Configure the container for in-memory store
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
        
        context = container.viewContext
        PersistenceController.createSampleData(in: context)
    }
}

extension PersistenceController {
    static func createSampleData(in context: NSManagedObjectContext) {
        let americanAirlines = MembershipEntity(context: context)
        americanAirlines.id = UUID()
        americanAirlines.name = "American Airlines"
        americanAirlines.type = "Airline"
        americanAirlines.tier = "Executive Platinum"
        americanAirlines.membership_number = "AA123456"
        americanAirlines.tier_progress = 0.85
        americanAirlines.points = 85000
        
        let aaBenefits = ["Priority Check-in", "3 Free Checked Bags", "Lounge Access"]
        americanAirlines.benefits_data = try? JSONEncoder().encode(aaBenefits)
        
        let aaUpcoming = ["Million Miler Status"]
        americanAirlines.upcomingBenefits_data = try? JSONEncoder().encode(aaUpcoming)
        
        let aaProgress = EliteProgressInfo(current: 85000, required: 100000, remaining: 15000, metric: "miles")
        americanAirlines.statusProgress_data = try? JSONEncoder().encode(aaProgress)
        
        let marriott = MembershipEntity(context: context)
        marriott.id = UUID()
        marriott.name = "Marriott Bonvoy"
        marriott.type = "Hotel"
        marriott.tier = "Titanium Elite"
        marriott.membership_number = "MB789012"
        marriott.tier_progress = 0.9
        marriott.points = 250000
        
        let marriottBenefits = ["Late Checkout", "Room Upgrades", "Lounge Access", "Welcome Gift"]
        marriott.benefits_data = try? JSONEncoder().encode(marriottBenefits)
        
        let marriottUpcoming = ["Ambassador Elite Status"]
        marriott.upcomingBenefits_data = try? JSONEncoder().encode(marriottUpcoming)
        
        let marriottProgress = EliteProgressInfo(current: 90, required: 100, remaining: 10, metric: "nights")
        marriott.statusProgress_data = try? JSONEncoder().encode(marriottProgress)
        
        try? context.save()
    }
    
    static func createSampleMembership() -> MembershipEntity {
        let context = PreviewData.preview
        let membership = MembershipEntity(context: context)
        membership.id = UUID()
        membership.name = "Sample Membership"
        membership.type = "Airline"
        membership.tier = "Gold"
        membership.membership_number = "12345"
        membership.tier_progress = 0.75
        membership.points = 50000
        
        let sampleBenefits = ["Priority Boarding", "Extra Baggage", "Lounge Access"]
        membership.benefits_data = try? JSONEncoder().encode(sampleBenefits)
        
        let sampleUpcoming = ["Platinum Status"]
        membership.upcomingBenefits_data = try? JSONEncoder().encode(sampleUpcoming)
        
        let sampleProgress = EliteProgressInfo(current: 75, required: 100, remaining: 25, metric: "flights")
        membership.statusProgress_data = try? JSONEncoder().encode(sampleProgress)
        
        return membership
    }
}
