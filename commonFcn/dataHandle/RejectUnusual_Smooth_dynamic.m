%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                           xyz
%                        2014.3.2
%              剔除动态数据的异常噪声，并将数据平滑
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% 输入
% old_data：原始数据。spanTime：平滑采样长度。maxAbsError：最大误差限（单位与输入数据一致）
%% 输出
% real_data：剔除异常后的数据，smooth_data：剔除异常后再进行平滑后的数据，std_str：各个数据的
% 为了简化处理，剔除掉野值后在原位置放入拟合之后的数据代替
function [smooth_data,real_data] = RejectUnusual_Smooth_dynamic( old_data,spanTime,maxAbsError )
%% 思路：
%（1）将数据最小二乘线性平滑
%（2）以平滑后的值为准确值，删去远离准确值超过 maxAbsError 的数据
%（3）再次对去除异常的数据进行最小二乘线性平滑
format long
%% （1）一次平滑
span = spanTime*100 ;
smooth_data = zeros(size(old_data));
tic
smooth_data(1,:) = smooth(old_data(1,:),span,'rlowess');
sprintf('第一次平滑处理的第1行结束：%0.2f  min\n',toc/60)
smooth_data(2,:) = smooth(old_data(2,:),span,'rlowess');
sprintf('第一次平滑处理的第2行结束：%0.2f  min\n',toc/60)
smooth_data(3,:) = smooth(old_data(3,:),span,'rlowess');
sprintf('第一次平滑处理的第3行结束：%0.2f  min\n',toc/60)
%% （2）去除异常
    %% 第一次
L = length(old_data);
first_maxAbsError = maxAbsError ;
errorNum = 0;
for k=1:L
    error = abs(smooth_data(:,k)-old_data(:,k));
    compare = error>first_maxAbsError ;
    if sum(compare)>0
       % old_data(:,k)中存在误差超限的数据
       errorNum = errorNum+1 ;
       old_data(:,k) =  smooth_data(:,k);    
    end    
end
sprintf('删除异常数据个数：%d(%0.2f%%)  min\n',errorNum,errorNum/L*100)
real_data = old_data ;
%% 对剔除异常后的数据进行平滑
span = spanTime*100 ;
smooth_data = zeros(size(old_data));
smooth_data(1,:) = smooth(old_data(1,:),span,'rlowess');
sprintf('第二次（剔除后）平滑处理的第1行结束：%0.2f  min\n',toc/60)
smooth_data(2,:) = smooth(old_data(2,:),span,'rlowess');
sprintf('第二次（剔除后）平滑处理的第2行结束：%0.2f  min\n',toc/60)
smooth_data(3,:) = smooth(old_data(3,:),span,'rlowess');
sprintf('第二次（剔除后）平滑处理的第3行结束：%0.2f  min\n',toc/60)
