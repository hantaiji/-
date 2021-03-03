function []=my_seg(seg_i)
%
seg_code_a=strcat('./footIR_',num2str(seg_i), '.jpg');
img=imread(seg_code_a);
% figure(1);
% subplot(2,3,1);%��ƽ��λ�ô�����������2��3�е�һ��
% imshow(img);%չʾԭͼ
C = makecform('srgb2lab');       %����ת����ʽ
img_lab = applycform(img, C);
ab = double(img_lab(:,:,2:3));    %ȡ��lab�ռ��a������b����
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
 
nColors = 3;        %�ָ���������Ϊ3
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean','Replicates',3);  %�ظ�����3��
pixel_labels = reshape(cluster_idx,nrows,ncols);
% subplot(2,3,2);
% imshow(pixel_labels,[]), title('������');%չʾ������
 
 
%��ʾ�ָ��ĸ�����������Ҷ�ͼ
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);
 
for k = 1:nColors
    color = img;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end          
% subplot(2,3,3);
% imshow(segmented_images{1}), title('�ָ�����������1');
% subplot(2,3,4);
% imshow(segmented_images{2}), title('�ָ�����������2');
% subplot(2,3,5);
% imshow(segmented_images{3}), title('�ָ�����������3');
% subplot(2,3,6);
% imshow(rgb2gray(img));
%%
%�ӷ�������ȷ�����ͼ��
I_1=rgb2gray(segmented_images{1});
I_2=rgb2gray(segmented_images{2});
I_3=rgb2gray(segmented_images{3});
% figure(2);  
% subplot(1,3,1);
% imshow(I_1);
% subplot(1,3,2);
% imshow(I_2);
% subplot(1,3,3);
% imshow(I_3);

if sum(sum(I_1))<sum(sum(I_2))&&sum(sum(I_1))<sum(sum(I_3))
    I=I_1;
else
    if sum(sum(I_2))<sum(sum(I_3))
        I=I_2;
    else
        I=I_3;
    end
end 
%%
%��ʾ�ָ��ͼ��ת���ɻҶ�ͼ���ĻҶ�ֱ��ͼ
% hold on;
% figure(3);
% subplot(3,1,1);
% z=rgb2gray(segmented_images{1});
% imhist(z);
% subplot(3,1,2);
% z=rgb2gray(segmented_images{2});
% imhist(z);
% subplot(3,1,3);
% z=rgb2gray(segmented_images{3});
% imhist(z);
%%
%�����ͼ��ֳ�������������ͼ�������ں����ֱ���д�ֱ����
[M, N, C] = size(I); %��ȡͼ��Ĵ�С
m = M; %ÿ��Сͼ�ĳ�
n = N/2;%ÿ��Сͼ�Ŀ�
count = 1; %����
%rebulid = zeros(M, N, C); %������ԭͼ��С��ȫ��ͼ,����ͼ���ؽ�
%figure(3);
for i = 1:M/m
    for j = 1:N/n
        block = I((i-1)*m+1 : i*m, (j-1)*n+1 : j*n, :); %����Сͼ
        imwrite(block, strcat('footIR_',num2str(seg_i),'��',num2str(count), '��ͼ','.png')); %����ÿ��Сͼ
        %subplot(2,2,count),imshow(block),title(['footIR_',num2str(seg_i),'��',num2str(count),'��ͼ']); %��Сͼ��ʾ��һ��ͼ��
        count = count + 1; %������һ
%        rebuild((i-1)*m+1:i*m, (j-1)*n+1:j*n, :) = block; %�ؽ�ԭͼ
    end
end

%figure(4);imshow(rebuild); title('�ؽ�ԭͼ')%��ʾԭͼ

%%
%ȷ�����ͼ�����ĵ�
% figure(4);
% subplot(1,3,1);
% imshow(I);
% Ibw = imbinarize(I,0.1);%ת��ֵͼ��(Ҫ����level)
% subplot(1,3,2);
% imshow(Ibw);
% %Ilabel = bwlabel(Ibw);
% stat = regionprops(Ibw,'centroid');
% %subplot(1,3,2);
% %imshow(Ilabel);
% hold on;
% for x = 1: numel(stat)
%     plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
% end
%%
end