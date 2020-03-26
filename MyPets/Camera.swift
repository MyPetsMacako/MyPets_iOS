

import UIKit

class Camera: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var image: UIImageView!
    
    let imagePicker: UIImagePickerController = UIImagePickerController()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func camera (_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera)
        {
            if UIImagePickerController.availableCaptureModes(for: .rear) != nil
            {
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                
                imagePicker.cameraCaptureMode = .photo
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func galery(_ sender: Any)
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
         
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .photoLibrary
          
                present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            print("no entra")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        if let imageSelected: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        {
            image.image = imageSelected
            
           if imagePicker.sourceType == .camera
           {
            UIImageWriteToSavedPhotosAlbum(imageSelected, nil, nil, nil)
            }
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}
