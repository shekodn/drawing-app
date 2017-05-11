//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

import UIKit


protocol protocoloCambiaFoto {
    func modificaFoto(imagen : UIImage) -> Void
    
}

class ViewController: UIViewController {
    
    @IBOutlet weak var viewBackgroundColorPallette: UIView!
    @IBOutlet weak var btnCancel: UIButton!
    @IBOutlet weak var btnDraw: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    @IBOutlet weak var btnReset: UIButton!
    @IBOutlet weak var colorPallet: UIStackView!

    @IBOutlet weak var tempImageView: UIImageView!
    @IBOutlet weak var imageViewPhoto: UIImageView!
    
    var myImage : UIImage? = nil
    var originalImage : UIImage? = nil

    var delegado : protocoloCambiaFoto!

    
    //lastPoint stores the last drawn point on the canvas. This is used when a continuous brush stroke is being drawn on the canvas.
    var lastPoint: CGPoint!


    //red, green, and blue store the current RGB values of the selected color.
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    //brushWidth and opacity store the brush stroke width and opacity.
    var brushWidth: CGFloat = 5.0
    var opacity: CGFloat = 1.0
    
    //swiped identifies if the brush stroke is continuous.
    var swiped = false
    
    //is drawing identifies if the drawing functionality is active or not
    var isDrawing = false
    
    
    
    
    //This builds up an array of RGB values, where each array element is a tuple of three
    // CGFloats. The colors here match the order of the colors in the interface as well as each 
    //button’s tag.

    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (255.0 / 255.0, 0.0   / 255.0, 24.0  / 255.0), //red
        (252.0 / 255.0, 162.0 / 255.0, 1.0   / 255.0), //yellow
        (254.0 / 255.0, 250.0 / 255.0, 4.0   / 255.0), //yellow
        (41.0  / 255.0, 159.0 / 255.0, 46.0  / 255.0), //green
        (2.0   / 255.0, 82.0  / 255.0, 173.0 / 255.0), //blue
        (136.0 / 255.0, 60.0  / 255.0, 191.0 / 255.0), //purple
        (0, 0, 0), //black
        ]


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colorPallet.alpha = 0
        btnReset.alpha = 0
        viewBackgroundColorPallette.alpha = 0

        tempImageView.image = nil
        originalImage = nil
        imageViewPhoto.image = myImage
        
        viewBackgroundColorPallette.layer.cornerRadius = 8
        
    

    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if(isDrawing){
            
            viewBackgroundColorPallette.fadeOut(0.5)
            btnSave.fadeOut(0.5)
            btnCancel.fadeOut(0.5)
            btnDraw.fadeOut(0.5)
            btnReset.fadeOut(0.5)
            colorPallet.fadeOut(0.5)

            
            swiped = false
            
            if let touch = touches.first {
                lastPoint = touch.location(in: self.view)
            }
        }
    }

    
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        /*
         * 1
         * The first method is responsible for drawing a line between two points. Here you want to draw
         * into tempImageView, so you need to set up a drawing context with the image currently in the
         * tempImageView (which should be empty the first time).
         */
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.draw(in: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        /*
         * Next, you get the current touch point and then draw a line with CGContextAddLineToPoint from
         * lastPoint to currentPoint. You might think that this approach will produce a series of
         * straight lines and the result will look like a set of jagged lines. This will produce 
         * straight lines, but the touch events fire so quickly that the lines are short enough and the
         * result will look like a nice smooth curve.
         */
        context?.move(to: CGPoint(x: fromPoint.x , y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x , y: toPoint.y))
        
        
        //3 Here are all the drawing parameters for brush size and opacity and brush stroke color.
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushWidth)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: 1.0).cgColor)
        context?.setBlendMode(CGBlendMode.normal)
        
        //4 This is where the magic happens, and where you actually draw the path!
        context?.strokePath()
        
        //5 Next, you need to wrap up the drawing context to render the new line into the temporary image view.
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        

        
        if(isDrawing){
            
            //7 In touchesMoved, you set swiped to true so you can keep track of whether there is a current swipe in progress. Since this is touchesMoved, the answer is yes, there is a swipe in progress! You then call the helper method you just wrote to draw the line.

            swiped = true

            if let touch = touches.first {
                let currentPoint = touch.location(in: view)
                drawLineFrom(fromPoint: lastPoint, toPoint: currentPoint)
                
                //Finally, you update the lastPoint so the next touch event will continue where you just left off.
                lastPoint = currentPoint
            }

        }
        
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        if(isDrawing){
            
            btnSave.fadeIn(0.5)
            btnCancel.fadeIn(0.5)
            btnDraw.fadeIn(0.5)
            btnReset.fadeIn(0.5)
            colorPallet.fadeIn(0.5)
            viewBackgroundColorPallette.fadeIn(0.5)

            
            if !swiped {
                // draw a single point
                drawLineFrom(fromPoint: lastPoint, toPoint: lastPoint)
            }
        }
    }

    
    
    // MARK: - Actions

    
    @IBAction func draw(_ sender: Any) {
        
        isDrawing = !isDrawing
        
        if(isDrawing){
            
            viewBackgroundColorPallette.fadeIn(0.24)
            colorPallet.fadeIn(0.25)
            btnReset.fadeIn(0.25)
            btnDraw.backgroundColor = .black
            btnDraw.layer.borderColor = UIColor.white.cgColor
            print("drawing!")

            
        
        } else{

            viewBackgroundColorPallette.fadeOut(0.24)
            colorPallet.fadeOut(0.25)
            btnReset.fadeOut(0.25)
            btnDraw.backgroundColor = .clear
            btnDraw.layer.borderColor = UIColor.clear.cgColor
            print("not drawing!")

        }
    }
    

    @IBAction func save(_ sender: Any) {
        
        print("Save!")
        

        var imageToSave : UIImage? = composite(image:imageViewPhoto.image, overlay:tempImageView.image)

        
        if (imageToSave == nil){
            
            print("Since image was not modified it was saved as the original")
            imageToSave = originalImage
        }
        
        
        delegado.modificaFoto(imagen: imageToSave!)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cancel(_ sender: Any) {
    
        print("Cancel!")
        self.dismiss(animated: true, completion: nil)
    }

    

    @IBAction func reset(_ sender: AnyObject) {
    
        self.tempImageView.image = originalImage
        
    }
    
    func composite(image:UIImage?, overlay: UIImage?, scaleOverlay: Bool = false)->UIImage?{
        
        
        if image != nil && overlay != nil {
            
            UIGraphicsBeginImageContext(image!.size)
            
            var rect = CGRect(x: 0, y: 0, width: image!.size.width, height: image!.size.height)
            
        
            image?.draw(in: rect)
            
            if scaleOverlay == true {
                rect = CGRect(x: 0, y: 0, width: overlay!.size.width, height: overlay!.size.height)
            }
            
            overlay!.draw(in: rect)
            
            return UIGraphicsGetImageFromCurrentImageContext()

        } else{
            
            return image
        }
        
    }

    
    @IBAction func pencilPressed(_ sender: AnyObject) {
        
    
        var index = sender.tag ?? 0
        
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        // 2
        (red, green, blue) = colors[index]
        btnDraw.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)

        
        // 3
        if index == colors.count - 1 {
            opacity = 1.0
        }

    
    }
}

