import torch
import numpy as np
from generator_3d import Generator32,Generator64
from PIL import Image
import base64
import io
import uuid
import os
import nibabel as nib

def class_embedding(tumour,slice_orientation,slice_location):
  
   oreintation_dict = {"Axial":0, "Coronal":6, "Sagittal":12}
   location_dict    = {"Inferior" : 0, "Middle": 2, "Superior":4,
                      "Left":0, "Right":4, "Front":0, "Back":4}
   tumour_dict      = {"Without Tumor": 0, "With Tumor":1}
   
   class_label      = oreintation_dict[slice_orientation] + \
                      location_dict[slice_location] + tumour_dict[tumour]
                      
   return class_label
                  

def inference(model, resolution):
    # torch.manual_seed(1)

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    device = torch.device('cpu')
    batch_size = 128
    img_save_pth = "images"
    
    
    cube_len = 32
    epoch_count = 20
    batch_size = 128
    
    
    condition_count = 1

    print("Selected model ",model)
    
    # label = class_embedding(tumour,slice_orientation,slice_location)
    
    if(resolution == "32x32x32"):
      print("model 64 selected")
      noise_size = 200
      model_path = "model/generator_epoch_6100.pth"
      generator = Generator32(noise_size=(noise_size + 1), cube_resolution=cube_len) 
    elif(resolution == "64x64x64"):
      print("model 64 selected")
      noise_size = 400
      model_path = "model/generator_epoch_3d64.pth"
      generator = Generator64(noise_size=(noise_size + 1), cube_resolution=cube_len) 
    

    image_shape = (cube_len,cube_len,cube_len)
   
    generator.load_state_dict(torch.load(model_path,map_location=torch.device('cpu')), strict=False)
    print("Model loaded....................")
    num_images = 2
    generator.eval()
  

    # Generate random noise
    z = torch.randn([num_images,noise_size], device=device)

    print("Inference started...............")

    # Generate images using the generator
    # with torch.no_grad():
    #     labels = torch.ones(num_images) * label
    #     labels = labels.to(device)
    #     labels = labels.unsqueeze(1).long()
    #     generated_images = generator((z, labels))
    generated_images = generator(z, 0)
    print(generated_images.shape)

    # image = generated_images[0].permute(1, 2, 0).cpu().numpy()  # Change tensor to numpy array
    # image = (image + 1) / 2.0 * 255.0  # Rescale pixel values

    generated_image =generated_images.detach().cpu().numpy()[0]
    
    
    unique_id = uuid.uuid4().hex  # Generate a random UUID and convert it to a hexadecimal string
    
    
    if(resolution == "32x32x32"):
      unique_filename = f"{'mri32'}_{unique_id}.{'nii.gz'}"
    elif(resolution == "64x64x64"):
      unique_filename = f"{'mri64'}_{unique_id}.{'nii.gz'}"
    
    # image_filenames = []
    # image_filenames.append(unique_filename)
    img_path = os.path.join(os.getcwd(),"images", unique_filename)
    
    # if(model == "brainGen_v1"):
    #   im = Image.fromarray(image.astype("uint8"))
    #   if(slice_orientation == 'Sagittal' or slice_orientation == 'Coronal' ):
    #     im = im.rotate(90, expand=True)
    #     print("image rotated")
    #   print("just checking if this is working")
    #   im.save(img_path)
      
    # elif(model == "brainGenSeg_v1"):
    #   # print(image.shape)
    #   im    = image[:,:,:3]
    #   im_sg = image[:,:,3,None]

    #   print(im_sg.shape)
      
    #   im    = Image.fromarray(im.astype("uint8"))
    #   im_sg = Image.fromarray(np.repeat(im_sg.astype("uint8"), 3, axis=2))
      
    #   if(slice_orientation == 'Sagittal' or slice_orientation == 'Coronal' ):
    #     im = im.rotate(90, expand=True)
    #     im_sg = im_sg.rotate(90, expand=True)
    #     print("image rotated")
      
    #   unique_filename_seg = f"{'mri_seg'}_{unique_id}.{'png'}"
    #   img_path_seg = os.path.join(os.getcwd(),"images", unique_filename_seg)
      
    #   im.save(img_path)
    #   im_sg.save(img_path_seg)
    #   image_filenames.append(unique_filename_seg)
    affine  = np.eye(4)
    new_img = nib.Nifti1Image(generated_image,affine = affine)
    nib.save(new_img, img_path)
      
    
    print(img_path)

    print('Generated images generated and  saved successfully .')
    

    # return image_filenames
    return img_path
