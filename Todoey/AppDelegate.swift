//
//  AppDelegate.swift
//  Todoey
//
//  Created by Davide Santo on 02.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
import CoreData
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // First thing that happens before ViewDidlad
        
        
//        // Create new data object to be committe to Real DB
//        let data = Data()
//        data.name = "Davide"
//        data.age = 50
        
        //to locate where Realm will store data
        print("Realm DB address: \(Realm.Configuration.defaultConfiguration.fileURL)")
        
        do{
            let realm = try Realm()
//            try  realm.write {
//                realm.add(data)
//            }
        } catch{
            print("Error initialising new Rea;, \(error)")
        }
        
        
        // commit new data to Real
        
        return true
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
               
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }



}

