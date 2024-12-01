import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "RewardsTracker")
        
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create sample memberships
        let membership = MembershipEntity(context: viewContext)
        membership.id = UUID()
        membership.name = "American Airlines AAdvantage"
        membership.type = "airline"
        membership.tier = "Gold"
        membership.membership_number = "AA123456"
        membership.tier_progress = 0.75
        
        // Encode benefits data
        let aaBenefits = ["Priority Check-in", "Complimentary Upgrades", "Lounge Access"]
        membership.benefits = aaBenefits
        
        let aaUpcomingBenefits = ["Executive Platinum Status", "Unlimited Upgrades"]
        membership.upcomingBenefits = aaUpcomingBenefits
        
        let aaProgress = EliteProgressInfo(current: 75000, required: 100000, remaining: 25000, metric: "miles")
        membership.statusProgress = aaProgress
        
        let membership2 = MembershipEntity(context: viewContext)
        membership2.id = UUID()
        membership2.name = "Marriott Bonvoy"
        membership2.type = "hotel"
        membership2.tier = "Platinum"
        membership2.membership_number = "MB789012"
        membership2.tier_progress = 0.85
        
        let marriottBenefits = ["Room Upgrades", "Late Checkout", "Welcome Gift"]
        membership2.benefits = marriottBenefits
        
        let marriottUpcomingBenefits = ["Ambassador Status", "Your24"]
        membership2.upcomingBenefits = marriottUpcomingBenefits
        
        let marriottProgress = EliteProgressInfo(current: 85, required: 100, remaining: 15, metric: "nights")
        membership2.statusProgress = marriottProgress
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller
    }()
    
    func save() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Error saving context: \(error)")
            }
        }
    }
    
    func createSampleMembership() -> MembershipEntity {
        let membership = MembershipEntity(context: container.viewContext)
        membership.id = UUID()
        membership.name = "American Airlines AAdvantage"
        membership.type = "airline"
        membership.tier = "Gold"
        membership.membership_number = "AA123456"
        membership.tier_progress = 0.75
        
        // Encode benefits data
        let aaBenefits = ["Priority Check-in", "Complimentary Upgrades", "Lounge Access"]
        membership.benefits = aaBenefits
        
        let aaUpcomingBenefits = ["Executive Platinum Status", "Unlimited Upgrades"]
        membership.upcomingBenefits = aaUpcomingBenefits
        
        let aaProgress = EliteProgressInfo(current: 75000, required: 100000, remaining: 25000, metric: "miles")
        membership.statusProgress = aaProgress
        
        return membership
    }
}
