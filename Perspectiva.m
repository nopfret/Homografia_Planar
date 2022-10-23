%% Limpando 
clc
clear all
close all

%% lendo video // imagens

video = VideoReader('ck.avi');
I = imread('outdoor.jpg');
I = rgb2lab(I);
%% Removendo fundo outdor

%imshow(I)
%[u,v] =ginput(1)
u = 335;
v = 233;

rf = I(v,u,1);
gf = I(v,u,2);
bf = I(v,u,3);

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

D = sqrt((R-rf).^2 + (G-gf).^2 + (B-bf).^2);

L = 3.75;
M = D < L;
M = (M-1).^2;
outdor = I .* M;
outdor = lab2rgb(outdor);

%% Video em perspect

%video
frame = read(video,70);
U = [0;1289;1280;0]; V = [0;0;720;720];
%outdor
%U1 = [131;520;535;121]; V1 = [65;161;;261;326];
U1 = [129;523;535;130]; V1 = [65;170;375;315];
%processando os dados

A = [ 
    U(1,1) V(1,1) 1 0 0 0 -U1(1,1)*U(1,1) -U1(1,1)*V(1,1);
    0 0 0 U(1,1) V(1,1) 1 -V1(1,1)*U(1,1) -V1(1,1)*U(1,1);
    
    U(2,1) V(2,1) 1 0 0 0 -U1(2,1)*U(2,1) -U1(2,1)*V(2,1);
    0 0 0 U(2,1) V(2,1) 1 -V1(2,1)*U(2,1) -V1(2,1)*U(2,1);
    
    U(3,1) V(3,1) 1 0 0 0 -U1(3,1)*U(3,1) -U1(3,1)*V(3,1);
    0 0 0 U(3,1) V(3,1) 1 -V1(3,1)*U(3,1) -V1(3,1)*U(3,1);
    
    U(4,1) V(4,1) 1 0 0 0 -U1(4,1)*U(4,1) -U1(4,1)*V(4,1);
    0 0 0 U(4,1) V(4,1) 1 -V1(4,1)*U(4,1) -V1(4,1)*U(4,1)
]

b = [U1(1,1) V1(1,1) U1(2,1) V1(2,1) U1(3,1) V1(3,1) U1(4,1) V1(4,1)]
h1 = inv(A)*b.'

h = [
h1(1,1) h1(2,1) h1(3,1);
h1(4,1) h1(5,1) h1(6,1);
h1(7,1) h1(8,1) 1;
]

tform  = projective2d(h.');
[I2,ref] = imwarp(frame,tform);
I2 = double(I2)/255;

teste = ones(size(outdor));

y = 65;
x = 129;


for i = 1:size(I2,1)
    for j = 1:size(I2,2)
   outdor(i+y,j+x,:) =  outdor(i+y,j+x,:)+I2(i,j,:);
    end
end

imshow(outdor)
   














