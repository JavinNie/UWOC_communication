%PAM4 反映射
%由波特流生成比特流序列
%输入波特流，阶数，阈值，输出波特流序列
%
function Bit_stream=Baud2bit(Array,order,threshold)
    if 2^order-1~=length(threshold)
        disp('wrong!B2B');
        return
    end
    for i =1:length(threshold)
        if i==1
            Array(Array>threshold(i+1))=2^order-1;
        else if i==length(threshold)
                Array(Array<threshold(i-1))=0;
            else
                Array((Array<threshold(i-1))&(Array>threshold(i)))=2^order-i;
            end
        end
    end
    temp=dec2bin(Array)';
    Bit_stream=str2num(temp(:));