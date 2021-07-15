%求每个门限上下的采样点的方差以寻找最佳判决点（即方差最大的一组，眼图中眼开的最大的点）

function  variance=variance_calcualtion(Array,threshold)
    for i =1:length(threshold)
        if i==1
            subA=Array(Array>threshold(i+1));      
            error = subA - threshold(i);
            mse(i) =  mean(error.^2);
        else if i==length(threshold)
                subA=Array(Array<threshold(i-1));      
                error = subA - threshold(i);
                mse(i) =  mean(error.^2);
            else
                subA=Array((Array<threshold(i-1))&(Array>threshold(i+1)));
                error = subA - threshold(i);
                mse(i) =  mean(error.^2);
            end
        end
    end
    variance=mean(mse);









