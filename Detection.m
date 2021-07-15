%从接收到的PAM信号中，解出各级判决门限
%输入波形和阶数
%返回2^n-1个门限值
%迭代生成
function threshold=Detection(Array,order)
    thres=mean(Array);
    if order==1
        threshold=thres;
        return  
    end
       
    AA=Array(Array>=thres);
    AB=Array(Array<=thres);
    
    %递归二分法求门限,输入，和序列，计数器；输出门限值
    thresA=Detection(AA,order-1);
    thresB=Detection(AB,order-1);
    threshold=[thresA,thres,thresB];




