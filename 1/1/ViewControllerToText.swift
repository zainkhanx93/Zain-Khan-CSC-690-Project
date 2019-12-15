//
//  ViewControllerToText.swift
//  1
//
//  Created by Amari Bolmer on 12/12/19.
//  Copyright © 2019 Zain Khan. All rights reserved.
//

import UIKit

class LocationParked: UIViewController {
    @IBOutlet weak var ParkedLocation: UILabel!
    var selectedName: String = "Anonymous"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.async {
            self.ParkedLocation.text = self.selectedName
            print(self.ParkedLocation ?? "annoy")
        
        }

        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
