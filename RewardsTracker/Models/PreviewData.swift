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
        createSampleData()
    }
    
    private mutating func createSampleData() {
        let americanAirlines = MembershipEntity(context: context)
        americanAirlines.id = UUID()
        americanAirlines.name = "American Airlines"
        americanAirlines.type = "Airline"
        americanAirlines.tier = "Executive Platinum"
        americanAirlines.membership_number = "AA123456"
        americanAirlines.tier_progress = 0.85
        
        let benefits = ["Priority Check-in", "3 Free Checked Bags", "Lounge Access"]
        americanAirlines.benefits_data = try? JSONEncoder().encode(benefits)
        
        let upcomingBenefits = ["Million Miler Status"]
        americanAirlines.upcomingBenefits_data = try? JSONEncoder().encode(upcomingBenefits)
        
        let progress = EliteProgressInfo(current: 85000, required: 100000, remaining: 15000, metric: "miles")
        americanAirlines.statusProgress_data = try? JSONEncoder().encode(progress)
        
        let marriott = MembershipEntity(context: context)
        marriott.id = UUID()
        marriott.name = "Marriott Bonvoy"
        marriott.type = "Hotel"
        marriott.tier = "Titanium Elite"
        marriott.membership_number = "MB789012"
        marriott.tier_progress = 0.9
        
        let marriottBenefits = ["Room Upgrades", "Late Checkout", "Welcome Gift"]
        marriott.benefits_data = try? JSONEncoder().encode(marriottBenefits)
        
        let marriottUpcomingBenefits = ["Ambassador Status"]
        marriott.upcomingBenefits_data = try? JSONEncoder().encode(marriottUpcomingBenefits)
        
        let marriottProgress = EliteProgressInfo(current: 90, required: 100, remaining: 10, metric: "nights")
        marriott.statusProgress_data = try? JSONEncoder().encode(marriottProgress)
        
        try? context.save()
    }
}
