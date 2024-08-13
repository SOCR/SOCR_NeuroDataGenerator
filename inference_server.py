import io
import json
import torch
from PIL import Image
from generator import Generator
import numpy as np
from flask import Flask, jsonify, request
from PIL import Image


app = Flask(__name__)
torch.manual_seed(1)
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
device = 'cpu'
batch_size = 128

# Root directory for the dataset
model_path = "model\generator_epoch_950.pth"
img_save_pth = "images"

image_shape = (3, 128, 128)
image_dim = int(np.prod(image_shape))
latent_dim = 100

n_classes = 2
embedding_dim = 100

generator = Generator(n_classes, embedding_dim,latent_dim).to(device)

generator.load_state_dict(torch.load(model_path), strict=False)
print("Model loaded....................")
num_images = 1
generator.eval()



@app.route('/generate', methods=['POST'])
def generate():
    if request.method == 'POST':
        input = request.json
        label = input.get('label')
         # Generate random noise
        z = torch.randn(num_images, latent_dim)
        z = z.to(device)
        
        with torch.no_grad():
            labels = torch.ones(num_images) * label
            labels = labels.to(device)
            labels = labels.unsqueeze(1).long()
            generated_images = generator((z, labels))
        print(generated_images.shape)
        
        image = generated_images[0].permute(1, 2, 0).cpu().numpy()  # Change tensor to numpy array
        image = (image + 1) / 2.0 * 255.0  # Rescale pixel values
        image = image.astype('uint8')

        im = Image.fromarray(image)

        # Save the image as JPEG
        im.save("static/image.jpg")
        
        img_path = "http://127.0.0.1:5000/static/image.jpg"

        print("New image generated ............... ", "label : ",label)

        return jsonify({'imageUrl': img_path})


if __name__ == '__main__':
    app.run()