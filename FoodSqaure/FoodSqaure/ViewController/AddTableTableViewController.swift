//
//  AddTableTableViewController.swift
//  foodPin TableViewControllerTest
//
//  Created by Fan on 2016/10/8.
//  Copyright © 2016年 Fan. All rights reserved.
//

import UIKit
import CoreData

class AddTableTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{
    
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    @IBOutlet weak var locationTextField:UITextField!
    @IBOutlet weak var yesButton:UIButton!
    @IBOutlet weak var noButton:UIButton!

    var isVisited = true
    var restaurant:Restaurant!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTextField(textField: nameTextField)
        settingTextField(textField: typeTextField)
        settingTextField(textField: locationTextField)
        
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    

    @IBAction func save() {
        // Form validation
        var errorField = ""
        
        if nameTextField.text == "" {
            errorField = "name"
        } else if locationTextField.text == "" {
            errorField = "location"
        } else if typeTextField.text == "" {
            errorField = "type"
        }
        
        if errorField != "" {
            let alertController = UIAlertController(title: "Oops", message: "We can't proceed as you forget to fill in the restaurant " + errorField + ". All fields are mandatory.", preferredStyle: .alert)
            let doneAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
            
            return
        }
        
        // CoreData
        storeRestaurant(name: nameTextField.text!, type: typeTextField.text!, location: locationTextField.text!, isVisited: isVisited, image: UIImagePNGRepresentation(imageView.image!)! as NSData!)
        
        }
    
    
    //Saving CoreData
    
    func storeRestaurant(name: String, type: String, location:String, isVisited:Bool, image:NSData) {
        let context = getContext()
        
        //retrieve the entity that we just created
        let entity =  NSEntityDescription.entity(forEntityName: "Restaurant", in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        //set the entity values
        transc.setValue(name, forKey: "name")
        transc.setValue(type, forKey: "type")
        transc.setValue(location, forKey: "location")
        transc.setValue(isVisited, forKey: "isVisited")
        transc.setValue(image, forKey: "image")
        
        //save the object
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    
    @IBAction func updateIsVisited(sender: AnyObject) {
        // Yes button clicked
        let buttonClicked = sender as! UIButton
        if buttonClicked == yesButton {
            isVisited = true
            yesButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
            noButton.backgroundColor = UIColor.gray
        } else if buttonClicked == noButton {
            isVisited = false
            yesButton.backgroundColor = UIColor.gray
            noButton.backgroundColor = UIColor(red: 235.0/255.0, green: 73.0/255.0, blue: 27.0/255.0, alpha: 1.0)
        }
    }
    
    func settingTextField(textField: UITextField!){
        textField.delegate = self
        textField.clearButtonMode = UITextFieldViewMode.whileEditing
        textField.returnKeyType = UIReturnKeyType.done
        textField.keyboardAppearance = UIKeyboardAppearance.alert
    }
    
    func textFieldShouldReturn(_ textField:UITextField) -> Bool
    {
        //Return The Keyboard
        textField.resignFirstResponder()
        return true;
    }
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
       

}
