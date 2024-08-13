# python test.py
from cgan_inference import inference
# import matplotlib.pyplot as plt


# inference(1)
img_data = inference(0,"brainGenSeg_v1")
print(img_data)                                                                                                        
# plt.imshow(img_data)
# plt.show()