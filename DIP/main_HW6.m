clc;clear;close all
% Interpolation
filename = 'lena_std.tif';
I = imread(filename);
Config;
G = rgb2gray(I);
[rowI, colI, ~] = size(I);

G2 = zeros(rowI*2, colI*2);
G2(1:2:2*rowI,1:2:2*colI) = double(G);
G2pad = padarray(G2,[1 1],0,'both');
f1 = [1 1 0 ; ...
    1 1 0 ; ...
    0 0 0 ];    %nn
f2 = [1 2 1 ; ...
    2 4 2 ; ...
    1 2 1 ]/4 ; %Bilinear
J = G2pad;
K = G2pad;

for ii = 2:(2*rowI+1)
    for jj = 2:(2*colI+1)
        J(ii,jj) = sum(sum(G2pad(ii-1:ii+1,jj-1:jj+1).*f1)) ;
        K(ii,jj) = sum(sum(G2pad(ii-1:ii+1,jj-1:jj+1).*f2)) ;
    end
end
J = uint8(J(2:end-1, 2:end-1));
K = uint8(K(2:end-1, 2:end-1));

MATLABI = imresize(I, 2);
MATLABG = imresize(G, 2);

%% Insert text
Fontsize = 100;
Jt = insertText(J,[1 1], 'NN', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
Kt = insertText(K,[1 1], 'Bilinear', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
MATLABIt = insertText(MATLABI ,[1 1], 'MATLAB', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);
MATLABGt = insertText(MATLABG ,[1 1], 'MATLAB', 'AnchorPoint', 'LeftTop', 'FontSize', Fontsize);

%% Visualize
figure('Name', 'NN interpolation');
fig1 = imshow(uint8(J));
fig1 = title('NN interpolation');

figure('Name', 'Bilinear interpolation');
fig2 = imshow(uint8(K));
fig2 = title('Bilinear interpolation');

figure();
fig3 = montage({Jt, Kt, MATLABIt, MATLABGt});
fig3 = title('NN  v.s. Bilinear (Interpolation)');

%% Save result
if ~exist('Save', 'var')
    Save = 0;
end

if Save
    HW = 'HW6';
    if ~exist(HW, 'dir')
        mkdir(HW)
    end
    saveas(fig1, fullfile(HW, 'result_NN.png'));
    saveas(fig2, fullfile(HW, 'result_Bilinear.png'));
    saveas(fig3, fullfile(HW, 'result.png'));
end