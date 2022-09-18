clc;clear;close all
% Config
filename = 'KT.jpg'; % lena_std.tif dog.png
I = imread(filename);
G = rgb2gray(I);
[rowI, colI, ~] = size(I);
Save = 0;