%%20210704
%完成整个解码过程，并计算误码率
%njw

%%

tic
clear
%%
%-----------------------------接收数据加载---------------------------------
% local=['D:\document\Research\水下光通信\mfile\communication\ACP21-07-04\pam4\'];
% seq=csvread([local '100M_15m_clean.csv'],2,0,'A3..B62502');

local='D:\document\Research\水下光通信\mfile\communication\ACP21-07-04\PAM_ACP\pam4\';
% seq=csvread([local '20m_50M_clean.csv'],2,0,'A3..B62502');

fre=100;
% seq=csvread([local '25m_' num2str(fre) 'M_clean1.csv'],2,0,'A3..B50002');
seq=csvread([local '20m_' num2str(fre) 'M.csv'],2,0,'A3..B50002');

Array=seq(:,2);
Tinterval=mean(diff(seq(:,1)));
Length=length(Array);
%%
%--------------------------------信号源设置参数(手动)----------------------------
baud_per_pattern=250;
Fsend=fre/250*1e6;%frequency send :200k
order=2;%PAM 调制阶数

Ttotal=Tinterval*Length;
Npat=Fsend*Ttotal;%number of pattern
sample_per_baud=Length/(baud_per_pattern*Npat);%每个波特内的采样点数

%%
%后期将原始序列分组操作，以求减少积累误差

%----------------------------------信号采样处理----------------------------
%等间隔采样，然后硬判决，根据判决结果分组计算方差，以判决线
%1\二分法将轨道分组，并算出硬判决界限；2、等间隔采样，然后使用之前的硬判决门限将轨道分组,同样是二分法，计算方差，方差之和最小的就是最佳采样点。
%函数1，输入波形和轨道数，二分法求出各级判决门限；
%函数2，输入取样之后的波形和各级判决门限，按条件，依次求轨道及方差；求出方差均值

%----------根据采样后各级门限两旁的方差，寻找最佳采样点（最大方差）--------
threshold= Detection(Array,order);%返回2^n-1个门限值
for i=1:ceil(sample_per_baud)
    a=Array(round([i:sample_per_baud:end]));
    variance(i)=variance_calcualtion(a,threshold);
end
ind=find(variance==max(variance));
Bstream=Array(round([ind:sample_per_baud:end]));%按最佳采样点采样
if ind>sample_per_baud
    Bstream=[Array(1); Bstream];
    disp('sample again')
end
%----------------比特同步，自相关求峰值------------------------------------
%%
source_signal = load([local 'AWG_250bit_PAM4_.csv']);
T_sample=round(length(source_signal)/baud_per_pattern);
Bstream_source=source_signal(1:T_sample:end);
Bstream_source=repmat(Bstream_source,floor(Npat),1);
%维度矫正
Bstream=Bstream(1:length(Bstream_source));
for shift=1:baud_per_pattern
    Bstream_temp= circshift(Bstream,shift-1);
    R = corrcoef(Bstream_source,Bstream_temp);
    R_result(shift) = R(1,2);
end
Shift = find(R_result == max(max(R_result)));
Bstream_shift= circshift(Bstream,Shift-1);

%---------------------截尾，转成bit求比特误码率----------------------------
Bstream_shift=Bstream_shift(1:baud_per_pattern*(Npat-1));
Bit_stream_shift=Baud2bit(Bstream_shift,order,threshold);

Bstream_source=Bstream_source(1:baud_per_pattern*(Npat-1));
Threshold_source= Detection(Bstream_source,order);%返回2^n-1个门限值
Bit_stream_source=Baud2bit(Bstream_source,order,Threshold_source);

BER=sum(xor(Bit_stream_source,Bit_stream_shift))/length(Bit_stream_source)
