//
//  AppDelegate.swift
//  Todoey
//
//  Created by Davide Santo on 02.06.19.
//  Copyright © 2019 Davide Santo. All rights reserved.
//

import UIKit
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
        print("Realm DB address: \(String(describing: Realm.Configuration.defaultConfiguration.fileURL))")
        
        do{
            _ = try Realm()
//            try  realm.write {
//                realm.add(data)
//            }
        } catch{
            print("Error initialising new Rea;, \(error)")
        }
        
        
        // commit new data to Real
        
        return true
    }

  

    
   


}

