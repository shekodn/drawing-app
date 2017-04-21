//
//  mainVC.swift
//  DrawPad
//
//  Created by Sergio Díaz Navarro on 4/21/17.
//  Copyright © 2017 Ray Wenderlich. All rights reserved.
//

import UIKit





class mainVC: UIViewController, protocoloCambiaFoto {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btnEdit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }


    func modificaFoto(imagen: UIImage) {
        
        imageView.image = imagen
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "toEdit") {
            
            let editVC = segue.destination as! ViewController
            
            editVC.myImage = imageView.image
            editVC.delegado = self
            
        }
    }
    
}
