%% DEMO 14:  Playing with offsets
%
%
% In this demo we show how to change offsets to either the image or the
% detector, and the flexibility of it.
% 
% 
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% This file is part of the TIGRE Toolbox
% 
% Copyright (c) 2015, University of Bath and 
%                     CERN-European Organization for Nuclear Research
%                     All rights reserved.
%
% License:            Open Source under BSD. 
%                     See the full license at
%                     https://github.com/CERN/TIGRE/blob/master/LICENSE
%
% Contact:            tigre.toolbox@gmail.com
% Codes:              https://github.com/CERN/TIGRE/
% Coded by:           Ander Biguri 
%--------------------------------------------------------------------------
%% Initialize
clear;
close all;

%% Define Geometry
geo=defaultGeometry('nVoxel',[128;128;128]);                     

% Offsets
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Lets try simnple offset: The detector gets completelly displaced
geo.offOrigin =[0;0;0];                     % Offset of image from origin   (mm)              
geo.offDetector=[200; 200];                     % Offset of Detector            (mm)
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Auxiliary 
geo.accuracy=0.5;                           % Accuracy of FWD proj          (vx/sample)

%% Load data and generate projections 
% see previous demo for explanation
angles=linspace(0,2*pi,100);
head=headPhantom(geo.nVoxel);
projections=Ax(head,geo,angles,'interpolated');


%% lets see it
plotProj(projections,angles);

%% we will skip reconstruction of this tests because the image is outside the detector


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Second test: lets test variying offsets:

geo.offDetector=[10*sin(angles); 20*cos(angles)];                     % Offset of Detector            (mm)
projections2=Ax(head,geo,angles,'interpolated');
%% lets see it
plotProj(projections2,angles);
%% reconstruction
res=SART(projections2,geo,angles,10);
plotImg(res,'Dim',3);

%% Third test: lets vary everything

% Lets make the image smaller
geo.nVoxel=[128;128;128];                   % number of voxels              (vx)
geo.sVoxel=[256;256;256]/2;                   % total size of the image       (mm)
geo.dVoxel=geo.sVoxel./geo.nVoxel;          % size of each voxel            (mm)

geo.offDetector=[10*sin(angles); 10*cos(angles)];                     % Offset of Detector            (mm)
geo.offOrigin =[40*sin(angles);linspace(-30,30,100);40*cos(angles)];                     % Offset of image from origin   (mm)              

projections3=Ax(head,geo,angles,'interpolated');
%% lets see it
plotProj(projections3,angles);
%% reconstruction
res=SART(projections3,geo,angles,10,'OrderStrategy','ordered');
plotImg(res,'Dim',3);
