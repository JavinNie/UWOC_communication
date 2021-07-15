%%20210317
%%
%采样存储深度=采样率*时间
clear
tic

Scale=0.025;

% local=['D:\document\Research\水下光通信\mfile\communication\ACP21-07-04\pam4\'];
% seq=csvread([local '50M_15m_fresnel.csv'],2,0,'A3..B62502');
local='C:\Users\admin\Desktop\PAM_ACP\osc_data0705\pam4\';
fre=50;
% seq=csvread([local 'HighQ_30m_' num2str(fre) 'M_fresnel.csv'],2,0,'A3..B50002');
seq=csvread([local '25m_' num2str(fre) 'M_fresnel.csv'],2,0,'A3..B50002');
L=length(seq);
Ap=seq(1:L,2);
% plot(Ap,'.-')
%%
% Tinterval=(seq(end,1)-seq(1,1))/(length(seq(:,1))-1);
Tinterval=mean(diff(seq(:,1)));
Length=length(seq);

%%
%重采样AP
Fsend=fre/250*1e6;%frequency send :200k
k0=Length/(250*Fsend*Tinterval*Length);
%%
% %绘制眼图
interval=50;
if(abs(interval-k0*round(interval/k0))<1e-8)
    Apr=resample(Ap,round(interval/k0),1);
else
    k=interval/k0;
    str=rats(k);
    N1=str2double(str(1:find(str=='/')-1));
    N2=str2double(str(find(str=='/')+1:end));
    Apr=resample(Ap,N1,N2);
end

%%
%10m
ed = comm.EyeDiagram('SampleRate',interval/k0/Tinterval,'DisplayMode','2D color histogram', ...
    'YLimits',[-1 1]*Scale,'SampleOffset',5,'SymbolsPerTrace',2,'TracesToDisplay',1000000,...
   'SamplesPerSymbol',interval,'BERThreshold',1e-4);%'EnableMeasurements',true,
ed.OversamplingMethod = 'Input interpolation';
% reset(ed)
ed(Apr)


%%
%%------------------添加坐标轴属性
% % title('15m-clear','color','k','FontSize',28)
% xlabel('Time(2ns/div)');
% % ylabel('Amplitude(5mV/div)')
% ylabel('Amplitude(mV)','Color','k')
% set(gca,'FontName','Times New Roman','FontSize',28,'FontWeight','bold');
% % % % set(gca,'XTickLabel',[],'YTickLabel',[])
% set(gca,'XTickLabel',[])
% % set(gca,'YTickLabel',[-25 -20 -15 -10 -5 0 5 10 15 20 25]);
% set(gca,'xcolor','k');
% set(gca,'ycolor','k');
% set(gca,'gridcolor',[1 1 1]);
toc

