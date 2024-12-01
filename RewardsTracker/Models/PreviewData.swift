import CoreData

struct PreviewData {
    static var preview: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "RewardsTracker")
        
        // Use in-memory store for previews
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load preview store: \(error)")
            }
        }
        
        let context = container.viewContext
        
        // Create sample data
        let americanAirlines = MembershipEntity(context: context)
        americanAirlines.id = UUID()
        americanAirlines.name = "American Airlines"
        americanAirlines.type = "airline"
        americanAirlines.tier = "Gold"
        americanAirlines.membership_number = "AA123456"
        americanAirlines.tier_progress = 0.75
        
        // Encode benefits data
        let aaBenefits = ["Priority Check-in", "Complimentary Upgrades", "Lounge Access"]
        americanAirlines.benefits = aaBenefits
        
        let aaUpcomingBenefits = ["Executive Platinum Status", "Unlimited Upgrades"]
        americanAirlines.upcomingBenefits = aaUpcomingBenefits
        
        let aaProgress = EliteProgressInfo(current: 75000, required: 100000, remaining: 25000, metric: "miles")
        americanAirlines.statusProgress = aaProgress
        
        // Create Marriott membership
        let marriott = MembershipEntity(context: context)
        marriott.id = UUID()
        marriott.name = "Marriott Bonvoy"
        marriott.type = "hotel"
        marriott.tier = "Platinum"
        marriott.membership_number = "MB789012"
        marriott.tier_progress = 0.85
        
        let marriottBenefits = ["Room Upgrades", "Late Checkout", "Welcome Gift"]
        marriott.benefits = marriottBenefits
        
        let marriottUpcomingBenefits = ["Ambassador Status", "Your24"]
        marriott.upcomingBenefits = marriottUpcomingBenefits
        
        let marriottProgress = EliteProgressInfo(current: 85, required: 100, remaining: 15, metric: "nights")
        marriott.statusProgress = marriottProgress
        
        try? context.save()
        return context
    }()
}
