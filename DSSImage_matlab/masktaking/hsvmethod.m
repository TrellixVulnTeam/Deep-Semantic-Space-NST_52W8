clc;
clear all;
I=im2double(imread('16.0.jpg'));%��ȡͼ��

Ihsv=rgb2hsv(I);
h=Ihsv(:,:,1);
s=Ihsv(:,:,2);
v=Ihsv(:,:,3);
[m,n]=size(h);


senh=zeros(m,n);
a1=1.0;
a=1.5;
b=1.5;
a2=1.2;
% for i=1:m
%     for j=1:n    
%         if(s(i,j)<=0.25)
%             senh(i,j)=log(1+s(i,j))*a1;
%         elseif(s(i,j)<=0.5&&s(i,j)>0.25)
%             senh(i,j)=log(1+s(i,j))*a;
%         elseif(s(i,j)<=0.75&&s(i,j)>0.5)
%             senh(i,j)=log(1+s(i,j))*b;            
%         elseif(s(i,j)>0.75)
%             senh(i,j)=log(1+s(i,j))*a2;           
%         end
%     end
% end
for i=1:m
    for j=1:n    
        if(s(i,j)<=0.2)
            senh(i,j)=log(1+s(i,j))*a1;
        elseif(s(i,j)<=0.5&&s(i,j)>0.2)
            senh(i,j)=log(1+0.2)*a1+log(1+s(i,j)-0.2)*a;
        elseif(s(i,j)<=0.75&&s(i,j)>0.5)
            senh(i,j)=log(1+0.2)*a1+log(1+0.5-0.2)*a+log(1+s(i,j)-0.5)*b;            
        elseif(s(i,j)>0.75)
            senh(i,j)=log(1+0.2)*a1+log(1+0.5-0.2)*a+log(1+0.75-0.5)*b+log(1+s(i,j)-0.75)*a2;           
        end
    end
end
  
Ihsv(:,:,2)=senh;
%Ihsv(:,:,2)=s;
hh=min([m n]);
sigma0=2;
sigma1=5;%double(uint8(h*0.03));%С�ߴ�Ϊͼ���С��3%
sigma2=70;%double(uint8(h*0.13));%�гߴ�Ϊͼ���С��13%
sigma3=140;%double(uint8(h*0.40));%��ߴ�Ϊͼ���С��40%
%sigma1=5;%
%sigma1=double(uint8(h*0.0002));%С�ߴ�Ϊͼ���С��3%
%sigma2=40;%
%sigma2=double(uint8(h*0.002));%�гߴ�Ϊͼ���С��13%
%sigma3=240;%
%sigma3=double(uint8(h*0.006));%��ߴ�Ϊͼ���С��40%
aa=3;%��ɫ�ظ�ϵ��
%%%%%%%%%%%%%%%%%%%%���ɸ�˹ģ��%%%%%%%%%%%%%%%%
F0=fspecial('gaussian',[3*sigma0,3*sigma0],sigma0);%С�ߴ�ģ��
F1=fspecial('gaussian',[3*sigma1,3*sigma1],sigma1);%С�ߴ�ģ��
F2=fspecial('gaussian',[3*sigma2,3*sigma2],sigma2);%�гߴ�ģ��
F3=fspecial('gaussian',[3*sigma3,3*sigma3],sigma3);%��ߴ�ģ��
%%%%%%%%%%%%%%%%%%%%����Rͨ��%%%%%%%%%%%%%%%%%%%
L1=imfilter(v,F1,'replicate','conv');%������˹ģ��ֱ���Rͨ�����
L2=imfilter(v,F2,'replicate','conv');
L3=imfilter(v,F3,'replicate','conv');

mi=min(min(L3));
ma=max(max(L3));


%G=part1*(log(v+ones(m,n))-log(L1+ones(m,n)))+part2*(log(v+ones(m,n))-log(L2+ones(m,n)))+part3*(log(v+ones(m,n))-log(L3+ones(m,n)));
for i=1:m
    for j=1:n      
        
        part1=3/9;
part2=3/9;
part3=3/9;
L02(i,j)=(L2(i,j)-mi)/(ma-mi)*(0.45-0.1)+0.1;%ֱ�ӶԱȶ�����
L12(i,j)=(L1(i,j)-mi)/(ma-mi)*(0.45-0.1)+0.1;%ֱ�ӶԱȶ�����
L22(i,j)=(L2(i,j)-mi)/(ma-mi)*(0.5-0.3)+0.3;%ֱ�ӶԱȶ�����
L32(i,j)=(L3(i,j)-mi)/(ma-mi)*(0.8-0.4)+0.4;%ֱ�ӶԱȶ�����

       G(i,j)=part1*(log(v(i,j)+1)-log(L12(i,j)+1));%���߶ȼ�Ȩ��������ɫ�ָ�
        G(i,j)=part2*(log(v(i,j)+1)-log(L22(i,j)+1))+G(i,j);
         G(i,j)=(part3*(log(v(i,j)+1)-log(L32(i,j)+1))+G(i,j));
if(h(i,j)==0)
    
end

%        part1=4/7;
%          part2=2/7;
%         part3=1/7;
%                 G(i,j)=part1*(log(v(i,j)+0.001)-log(L1(i,j)+0.001));%���߶ȼ�Ȩ��������ɫ�ָ�
%         G(i,j)=part2*(log(v(i,j)+0.001)-log(L2(i,j)+0.001))+G(i,j);
%          G(i,j)=(part3*(log(v(i,j)+0.001)-log(L3(i,j)+0.001))+G(i,j));
%          
%          Rrr(i,j)=exp(G(i,j));%�Ӷ�����ָ���������(���ع��̫������)
    end
end

u=mean2(G);%����ͼ��ľ�ֵ,����,��Сֵ�����ֵ
s=std2(G);
mi=min(min(G));
ma=max(max(G));
Rr=(G-mi)/(ma-mi)*1.3;%ֱ�ӶԱȶ�����
% if(max(Rr(:))<0.1)
%     part1=2/7;
% part2=2/7;
% part3=3/7;
%    G=part1*(log(v+ones(m,n))-log(L1+ones(m,n)))+part2*(log(v+ones(m,n))-log(L2+ones(m,n)))+part3*(log(v+ones(m,n))-log(L3+ones(m,n)));
%     u=mean2(G);%����ͼ��ľ�ֵ,����,��Сֵ�����ֵ
%      s=std2(G);
%     mi=min(min(G));
%     Rr=(G-mi)/(ma-mi);%ֱ�ӶԱȶ�����
% end

Ihsv(:,:,3)=Rr;%0.00001��Rrr��1��Rr
I2=hsv2rgb(Ihsv);
subplot(1,2,1);imshow(I);
subplot(1,2,2);imshow(I2);