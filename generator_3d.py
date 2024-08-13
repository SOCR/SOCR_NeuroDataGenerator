import torch
import torch.nn as nn
import torch.nn.functional as F

class Generator32(nn.Module):
    def __init__ (self, noise_size=201, cube_resolution=32):
        super(Generator32, self).__init__()
        
        self.noise_size = noise_size
        self.cube_resolution = cube_resolution
        
        self.gen_conv1 = torch.nn.ConvTranspose3d(self.noise_size, 256, kernel_size=[4,4,4], stride=[2,2,2], padding=1)
        self.gen_conv2 = torch.nn.ConvTranspose3d(256, 128, kernel_size=[4,4,4], stride=[2,2,2], padding=1)
        self.gen_conv3 = torch.nn.ConvTranspose3d(128, 64, kernel_size=[4,4,4], stride=[2,2,2], padding=1)
        self.gen_conv4 = torch.nn.ConvTranspose3d(64, 32, kernel_size=[4,4,4], stride=[2,2,2], padding=1)
        self.gen_conv5 = torch.nn.ConvTranspose3d(32, 1, kernel_size=[4,4,4], stride=[2,2,2], padding=1)
        
        self.gen_bn1 = nn.BatchNorm3d(256)
        self.gen_bn2 = nn.BatchNorm3d(128)
        self.gen_bn3 = nn.BatchNorm3d(64)
        self.gen_bn4 = nn.BatchNorm3d(32)
        
    
    def forward(self, x, condition):
        
        condition_tensor = condition * torch.ones([x.shape[0],1], device=x.device)
        x = torch.cat([x, condition_tensor], dim=1)
        x = x.view(x.shape[0],self.noise_size,1,1,1)
        
        x = F.relu(self.gen_bn1(self.gen_conv1(x)))
        x = F.relu(self.gen_bn2(self.gen_conv2(x)))
        x = F.relu(self.gen_bn3(self.gen_conv3(x)))
        x = F.relu(self.gen_bn4(self.gen_conv4(x)))
        x = self.gen_conv5(x)
        x = torch.sigmoid(x)
        
        return x.squeeze()

class Generator64(nn.Module):
    def __init__(self, noise_size=201, cube_resolution=32):
        super(Generator64, self).__init__()
        self.noise_size = noise_size
        m = 4

        self.gen_conv1 = nn.ConvTranspose3d(self.noise_size, 256 * m, kernel_size=4, stride=2, padding=1)
        self.gen_conv2 = nn.ConvTranspose3d(256 * m, 128 * m, kernel_size=4, stride=2, padding=1)
        self.gen_conv3 = nn.ConvTranspose3d(128 * m, 64 * m, kernel_size=4, stride=2, padding=1)
        self.gen_conv4 = nn.ConvTranspose3d(64 * m, 32 * m, kernel_size=4, stride=2, padding=1)
        self.gen_conv5 = nn.ConvTranspose3d(32 * m, 16 * m, kernel_size=4, stride=2, padding=1)
        self.gen_conv6 = nn.ConvTranspose3d(16 * m, 1, kernel_size=4, stride=2, padding=1)

        self.gen_bn1 = nn.BatchNorm3d(256 * m)
        self.gen_bn2 = nn.BatchNorm3d(128 * m)
        self.gen_bn3 = nn.BatchNorm3d(64 * m)
        self.gen_bn4 = nn.BatchNorm3d(32 * m)
        self.gen_bn5 = nn.BatchNorm3d(16 * m)
        
        
        self.skip1_4 = nn.Conv3d( 256 * m, 32 * m,kernel_size=1, stride=1)
        # self.skip1_5 = nn.Conv3d( 256 * m, 16 * m,kernel_size=1, stride=1)
        self.skip2_5 = nn.Conv3d( 128 * m, 16 * m,kernel_size=1, stride=1)
    
    def forward(self, x, condition):
        condition_tensor = condition * torch.ones([x.shape[0], 1], device=x.device)
        x = torch.cat([x, condition_tensor], dim=1)
        x = x.view(x.shape[0], self.noise_size, 1, 1, 1)

        out1 = F.relu(self.gen_bn1(self.gen_conv1(x)))
        out2 = F.relu(self.gen_bn2(self.gen_conv2(out1)))
        out3 = F.relu(self.gen_bn3(self.gen_conv3(out2)))
        out4 = F.relu(self.gen_bn4(self.gen_conv4(out3)))
        out5 = F.relu(self.gen_bn5(self.gen_conv5(out4)))
        
        # make the number of channels equal
        
        skip1_4 = self.skip1_4(out1)
        # skip1_5 = self.skip1_5(out1)
        skip2_5 = self.skip2_5(out2)
        
        
        # Upsample and adjust dimensions for skip connections
        out2_up = F.interpolate(skip2_5, size=out5.shape[2:], mode='trilinear', align_corners=True)
        out1_up = F.interpolate(skip1_4, size=out4.shape[2:], mode='trilinear', align_corners=True)
        # out1_up = F.interpolate(skip1_5, size=out5.shape[2:], mode='trilinear', align_corners=True)
        
        # Skip connections
        out5 = out5 + out2_up  # Adjust dimensions
        out4 = out4 + out1_up # Adjust dimensions
        
        x = self.gen_conv6(out5)
        x = torch.sigmoid(x)
        
        return x.squeeze()
