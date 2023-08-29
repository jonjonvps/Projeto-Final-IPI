% Trabalho Final de INTRODUCAO AO PROCESSAMENTO DE IMAGENS - Turma 01 - 2023/1
% Alunos:
%         João Victor Pinheiro de Souza - 180103407
%         Ândrey Galvão Mendes - 180097911

clear all
close all
clc

I = imread('caterpilar_eggs.png');
#figure; imshow(I,[]);

I = imcrop(I,[33 45 200 150]);
figure; imshow(I,[]);

Ihsv = rgb2hsv(I);
##figure; imshow(Ihsv,[]);

Ivalue = Ihsv(:,:,3);
##figure; imshow(Ivalue,[]);


Igray = mat2gray(Ivalue);
#figure; imshow(Igray, []);
IT = Igray;
Ieq = histeq(Igray);
#figure; imshow(Ieq, []);

Ifil = imadjust(Ieq, [], [], 5); %era 5
#figure; imshow(Ifil, []);

elemento_estruturante = strel('disk', 10, 0);
Ibw = imtophat(Ifil, elemento_estruturante);
Ibw2=Ibw;
figure; imshow(Ibw, []);

t = graythresh(Ieq);
Ibweq = im2bw(Ieq, t);
##Ibw = Igray > 1;
#figure; imshow(Ibweq, []);

t = graythresh(Ibw);
Ibw = im2bw(Ibw, t);
#Ibw = Igray > 1;
figure; imshow(Ibw, []);

#################################################
% PARTE QUE VAI PEGAR O MACADOR INTERNO 
% Transformação de Distância de Imagem Binária
D = bwdist(~Ibw);
figure;imshow(D,[]);

% Essa operação resulta em uma imagem em que os valores dos pixels são invertidos
D = 255-uint8(D)
#D = -D;
#figure;imshow(D,[]);

# produz pequenos pontos que estão aproximadamente no meio dos Ovos a serem segmentadas
mask = imextendedmin(D,1);
figure; imshowpair(Ibw,mask,'blend')
#################################################
D = bwdist(Ibw);
#D = 255-uint8(D)

DL = watershed(D);
figure;imshow(DL)
title("DL")

bgm = DL == 0;
figure;imshow(bgm)
title("Watershed Ridge Lines")

DL(~Ibw) = 0;
figure;imshow(DL)
title("ws")

Igray2 = Igray;
Igray2(bgm)=0;
figure;imshow(Igray2,[]);

L2 = DL;

###########################################3
Igray=Ibw2;

gmag = imgradient(Igray);
figure;imshow(gmag);

# Pegando o Minimo Local da imagem
gmag2 = imimposemin(gmag, bgm| mask);
figure;imshow(gmag2);

L = watershed(gmag2);
figure;imshow(L==0);

% Converter a imagem original para RGB
redChannel = L2; 
greenChannel = L2; 
redChannel(~L) = 255;
greenChannel(~L) = 0;
rgbImage = cat(3, redChannel, greenChannel, greenChannel);
figure; imshow(rgbImage);
