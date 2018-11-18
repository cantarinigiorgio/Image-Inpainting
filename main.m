clear all;
close all;

% imagefilename =input('Select image you want to inpaint: ');
% maskfilename  = input('Select mask : ');
% psz = input('Select patch size(odd scalar) : ');

% imagefilename = 'images/air1.png';
% maskfilename  = 'images/air2.png';
% psz = 9;
% 
% inpaintedImg = inpaint(imagefilename,maskfilename,psz);
% 
% imshow(uint8(inpaintedImg));
% imwrite(uint8(inpaintedImg),'images/air3.png')
% 

imagefilename = 'images/walk.png';
maskfilename  = 'images/walk2.png';
psz = 9;


inpaintedImg = inpaint(imagefilename,maskfilename,psz);
imshow(uint8(inpaintedImg));