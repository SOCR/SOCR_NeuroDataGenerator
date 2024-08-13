import torch
import numpy as np
from generator import Generator
from PIL import Image
import base64
import io
import uuid
import os

def class_embedding(tumour,slice_orientation,slice_location):
  
   oreintation_dict = {"Axial":0, "Coronal":6, "Sagittal":12}
   location_dict    = {"Inferior" : 0, "Middle": 2, "Superior":4,
                      "Left":0, "Right":4, "Front":0, "Back":4}
   tumour_dict      = {"Without Tumor": 0, "With Tumor":1}
   
   class_label      = oreintation_dict[slice_orientation] + \
                      location_dict[slice_location] + tumour_dict[tumour]
                      
   return class_label
                  

def inference(model,tumour,slice_orientation,slice_location):
    # torch.manual_seed(1)

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    device = torch.device('cpu')
    batch_size = 128
    img_save_pth = "images"
    latent_dim = 100
    n_classes = 18
    embedding_dim = 20

    print("Selected model ",model)
    
    label = class_embedding(tumour,slice_orientation,slice_location)
    
    if(model == "brainGen_v1"):
      # Root directory for the dataset
      model_path = "model/generator_epoch_145.pth"
      n_channels = 3
      
    elif(model == "brainGenSeg_v1"):
      model_path = "model/generator_epoch_95_seg.pth"
      n_channels = 4
    image_shape = (n_channels, 128, 128)
    image_dim = int(np.prod(image_shape))
      
    generator = Generator(n_classes, embedding_dim,latent_dim,n_channels).to(device)

    generator.load_state_dict(torch.load(model_path,map_location=torch.device('cpu')), strict=False)
    print("Model loaded....................")
    num_images = 2
    generator.eval()
  

    # Generate random noise
    z = torch.randn(num_images, latent_dim)
    z = z.to(device)

    print("Inference started...............")

    # Generate images using the generator
    with torch.no_grad():
        labels = torch.ones(num_images) * label
        labels = labels.to(device)
        labels = labels.unsqueeze(1).long()
        generated_images = generator((z, labels))
    print(generated_images.shape)

    image = generated_images[0].permute(1, 2, 0).cpu().numpy()  # Change tensor to numpy array
    image = (image + 1) / 2.0 * 255.0  # Rescale pixel values
    
    
    unique_id = uuid.uuid4().hex  # Generate a random UUID and convert it to a hexadecimal string
    unique_filename = f"{'mri'}_{unique_id}.{'png'}"
    
    image_filenames = []
    image_filenames.append(unique_filename)
    img_path = os.path.join(os.getcwd(),"images", unique_filename)
    
    if(model == "brainGen_v1"):
      im = Image.fromarray(image.astype("uint8"))
      if(slice_orientation == 'Sagittal' or slice_orientation == 'Coronal' ):
        im = im.rotate(90, expand=True)
        print("image rotated")
      print("just checking if this is working")
      im.save(img_path)
      
    elif(model == "brainGenSeg_v1"):
      # print(image.shape)
      im    = image[:,:,:3]
      im_sg = image[:,:,3,None]

      print(im_sg.shape)
      
      im    = Image.fromarray(im.astype("uint8"))
      im_sg = Image.fromarray(np.repeat(im_sg.astype("uint8"), 3, axis=2))
      
      if(slice_orientation == 'Sagittal' or slice_orientation == 'Coronal' ):
        im = im.rotate(90, expand=True)
        im_sg = im_sg.rotate(90, expand=True)
        print("image rotated")
      
      unique_filename_seg = f"{'mri_seg'}_{unique_id}.{'png'}"
      img_path_seg = os.path.join(os.getcwd(),"images", unique_filename_seg)
      
      im.save(img_path)
      im_sg.save(img_path_seg)
      image_filenames.append(unique_filename_seg)
      
    
    print(image_filenames)

    print('Generated images generated and  saved successfully .')
    

    return image_filenames
