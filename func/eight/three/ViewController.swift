//
//  ViewController.swift
//  three
//
//  Created by Jz D on 2021/3/20.
//

import UIKit




class ViewController: UIViewController {
    

    
    


    override func viewDidLoad() {
        super.viewDidLoad()

        
    }


    
    
    @IBAction func oneDo(_ sender: Any) {
        
        let one = ColumnListController()
        
        
        do{
            
            if let src = Bundle.main.url(forResource: "one", withExtension: "plist"){
                let data = try Data(contentsOf: src)
       
                let resp = try PropertyListDecoder().decode(Column_detail.self, from: data)
                one.reqColumnList(x: resp)
            }
            
            
        }
        catch{
            print(error)
        }
        
        
        
        navigationController?.pushViewController(one, animated: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    @IBAction func twoDo(_ sender: Any) {
        
        
        
        
        let one = ColumnListController()
        
        do{
            
            if let src = Bundle.main.url(forResource: "two", withExtension: "plist"){
                let data = try Data(contentsOf: src)
       
                let resp = try PropertyListDecoder().decode(Column_detail.self, from: data)
                one.reqColumnList(x: resp)
            }
            
            
        }
        catch{
            print(error)
        }
        
        navigationController?.pushViewController(one, animated: true)
        
        
        
        
        
        
    }
    
    
    
    
    
    
}

