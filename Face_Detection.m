clear all; close all; clc;

%%Chargement de la photo
face_original = imread('imageTest.JPG');
size_img = size(face_original);
r = 1; g = 2; b = 3;
y = 1; u = 2; v = 3;
%%Conversion en mode YUV
face_yuv = face_original;
for i = 1:size_img(1)
    for j = 1:size_img(2)
        face_yuv(i, j, y) = (face_original(i, j, r) + 2*face_original(i, j, g) + face_original(i, j, b)) / 4;
        face_yuv(i, j, u) = face_original(i, j, r) - face_original(i, j, g);
        face_yuv(i, j, v) = face_original(i, j, b) - face_original(i, j, g);
    end
end
% imshow(face_yuv);
%%Segmentation de la peau
face_detected = face_original;
for i = 1:size_img(1)
    for j = 1:size_img(2)
        %Cette condition est bas'e9e sur des 'e9tudes...
        if face_yuv(i, j, u) > 30 && face_yuv(i, j, u) < 74
            %On met tous les pixels ayant cette valeur en blanc 
            face_detected(i, j, r) = 255;
            face_detected(i, j, g) = 255;
            face_detected(i, j, b) = 255;
        else
            %Le reste en noir
            face_detected(i, j, r) = 0;
            face_detected(i, j, g) = 0;
            face_detected(i, j, b) = 0;
        end
    end
end
%%Converssion de l'image en binaire
face_detected = im2bw(face_detected);
%%Erosion des pixels
face_imerode = imerode(face_detected, strel('square', 3));
%%Dillatation des pixels
face_imfill = imfill(face_imerode, 'holes');
%%Lab'e9lisation des pixels conn'e9ct'e9s pour cr'e9er des r'e9gions
[L, n] = bwlabel(face_imfill);
face_region = regionprops(L, 'Area', 'BoundingBox');
face_area = [face_region.Area]; %Calcul de la surface de chaque r'e9gion
%%Selon des 'e9tudes si une r'e9gions d'e9passe 26% de la surface totale alors la r'e9gion est une visage humain 
face_idx = find(face_area > (.26)*max(face_area)); %only shows indices of regions that are faces
face_shown = ismember(L, face_idx);
%%On d'e9sine une boxe autour du visage
 
% fprintf('Ratio between face area and box area n');
% for n = 1:length(face_idx)
%     idx = face_idx(n);
%     area_face(n) = face_region(idx).Area;
%     area_box(n) = face_region(idx).BoundingBox(3)*face_region(idx).BoundingBox(4);
%     ratio(n) = area_face/area_box;
% end
%ratio
%%On trouve les coordonn'e9es de la r'e9gions  
for n = 1:length(face_idx)
    idx = face_idx(n);
    face_region(idx).BoundingBox;
    xmin = round(face_region(idx).BoundingBox(1));
    ymin = round(face_region(idx).BoundingBox(2));
    xmax = round(face_region(idx).BoundingBox(1)+face_region(idx).BoundingBox(3));
    ymax = round(face_region(idx).BoundingBox(2)+face_region(idx).BoundingBox(4));
    for i = xmin:xmax
        face_original(ymin, i, r) = 255;
        face_original(ymin, i, g) = 0;
        face_original(ymin, i, b) = 0;
    end
    
    for i = xmin:xmax
        face_original(ymax, i, r) = 255;
        face_original(ymax, i, g) = 0;
        face_original(ymax, i, b) = 0;
    end
    
    for j = ymin:ymax
        face_original(j, xmin, r) = 255;
        face_original(j, xmin, g) = 0;
        face_original(j, xmin, b) = 0;
    end
    
    for j = ymin:ymax
        face_original(j, xmax, r) = 255;
        face_original(j, xmax, g) = 0;
        face_original(j, xmax, b) = 0;
    end
end
%%On retrouve la centro'efde 
s  = regionprops(face_shown, 'Centroid');
centroids = cat(1, s.Centroid); %cat puts all the s.Centroid values into a matrix
Xplot = centroids(:,1);   
Yplot = centroids(:,2);
figure,
imshow(face_yuv);%title('face_yuv','Location','southwest');
imshow(face_detected);%title('face_detected','Location','southwest');
imshow(face_imerode);%title('face_imerode','Location','southwest');
imshow(face_imfill);%title('face_imfill','Location','southwest');
imshow(face_original);%title('face_original','Location','southwest');
hold on;
plot(Xplot, Yplot, 'b*', 'MarkerSize', 10);hold on; 