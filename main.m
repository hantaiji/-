img_count=1;
for I=1:img_count
    %������ת��������ת�����㣬��ֱ���룬������
    my_seg(I);
    for J=1:2
        rotated_img=my_rotate(I,J);
        imwrite(rotated_img, strcat('footIR_',num2str(I),'��ת��ĵ�',num2str(J), '��ͼ','.png')); %����ÿ����ת���ͼ��
    end
    my_analysis(I);
end