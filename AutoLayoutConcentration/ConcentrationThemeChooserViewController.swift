//
//  ConcentrationThemeChooserViewController.swift
//  Concentration Multiple MVCS
//
//  Created by Boppo on 15/04/19.
//  Copyright © 2019 MB. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController ,UISplitViewControllerDelegate{
    
    
    
    let themes = [
        "Sports" : "🥎🏀🎳⚽️🏹🏏🏓🏎🥊🎱🚵‍♀️",
        "Animals": "🐲🦢🦞🐇🐈🐒🐍🐔🐧🐸🦄",
        "Faces"  : "😀😇😂🤪🧐🥳🥶🙄🤯😎🤩"
    ]
    
    
    
    
    //even in iPhone its in splitView Controller even if it doesn't show it as splitView controller
    
    //awake from is a function that's called on every object that comes out of your Interface Builder file

    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        
        if let cvc = secondaryViewController as? ConcentrationViewController{
            if cvc.theme == nil{
                //I collapsed it and it's not going to get done
                return true
            }
        }
        //false means no i didn't collapsed so you should do it.
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        // finding things through splitView
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle,let theme = themes[themeName]{
                cvc.theme = theme
            }
        }
            //Hold something in heap
        else if let cvc = lastSeguedToConcentrationViewController{
            //pushing the cvc to navigationController without segueing
            navigationController?.pushViewController(cvc, animated: true)
            if let themeName = (sender as? UIButton)?.currentTitle,let theme = themes[themeName]{
                cvc.theme = theme
            }
        }
        else{
            //segue from code
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }

    private var splitViewDetailConcentrationViewController : ConcentrationViewController?{
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    

    private var lastSeguedToConcentrationViewController : ConcentrationViewController?
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "Choose Theme"{
            //Optional Chaining
            if let themeName = (sender as? UIButton)?.currentTitle,let theme = themes[themeName]
            {
                //downcast the UIViewController to ConcentrationViewController using as?
                if let cvc = segue.destination as? ConcentrationViewController{
                    cvc.theme = theme
                    
                    //strong pointer grabbing on cvc  
                    lastSeguedToConcentrationViewController = cvc
                }
            }
        }
    }
    
    
}
