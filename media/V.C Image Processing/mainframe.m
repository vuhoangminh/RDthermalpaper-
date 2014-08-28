% Remove bad edges and improve corner detection

%% 

% Clear all data and screen
clc;
clear all;
close all;

% tic;
% Import parameters from parameters.txt
dataList = importdata('parameters.txt');
[nRow,nColumn]=size(dataList.data);
cellParameters=cell(nRow,2);

for iRow=1:nRow
    cellParameters{iRow,1}=dataList.textdata(iRow,1);
    for iColumn=1:nColumn
        if ~isnan(dataList.data(iRow,iColumn))
            cellParameters{iRow,2}=dataList.data(iRow,iColumn);
        end
    end
end

% Input from user
highOrlow=input('High or Low: ');
frameNumber=input('Enter frame: ');
% algorithm_num=input('Enter number of parts: ');

if highOrlow==1
    sourceFile = dir('D:\Master\Master programming\My codes\Dataset\test_seq_001\*.png'); 
	fileName = strcat('D:\Master\Master programming\My codes\Dataset\test_seq_001\',sourceFile(frameNumber).name);
else
    sourceFile = dir('D:\Master\Master programming\My codes\Dataset\low_snr\*.png');  
	fileName = strcat('D:\Master\Master programming\My codes\Dataset\low_snr\',sourceFile(frameNumber).name);
end    

%% 

% Process image
originalImage = imread(fileName);
grayImage = mat2gray(originalImage);
scaleImage = imadjust(grayImage,stretchlim(grayImage),[]);

% clear variables
clear iRow iColumn sourceFile fileName;

%       Input :
%       I -  the input image, it could be gray, color or binary image. If I is
%           empty([]), input image can be get from a open file dialog box.
%       C -  denotes the minimum ratio of major axis to minor axis of an ellipse, 
%           whose vertex could be detected as a corner by proposed detector.  
%           The default value is 1.5.
%       T_ANGLE -  denotes the maximum obtuse angle that a corner can have when 
%           it is detected as a true corner, default value is 162.
%       CORNER_GAUSSIAN_SIGMA -  denotes the standard deviation of the Gaussian filter when
%           computing curvature. The default CORNER_GAUSSIAN_SIGMA is 3.
%       CANNY_HIGH_THRESHOLD,CANNY_LOW_THRESHOLD -  high and low threshold of Canny edge detector. The default value
%           is 0.35 and 0.
%       isEndpointIsCorner -  a flag to control whether add the end points of an edge
%           as corner, 1 means Yes and 0 means No. The default value is 1.
%       GAP_SIZE -  a paremeter use to fill the gaps in the contours, the gap
%           not more than gap_size were filled in this stage. The default 
%           GAP_SIZE is 1 pixels.
%       OPEN_SIZE -  removes from an edge map all connected components 
%			(objects) that have fewer than OPEN_SIZE pixels

%	Para=[1.5,162,3,0.1,0,1,1,50];
% C=1.5;
% T_ANGLE=162;
% CORNER_GAUSSIAN_SIGMA=3;
% CANNY_HIGH_THRESHOLD=0.001;
% CANNY_LOW_THRESHOLD=0;
% isEndpointIsCorner=1;
% GAP_SIZE=1;
% OPEN_SIZE=50;



%% 

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%% Original image %%%%%%%%%%%%%%%%%%%%%
% [corner_index_ori,marked_img_ori,edge_map_ori,curve_ori]=curvaturecorner(scaleImage,cellParameters);
% 
% figure;
% imshow(edge_map_ori);
% s=sprintf('Edge map (frame %i)',frameNumber);
% title(s);
% 
% figure;
% imshow(marked_img_ori);
% s=sprintf('Feature points (frame %i)',frameNumber);
% title(s);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% State-of-the-art denoising filter %%%%%%%%%%%%%%%%%%%%%
DENOISE_GAUSSIAN_SIGMA=parseparameter(cellParameters,'DENOISE_GAUSSIAN_SIGMA');
% Denoise 'original image'. The denoised image is 'y_est', and 'NA = 1' because 
%  the true image was not provided
tic;
[NA, denoisedImage] = BM3D(1, scaleImage, DENOISE_GAUSSIAN_SIGMA); 
denoise=toc

% tic;
% [corner_index_de,marked_img_de,edge_map_de,curve_de]=curvaturecorner(denoisedImage,cellParameters);
% corner=toc
% figure;
% imshow(edge_map_de);
% s=sprintf('Edge map after being denoised (frame %i)',frameNumber);
% title(s);
% 
% figure;
% imshow(marked_img_de);
% s=sprintf('Feature points (frame %i)',frameNumber);
% title(s);

% time=toc



nonlocalImage = nonlocalmeans(scaleImage,5,3,0.15);
