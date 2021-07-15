
%%
%生成写入比特流文件
%%test_bit
clear
n=5;
Nbaud=250;
unitbs=nrPRBS(2^30,[10,Nbaud*n])';%start from 10,length=1000
unitbs=reshape(unitbs,floor(length(unitbs)/Nbaud),Nbaud);
unitbs=unitbs'*(2.^(n-1:-1:0))';%0 1 2 3
scale=(2^n-1)/2;
unitbs=(unitbs-scale)/scale;%-1,-1/3,1/3,1
%[7 5 3 1 -1 -3 -5 -7]/7
unit=repmat(unitbs',floor(2^15/Nbaud),1);%每个波特多少个采样点
bitstream=reshape(unit,numel(unit),1);
%write to file
fid=fopen(['D:\document\Research\水下光通信\mfile\communication\AWG_250bit_PAM' num2str(2^n) '_.csv'],'wt');
for k=1:size(bitstream,1)
    fprintf(fid,'%.4f\n',bitstream(k));
end
fclose(fid);
