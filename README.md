# Multiple-view-car-localization
Code for paper "Vehicle Pose and Shape Estimation through Multiple Monocular Vision".

The pdf version of the paper can be download at https://arxiv.org/abs/1802.03515

## Brief introduction

In this paper, we present an accurate approach to estimate vehicles' pose and shape from off-board multiview images. The images are taken by monocular cameras and have small overlaps. We utilize state-of-the-art convolutional neural networks (CNNs) to extract vehicles' semantic keypoints and introduce a Cross Projection Optimization (CPO) method to estimate the 3D pose. During the iterative CPO process, an adaptive shape adjustment method named Hierarchical Wireframe Constraint (HWC) is implemented to estimate the shape. Our approach is evaluated under both simulated and real-world scenes for performance verification. It's shown that our algorithm outperforms other existing monocular and stereo methods for vehicles' pose and shape estimation. This approach provides a new and robust solution for off-board visual vehicle localization and tracking, which can be applied to massive surveillance camera networks for intelligent transportation.

## CNN and some experiment results

### The CNN architecture is designed as follow
![CNN](https://github.com/GilgameshD/Multiple-View-Car-Localization/blob/master/cnn.jpg)

### Some experiment results
![result](https://github.com/GilgameshD/Multiple-View-Car-Localization/blob/master/result.jpg)
