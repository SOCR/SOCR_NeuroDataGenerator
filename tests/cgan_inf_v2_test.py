# python test.py
from cgan_inference_v2 import inference
import matplotlib.pyplot as plt


# inference(1)
img_data = inference("brainGen_v1","Without Tumor","Axial","Superior")
print(img_data)                                                                                                        
# plt.imshow(img_data)
# plt.show()