function [rotate_un_img,MIN,MAX,average]=my_rotate(rotate_i,rotate_j)
%ROTATE Rotate the clipped grayscale image of the foot
% 
rotate_a=strcat('./footIR_',num2str(rotate_i),'��',num2str(rotate_j), '��ͼ','.png');
cutted_img=imread(rotate_a);
% figure(5);
% subplot(1,3,1);
% imshow(cutted_img);
%%
immax=-255;immin=255;rotate_k=0;rotate_sum=0;
[M, N, C] = size(cutted_img); %��ȡͼ��Ĵ�С
for i = 1:M
    for j = 1:N
        if cutted_img(i,j)~=0
            rotate_sum=rotate_sum+double(cutted_img(i,j));rotate_k=rotate_k+1;%���ڼ���ƽ���¶Ȳ�
            if cutted_img(i,j)>immax
                immax=cutted_img(i,j);
            end
            if cutted_img(i,j)<immin
                immin=cutted_img(i,j);
            end
        end
    end
end
[miny,minx]=find(cutted_img==immin);
MIN=[miny,minx];
[maxy,maxx]=find(cutted_img==immax);
MAX=[maxy,maxx];
average=rotate_sum/rotate_k;
%%
cutted_Ibw = imbinarize(cutted_img,0.1);%ת��ֵͼ��(Ҫ����level)
% subplot(1,3,2);
% imshow(cutted_Ibw);
stat = regionprops(cutted_Ibw,'centroid');

hold on;
for x = 1: numel(stat)
    plot(stat(x).Centroid(1),stat(x).Centroid(2),'ro');
end
%cen_x=floor(stat(1).Centroid(1));%���� x��������ȡ�����ھ���ͼ������������
cen_y=floor(stat(1).Centroid(2));%���� y��������ȡ�����ھ���ͼ������������
row_codi=cen_y;%�� ��124�У���67�������ģ�
begin=zeros(1,1);%�洢������߽磨1�������Ĵ�С��
terminate=zeros(1,1);%�洢�����ұ߽�
k=1;

%%
while(true)

    %�жϸ����Ƿ�ȫ��Ϊ�㣬���ǣ��˳�ѭ��
    if sum(cutted_img(row_codi,:))== 0
        break; 
    end 
    %��������
    for col_codi=1:129
        %Ϊ��߽磬��¼
        if cutted_img(row_codi,col_codi)==0&&cutted_img(row_codi,col_codi+1)~=0
            begin(k)=col_codi+1;
        else
            %Ϊ�ұ߽磬��¼����k++���Լ�¼��һ�еı߽�������
            if cutted_img(row_codi,col_codi)~=0&&cutted_img(row_codi,col_codi+1)==0
                terminate(k)=col_codi;k=k+1;  
            end
        end
    end
    %������һ��
    row_codi=row_codi+1;
end
%%
% x_size=size(begin);
x_fit=1:size(begin,2);%��ȡ����������Ϊ�������x��
t_b=(terminate-begin)/2+begin;%��ȡÿ�����ģ�����Ϊ�������y��
%(terminate-begin)/2+begin�����begin
line=polyfit(x_fit,t_b,1);%***���ʮ���������ܴ󣬿��������ȥ***
% subplot(1,3,3);
% plot(x_fit,t_b,'*',x_fit,polyval(line,x_fit));
fit_slope=line(1:1);%���б��
angle=atan(fit_slope);%����
anglout = rad2deg(angle);%�Ƕ�
rotate_un_img = imrotate(cutted_img,-anglout,'bilinear','crop');%imrotate�������������ǽǶȣ����ǻ��� 
%***��ת��ͼ������ն������ݻ�ʧ�棬��ô�����������5*5����ȣ���Ϊ���ԳƷ�������С��λ����С��
%�Ͼ��������Ѿ��޷�׼ȷ����ô��¶�ֵ������ȻĿ��ͼ��仯���󣬾�˵������㷨û�й���ı�õ㸽�����¶���Ϣ�����ǿ��������Ƚϵ�***%
% figure(6);
% imshow(rotate_un_img);
end