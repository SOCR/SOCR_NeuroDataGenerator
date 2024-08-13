import torch
import numpy as np
from generator import Generator
from PIL import Image
import base64
import io
import uuid
import os
from diffusers import DDIMScheduler
from diffusers import UNet2DModel
import PIL.Image
# import tqdm




def inference_diffuser():
   
  repo_id = r"E:\OneDrive\SOCR\RshinyApp\SOCR_ImgGenApp_v1.5\model\ddim-brain-128\unet"
  model = UNet2DModel.from_pretrained(repo_id)

  scheduler = DDIMScheduler()
  scheduler.set_timesteps(num_inference_steps=50)


  # torch.manual_seed(0)

  noisy_sample = torch.randn(
      1, model.config.in_channels, model.config.sample_size, model.config.sample_size
  )
  model.to("cpu")
  noisy_sample = noisy_sample.to("cpu")

  sample = noisy_sample

  for i, t in enumerate(scheduler.timesteps):
    # 1. predict noise residual
    with torch.no_grad():
        residual = model(sample, t).sample

    # 2. compute less noisy image and set x_t -> x_t-1
    sample = scheduler.step(residual, t, sample).prev_sample

  image_processed = sample.cpu().permute(0, 2, 3, 1)
  image_processed = (image_processed + 1.0) * 127.5
  image_processed = image_processed.numpy().astype(np.uint8)

  image_pil = PIL.Image.fromarray(image_processed[0])
  # display(f"Image at step {i}")
  # display(image_pil)
  # image_pil.show()

  unique_id = uuid.uuid4().hex  # Generate a random UUID and convert it to a hexadecimal string
  unique_filename = f"{'mri'}_{unique_id}.{'png'}"

  image_filenames = []
  image_filenames.append(unique_filename)
  img_path = os.path.join(os.getcwd(),"images", unique_filename)

  image_pil.save(img_path)


  print(image_filenames)

  print('Generated diffuser images saved successfully.')

  return image_filenames


def inference(label,model):
    # torch.manual_seed(1)

    device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
    device = torch.device('cpu')
    batch_size = 128
    img_save_pth = "images"
    latent_dim = 100
    n_classes = 2
    embedding_dim = 100

    print("Selected model ",model)
    
    
    if(model == "brainGen_v1"):
      # Root directory for the dataset
      model_path = "model/generator_epoch_950.pth"
      n_channels = 3
      
    elif(model == "brainGenSeg_v1"):
      model_path = "model/generator_epoch_200_seg.pth"
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
      im.save(img_path)
      
    elif(model == "brainGenSeg_v1"):
      # print(image.shape)
      im    = image[:,:,:3]
      im_sg = image[:,:,3,None]

      print(im_sg.shape)
      
      im    = Image.fromarray(im.astype("uint8"))
      im_sg = Image.fromarray(np.repeat(im_sg.astype("uint8"), 3, axis=2))
      
      
      unique_filename_seg = f"{'mri_seg'}_{unique_id}.{'png'}"
      img_path_seg = os.path.join(os.getcwd(),"images", unique_filename_seg)
      
      im.save(img_path)
      im_sg.save(img_path_seg)
      image_filenames.append(unique_filename_seg)
      
    
    print(image_filenames)

    print('Generated images saved successfully.')
    

    return image_filenames
