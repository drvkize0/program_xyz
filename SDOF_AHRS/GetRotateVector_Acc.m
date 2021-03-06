%% xyz 2015.4.27
% 2015.4.30 ： 利用转轴在任何时刻本体系下表达一致的特点，优化转轴计算。
% 粗略计算出转动角度后，旋转转动角度最小的点作为新的 r 系，使新的r系下转角更大。

%% Calculate Rotate Vector only by Acc 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input
% Qnb_RVCal： 转轴解算时间段的 Qnb
% Qwr： 初始时刻的地理系 到 初始时刻的本体系
% AHRSThreshod： 相关判断指标
% AccelerationZeroJudge： Qnb_ZeroCal的是否0加速度判断结果

function [ Ypr_Acc,RecordStr ] = GetRotateVector_Acc( Qnb_RVCal,Qwr,AHRSThreshod,AccelerationZeroJudge,frequency )
RoateVectorCalMinAngleFirst = AHRSThreshod.RoateVectorCalMinAngleFirst ;
RoateVectorCalMinAngleSecond = AHRSThreshod.RoateVectorCalMinAngleSecond ;
RoateVectorCalMinAngleScope = AHRSThreshod.RoateVectorCalMinAngleScope ;
RoateVectorCalMinAngleScopeSub = AHRSThreshod.RoateVectorCalMinAngleScopeSub ;
%%% 粗算转轴： 假设航向为0，粗略选择满足转轴计算的数据：转角较大
% dbstop in SelectRotateVectorCalcualteData_Second
[ Qnb_RCD,Qwr_RCD,RecordStr1 ] = SelectRotateVectorCalcualteData_First( Qnb_RVCal,Qwr,RoateVectorCalMinAngleFirst,AccelerationZeroJudge,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub ) ;
% dbstop in CalculateRotateVector_Acc
Ypr_Acc1 = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD ) ;
%%% 精算转轴： 
% dbstop in SelectRotateVectorCalcualteData_Second
[ Qnb_RCD,Qwr_RCD,RecordStr2 ] = SelectRotateVectorCalcualteData_Second...
    ( Qnb_RVCal,Qwr,Ypr_Acc1,RoateVectorCalMinAngleSecond,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub,AccelerationZeroJudge ) ;
Ypr_Acc = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD ) ;

Ypr1Str = sprintf( '%0.5f  ',Ypr_Acc1 );
Ypr2Str = sprintf( '%0.5f  ',Ypr_Acc );
RecordStr = sprintf( '%s Ypr_Acc1 = %s  \n %s Ypr_Acc2 = %s (转轴数据计算时间=%0.2f s)\n',RecordStr1,Ypr1Str,RecordStr2,Ypr2Str,length(Qnb_RCD)/frequency );
disp( RecordStr );

%% 根据适合转角计算的四元数 Qnb_RCD 和 Qwr_RCD 计算转轴 Ypr_Acc
function  [ Ypr_Acc,RotateAngle_RCD ] = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD )
if isempty(Qnb_RCD)
    Ypr_Acc = NaN;
    RotateAngle_RCD = NaN;
    return;
end
D = CalculateD( Qnb_RCD,Qwr_RCD ) ;

DTD = D'*D ;
[ eigV,eigD ] = eig( DTD );
eigValue = diag(eigD);
[ minEigValue,minEig_k ] = min( eigValue );
X = eigV( :,minEig_k );
X = X/normest(X( 1:3 )) ;
Ypr_Acc = X( 1:3 );
Ypr_Acc = MakeVectorDirectionSame( Ypr_Acc ) ;

RotateAngle_RCD= (acot(X(4:length(X))))*180/pi*2 ;


%% check
K = size(D,2)-3;
As = zeros( 2,K );
for i=1:K
    As(:,i) = D( i*2-1:i*2,3+i );
end

DX = D*X ;
DTDX = DTD*eigV( :,1 ) ;

function D = CalculateD( Qnb,Qwr )
Nframes = size(Qnb,2);
D = zeros( 2*Nframes,3+Nframes );
for i=1:Nframes
    Ai = CalculateA_One( Qnb(:,i),Qwr ) ;
    As_i = Ai(2:3,1);
    Av_i = Ai(2:3,2:4);
    D( 2*i-1:2*i,1:3 ) = Av_i ;
    D( 2*i-1:2*i,3+i ) = As_i ;
end
disp('')

function A = CalculateA_One( Qnb,Qwr ) 
if length(Qnb)==4
    Qbn = [ Qnb(1);-Qnb(2:4) ] ;
    LQMwr = LeftQMultiplyMatrix( Qwr ) ;
    RQMbn = RightQMultiplyMatrix( Qbn ) ;
    A = RQMbn * LQMwr ;
else
    A = NaN;
end



function [ IsAngleBigStatic,RotateAngleSecond_AccZero,RotateAngleSecond_Big ] = AngleBigStatic( IsSDOFAccelerationZero,Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond )
% 只计算0加速度时间的数据
K_AccZero = find(IsSDOFAccelerationZero == 1) ;  % 0加速度的序号
N_AccZero = length(K_AccZero);

RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,Qwr,Ypr_Acc,K_AccZero ) ;

%% 第二次数据选择规则
% 1） 转角大于 RoateVectorCalMinAngleSecond
% 2） 静止状态
% 3） 角度范围大于 

temp1 = find(abs(RotateAngleSecond_AccZero)>RoateVectorCalMinAngleSecond) ;
IsAngleBigStatic = K_AccZero(temp1);

RotateAngleSecond_Big = RotateAngleSecond_AccZero(temp1);


%% Second : select data be suitable for rotate vector calculating
%%% 根据第一次计算的粗略转轴 Ypr_Acc，计算转动角度， 大于 RoateVectorCalMinAngleSecond
%%% 的数据认为是有效的，用于进行第二次转轴计算
function [ Qnb_RCD,Qwr_RCD,RecordStr ] = SelectRotateVectorCalcualteData_Second...
    ( Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub,AccelerationZeroJudge )
N = size(Qnb_RVCal,2);
IsSDOFAccelerationZero = AccelerationZeroJudge.IsSDOFAccelerationZero(1:N);
K_AccZero = find(IsSDOFAccelerationZero == 1) ;  % 0加速度的序号
RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,Qwr,Ypr_Acc,K_AccZero ) ;

temp = find(abs(RotateAngleSecond_AccZero)>RoateVectorCalMinAngleSecond) ;
RotateAngleSecond_AccZeroBig = RotateAngleSecond_AccZero(temp);

[ AngleScope1,AngleScopeSub1 ] = GetAngleScope( RotateAngleSecond_AccZeroBig ) ;
if AngleScope1 < RoateVectorCalMinAngleScope || AngleScopeSub1 < RoateVectorCalMinAngleScopeSub
    IsSDOFAccelerationZero = AccelerationZeroJudge.IsSDOFAccelerationToHeartZero(1:N);
    K_AccZero = find(IsSDOFAccelerationZero == 1) ; 
    RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,Qwr,Ypr_Acc,K_AccZero ) ;
    disp('转轴计算：0加速度=0的数据不足，改为向心加速度=0')
end

%% 选择旋转角度在最端点的数据作为新的参考系 rNew，用于优化转轴的计算
% 同时要求这个点满足最强的 0 加速度判断条件
%  dbstop in GetQwrNew
QwrNew = GetQwrNew( Qnb_RVCal,RotateAngleSecond_AccZero,IsSDOFAccelerationZero );
if QwrNew==0
    Qwr_RCD = Qwr;
else
    Qwr_RCD = QwrNew ;
    % 用新的 Qwr计算转角
    RotateAngleSecond_AccZero = CalculateRotateAngle_Acc( Qnb_RVCal,QwrNew,Ypr_Acc,K_AccZero ) ;
end

%% 用新的 Qwr计算转角
% 大转角的序号 IsAngleBigStatic
temp1 = find(abs(RotateAngleSecond_AccZero)>RoateVectorCalMinAngleSecond) ;
IsAngleBigStatic = K_AccZero(temp1);
RotateAngleSecond_Big = RotateAngleSecond_AccZero(temp1);

Qnb_RCD = Qnb_RVCal( :,IsAngleBigStatic );
RecordStr = '';
return;

%%

[IsAngleBigStatic1,RotateAngleSecond_AccZero1,RotateAngleSecond_Big1 ]  = AngleBigStatic( AccelerationZeroJudge.IsSDOFAccelerationZero(1:N),Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond );
[IsAngleBigStatic2,RotateAngleSecond_AccZero2,RotateAngleSecond_Big2 ] = AngleBigStatic( AccelerationZeroJudge.IsSDOFAccelerationToHeartZero(1:N),Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond );
[IsAngleBigStatic3,RotateAngleSecond_AccZero3,RotateAngleSecond_Big3 ] = AngleBigStatic( AccelerationZeroJudge.IsAccNormZero(1:N),Qnb_RVCal,Qwr,Ypr_Acc,RoateVectorCalMinAngleSecond );

%% 优先选择严格的 0 加速度判断

IsAngleBigStatic_SeclectFlag = 0 ;
if ~isempty(IsAngleBigStatic1>0)
    [ AngleScope1,AngleScopeSub1 ] = GetAngleScope( RotateAngleSecond_Big1 ) ;
    if AngleScope1 > RoateVectorCalMinAngleScope
        if AngleScopeSub1 > RoateVectorCalMinAngleScopeSub
            %%% 选择严格的0加速度标准时满足条件
            IsAngleBigStatic = IsAngleBigStatic1 ;
            IsAngleBigStatic_SeclectFlag = 1 ;
            RotateAngleSecond_AccZero = RotateAngleSecond_AccZero1 ;
            disp('转轴计算数据选择（第二次）：严格的0加速度');
        end
    end
end
%% 其次选择向心加速和模的判断条件  IsSDOFAccelerationToHeartZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic2>0 )
        [ AngleScope2,AngleScopeSub2 ] = GetAngleScope( RotateAngleSecond_Big2 ) ;
        if AngleScope2 > RoateVectorCalMinAngleScope
            if AngleScopeSub2 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic2 ;
                IsAngleBigStatic_SeclectFlag = 2 ;
                disp('转轴计算数据选择（第二次）：仅向心加速度=0');
            end
        end
    end
end
%% 再其次选择模的判断条件  IsAccNormZero
% if IsAngleBigStatic_SeclectFlag == 0
%     if ~isempty( IsAngleBigStatic3>0 )
%         [ AngleScope3,AngleScopeSub3 ] = GetAngleScope( RotateAngleSecond(IsAngleBigStatic3) ) ;
%         if AngleScope3 > RoateVectorCalMinAngleScope
%             if AngleScopeSub3 > RoateVectorCalMinAngleScopeSub
%                 IsAngleBigStatic = IsAngleBigStatic3 ;
%                 IsAngleBigStatic_SeclectFlag = 3 ;    
%                 disp('转轴计算数据选择（第二次）：仅加计模=g');                
%             end
%         end
%     end
% end
RecordStr = sprintf( 'SelectRotateVectorCalcualteData_Second 转轴数据选择标志 IsAngleBigStatic_SeclectFlag = %0.0f \n',IsAngleBigStatic_SeclectFlag );
%% 以上均不满足时说明找不到求转轴的数据
if IsAngleBigStatic_SeclectFlag == 0
   errordlg( '找不到转轴计算数据（SelectRotateVectorCalcualteData_First）' ); 
   Qnb_RCD = [];
   Qwr_RCD = [];
   return;
end

Qnb_RCD = Qnb_RVCal( :,IsAngleBigStatic );
Qwr_RCD = Qwr;
% return;




%% 选择旋转角度在最端点的数据作为新的参考系 rNew，用于优化转轴的计算
% 同时要求这个点满足最强的 0 加速度判断条件
% 从角度最小的点开始搜索，找到一个点的 IsLongAccelerationZeroFlag 为1，且前后 0.1 S 的时间均

% IsLongAccelerationZeroFlag(k)：第k点是否连续保持0加速度状态
function QwrNew = GetQwrNew( Qnb,RotateAngle_AccZero,IsSDOFAccelerationZero )

% 找最小转角对应的序号
[ RotateAngleSorted,Index ] = sort( RotateAngle_AccZero,'ascend' );
% 只有当正负转角均超过 10° 时才有必要用过替代零位
if abs( min(RotateAngle_AccZero) )<10*pi/180 || abs( max(RotateAngle_AccZero) )<10*pi/180   
    QwrNew = 0;% 找不到
    disp('，没必要用替代参考零位优化转轴计算');
    return;
end    
N_AccZero = find(IsSDOFAccelerationZero==1);
QwrNew_k = N_AccZero(Index(1)) ;
%%% 取最小转角所在邻域均值为新的 Qwr
% 往前搜索 startNew_r_k
N = length(Qnb) ;
startNew_r_k = QwrNew_k ;
for k=1:QwrNew_k-1
    i = QwrNew_k-k+1 ;
    if IsSDOFAccelerationZero(i)==0
        startNew_r_k = i ;
        break;
    end
end
    
% 往后搜索 endNew_r_k
N = length(Qnb) ;
endNew_r_k = QwrNew_k ;
for k=QwrNew_k:N
    if IsSDOFAccelerationZero(k)==0
        endNew_r_k = k ;
        break;
    end
end

Qnb_New_r = Qnb( :,startNew_r_k:endNew_r_k );
QwrNew = mean(Qnb_New_r,2) ;
QwrNew = QwrNew/normest(QwrNew) ;


QwrNewStr = sprintf( '%0.3f ',QwrNew );
fprintf('QwrNew = %s \n',QwrNewStr);


% AngleScope：转角覆盖的范围
% AngleScopeSub：正和负转角覆盖的范围的最大值
function [ AngleScope,AngleScopeSub ] = GetAngleScope( RotateAngleSeclected )
AngleScope = max( RotateAngleSeclected ) - min( RotateAngleSeclected ) ;
% 正值的覆盖范围
RotateAngleSeclectedPos = RotateAngleSeclected(RotateAngleSeclected>0) ;
if ~isempty( RotateAngleSeclectedPos  )
    AngleScopePositive = max( RotateAngleSeclectedPos ) - min( RotateAngleSeclectedPos ) ;
else
    AngleScopePositive = 0 ;
end
% 负值的覆盖范围
RotateAngleSeclectedNeg = RotateAngleSeclected(RotateAngleSeclected<0) ;
if ~isempty( RotateAngleSeclectedNeg  )
    AngleScopeNegtive = min( RotateAngleSeclectedNeg ) - max( RotateAngleSeclectedNeg ) ;
else
    AngleScopeNegtive = 0;
end

AngleScopeSub = max( AngleScopePositive,AngleScopeNegtive );

%% Firts : select data be suitable for rotate vector calculating
%%% 假设航向保持0时，俯仰和横滚转动四元数的转角大于 RoateVectorCalMinAngleFirst 角度时，用于旋转轴的第一次计算
function [ Qnb_RCD,Qwr_RCD,RecordStr ] = SelectRotateVectorCalcualteData_First( Qnb,Qwr,RoateVectorCalMinAngleFirst,AccelerationZeroJudge,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub )

Qrw = Qinv( Qwr );
N = size(Qnb,2);
Qrb_PreFirst = QuaternionMultiply( repmat(Qrw,1,N),Qnb );       % 粗略Qrb：假设航向不变
angleFirst = GetQAngle( Qrb_PreFirst ) ;

IsAngleBig =  angleFirst > RoateVectorCalMinAngleFirst | angleFirst < -RoateVectorCalMinAngleFirst ;

IsAngleBigStatic1 = IsAngleBig & AccelerationZeroJudge.IsSDOFAccelerationZero(1:length(IsAngleBig)) ;
IsAngleBigStatic2 = IsAngleBig & AccelerationZeroJudge.IsSDOFAccelerationToHeartZero(1:length(IsAngleBig)) ;
IsAngleBigStatic3 = IsAngleBig & AccelerationZeroJudge.IsAccNormZero(1:length(IsAngleBig)) ;

K_AccZero = find(AccelerationZeroJudge.IsSDOFAccelerationZero == 1) ;  % 0加速度的序号
N_AccZero = length(K_AccZero);
Qnb_AccZero = Qnb( :,K_AccZero );
Qrb_AccZero_PreFirst = QuaternionMultiply( repmat(Qrw,1,N_AccZero),Qnb_AccZero );       % 粗略Qrb：假设航向不变
angleFirst_AccZero = GetQAngle( Qrb_AccZero_PreFirst ) ;

% figure('name','SelectRotateVectorCalcualteData_First')
% plot(K_AccZero,angleFirst_AccZero*180/pi,'.');
% hold on
% plot(1:N,angleFirst*180/pi,'ro');
%% 优先选择严格的 0 加速度判断

IsAngleBigStatic_SeclectFlag = 0 ;
if ~isempty(IsAngleBigStatic1>0)
    [ AngleScope1,AngleScopeSub1 ]  = GetAngleScope( angleFirst(IsAngleBigStatic1) ) ;
    if AngleScope1 > RoateVectorCalMinAngleScope 
        if AngleScopeSub1 > RoateVectorCalMinAngleScopeSub
            %%% 选择严格的0加速度标准时满足条件
            IsAngleBigStatic = IsAngleBigStatic1 ;
            IsAngleBigStatic_SeclectFlag = 1 ;
            disp('转轴计算数据选择（第一次）：严格的0加速度');
        end
    end
end
%% 其次选择向心加速和模的判断条件  IsSDOFAccelerationToHeartZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic2>0 )
        [ AngleScope2,AngleScopeSub2 ]  = GetAngleScope( angleFirst(IsAngleBigStatic2) ) ;
        if AngleScope2 > RoateVectorCalMinAngleScope
            if AngleScopeSub2 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic2 ;
                IsAngleBigStatic_SeclectFlag = 2 ;
                disp('转轴计算数据选择（第一次）：仅向心加速度=0');
            end
        end
    end
end
%% 再其次选择模的判断条件  IsAccNormZero
% if IsAngleBigStatic_SeclectFlag == 0
%     if ~isempty( IsAngleBigStatic3>0 )
%         [ AngleScope3,AngleScopeSub3 ]  = GetAngleScope( angleFirst(IsAngleBigStatic3) ) ;
%         if AngleScope3 > RoateVectorCalMinAngleScope
%             if AngleScopeSub3 > RoateVectorCalMinAngleScopeSub
%                 IsAngleBigStatic = IsAngleBigStatic3 ;
%                 IsAngleBigStatic_SeclectFlag = 3 ;
%                 disp('转轴计算数据选择（第二次）：仅加计模=g');
%             end
%         end
%     end
% end
RecordStr = sprintf( 'SelectRotateVectorCalcualteData_First 转轴数据选择标志 IsAngleBigStatic_SeclectFlag = %0.0f \n',IsAngleBigStatic_SeclectFlag );
%% 以上均不满足时说明找不到求转轴的数据
if IsAngleBigStatic_SeclectFlag == 0
   errordlg( '找不到转轴计算数据，检查RoateVectorCalMinAngleFirst参数（SelectRotateVectorCalcualteData_First）' ); 
   Qnb_RCD = [];
   Qwr_RCD = [];
   return;
end

Qnb_RCD = Qnb( :,IsAngleBigStatic );

Qwr_RCD = Qwr;
return;
%% 选择旋转角度在最端点的数据作为新的参考系 rNew，用于优化转轴的计算
% 同时要求这个点满足最强的 0 加速度判断条件
% dbstop in GetQwrNew
angleFirst_d =  angleFirst*180/pi;
QwrNew = GetQwrNew( Qnb,angleFirst,AccelerationZeroJudge.IsLongSDOFAccelerationZero );
if QwrNew==0
    Qwr_RCD = Qwr;
else
    Qwr_RCD = QwrNew ;
end
%% check
angleFirst_RCD = angleFirst(IsAngleBigStatic);
time = 1:N;
figure('name','IsAngleBigStatic-Second')
plot( angleFirst*180/pi )
hold on
plot( time(IsAngleBigStatic),angleFirst_RCD*180/pi,'r.' )





