function [uint_analyzed_img,average,min,max]=my_analysis(analysis_i)%�˴�������Ҫ����
analysis_r=strcat('./footIR_',num2str(analysis_i),'��ת��ĵ�1��ͼ','.png');
analysis_l=strcat('./footIR_',num2str(analysis_i),'��ת��ĵ�2��ͼ','.png');
right_analy_img=double(imread(analysis_r));
left_analy_img=double(imread(analysis_l));
left_analy_img=flip(left_analy_img,2);%����ת
stat_r = regionprops(right_analy_img,'centroid');
stat_l = regionprops(left_analy_img,'centroid');
right_cen=[stat_r(1).Centroid(1),stat_r(1).Centroid(2)];
left_cen=[stat_l(1).Centroid(1),stat_l(1).Centroid(2)];
%�ҡ������������꣬x�����У�y������
a=right_cen(1);
b=right_cen(2);
p=left_cen(1);
q=left_cen(2);
analyzed_img=zeros(1,1);
k=0;analy_sum=0;
min.value=255;min.x=0;min.y=0;
max.value=-255;max.x=0;max.y=0;
for i=1:156
    for j=1:100
        if left_analy_img(floor(q)-78+i,floor(p)-50+j)==0||right_analy_img(floor(b)-78+i,floor(a)-50+j)==0
            %�������Ӧ�㣬����һ��Ϊ�㣬��������ͼ��õ�Ϊ�㣬������ȥ��Χ���������Լ�����֮���޷���Ӧ�ϵ����������
            analyzed_img(i,j)=0;
        else
            analyzed_img(i,j)=left_analy_img(floor(q)-78+i,floor(p)-50+j)-right_analy_img(floor(b)-78+i,floor(a)-50+j);
            analy_sum=analy_sum+analyzed_img(i,j);k=k+1;%���ڼ���ƽ���¶Ȳ�
            if analyzed_img(i,j)<min.value
                min.value=analyzed_img(i,j);
                min.x=i;min.y=j;%�����е�x�е�y�У���ͼʱ�൱�ڣ�y,x)��
            end  
            if analyzed_img(i,j)>max.value
                max.value=analyzed_img(i,j);
                max.x=i;max.y=j;
            end 
        end

    end
end
mat_analyzed_img=mat2gray(analyzed_img);
uint_analyzed_img=uint8(analyzed_img);%doubleתuint8
imwrite(uint_analyzed_img, strcat('footIR_',num2str(analysis_i),'���ԳƷ������ͼ��.png'));
%�����png��ʽ����matlab���ĵ�ǰ�ļ��п�����Ҫ��figure�������Ƶ��Լ�windows��Ƭչʾ��Ҫ��һ�㣬������uint8��ʽ������mat2gray��ʽ
% figure(1)
% subplot(2,1,1);
% imshow(left_analy_img);
% subplot(2,1,2);
average=analy_sum/k;
figure(1);
subplot(2,1,1);
imshow(mat_analyzed_img);
hold on;
plot(min.y,min.x,'ro');%��ͼ���עʱ��һά�൱�ھ����е��У��ڶ�ά�൱����
plot(max.y,max.x,'ro');
subplot(2,1,2);
imshow(uint_analyzed_img);
hold on;
plot(min.y,min.x,'ro');%��ͼ���עʱ��һά�൱�ھ����е��У��ڶ�ά�൱����
plot(max.y,max.x,'ro');
end