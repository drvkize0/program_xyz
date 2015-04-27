%% xyz 2015.4.27


%% Calculate Rotate Vector only by Acc 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Input
% Qnb_ZeroCal： 转轴解算时间段的 Qnb
% Qwr： 初始时刻的地理系 到 初始时刻的本体系
% AHRSThreshod： 相关判断指标
% SDOFStaticFlag： Qnb_ZeroCal的是否0加速度判断结果

function [ Ypr,RecordStr ] = GetRotateVector_Acc( Qnb_ZeroCal,Qwr,AHRSThreshod,SDOFStaticFlag )
RoateVectorCalMinAngleFirst = AHRSThreshod.RoateVectorCalMinAngleFirst ;
RoateVectorCalMinAngleSecond = AHRSThreshod.RoateVectorCalMinAngleSecond ;
RoateVectorCalMinAngleScope = AHRSThreshod.RoateVectorCalMinAngleScope ;
RoateVectorCalMinAngleScopeSub = AHRSThreshod.RoateVectorCalMinAngleScopeSub ;
%%% 粗算转轴： 假设航向为0，粗略选择满足转轴计算的数据：转角较大
[ Qnb_RCD,Qwr_RCD,RecordStr1 ] = SelectRotateVectorCalcualteData_First( Qnb_ZeroCal,Qwr,RoateVectorCalMinAngleFirst,SDOFStaticFlag,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub ) ;
dbstop in CalculateRotateVector_Acc
Ypr1 = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD ) ;
%%% 精算转轴： 
[ Qnb_RCD,Qwr_RCD,RecordStr2 ] = SelectRotateVectorCalcualteData_Second...
    ( Qnb_ZeroCal,Qwr,Ypr1,RoateVectorCalMinAngleSecond,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub,SDOFStaticFlag ) ;
Ypr = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD ) ;

Ypr1Str = sprintf( '%0.4f  ',Ypr1 );
Ypr2Str = sprintf( '%0.4f  ',Ypr );
RecordStr = sprintf( '%s Ypr1 = %s  \n %s Ypr2 = %s \n',RecordStr1,Ypr1Str,RecordStr2,Ypr2Str );
disp( RecordStr );

%% 根据适合转角计算的四元数 Qnb_RCD 和 Qwr_RCD 计算转轴 Ypr
function  [ Ypr,RotateAngle_RCD ] = CalculateRotateVector_Acc( Qnb_RCD,Qwr_RCD )
D = CalculateD( Qnb_RCD,Qwr_RCD ) ;

DTD = D'*D ;
[ eigV,eigD ] = eig( DTD );
eigValue = diag(eigD);
[ minEigValue,minEig_k ] = min( eigValue );
X = eigV( :,minEig_k );
X = X/normest(X( 1:3 )) ;
Ypr = X( 1:3 );

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

%% Second : select data be suitable for rotate vector calculating
%%% 根据第一次计算的粗略转轴 Ypr，计算转动角度， 大于 RoateVectorCalMinAngleSecond
%%% 的数据认为是有效的，用于进行第二次转轴计算
function [ Qnb_RCD,Qwr_RCD,RecordStr ] = SelectRotateVectorCalcualteData_Second...
    ( Qnb_ZeroCal,Qwr,Ypr,RoateVectorCalMinAngleSecond,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub,SDOFStaticFlag )
RotateAngleSecond = CalculateRotateAngle_Acc( Qnb_ZeroCal,Qwr,Ypr ) ;
%% 第二次数据选择规则
% 1） 转角大于 RoateVectorCalMinAngleSecond
% 2） 静止状态
% 3） 角度范围大于 
IsAngleBig = abs(RotateAngleSecond)>RoateVectorCalMinAngleSecond ;
IsAngleBigStatic1 = IsAngleBig & SDOFStaticFlag.IsSDOFAccelerationZero(1:length(IsAngleBig))' ;
IsAngleBigStatic2 = IsAngleBig & SDOFStaticFlag.IsSDOFAccelerationToHeartZero(1:length(IsAngleBig))' ;
IsAngleBigStatic3 = IsAngleBig & SDOFStaticFlag.IsAccNormZero(1:length(IsAngleBig))' ;

%% 优先选择严格的 0 加速度判断

IsAngleBigStatic_SeclectFlag = 0 ;
if ~isempty(IsAngleBigStatic1>0)
    [ AngleScope1,AngleScopeSub1 ] = GetAngleScope( RotateAngleSecond(IsAngleBigStatic1) ) ;
    if AngleScope1 > RoateVectorCalMinAngleScope
        if AngleScopeSub1 > RoateVectorCalMinAngleScopeSub
            %%% 选择严格的0加速度标准时满足条件
            IsAngleBigStatic = IsAngleBigStatic1 ;
            IsAngleBigStatic_SeclectFlag = 1 ;
        end
    end
end
%% 其次选择向心加速和模的判断条件  IsSDOFAccelerationToHeartZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic2>0 )
        [ AngleScope2,AngleScopeSub2 ] = GetAngleScope( RotateAngleSecond(IsAngleBigStatic2) ) ;
        if AngleScope2 > RoateVectorCalMinAngleScope
            if AngleScopeSub2 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic2 ;
                IsAngleBigStatic_SeclectFlag = 2 ;
            end
        end
    end
end
%% 再其次选择模的判断条件  IsAccNormZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic3>0 )
        [ AngleScope3,AngleScopeSub3 ] = GetAngleScope( RotateAngleSecond(IsAngleBigStatic3) ) ;
        if AngleScope3 > RoateVectorCalMinAngleScope
            if AngleScopeSub3 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic3 ;
                IsAngleBigStatic_SeclectFlag = 3 ;
            end
        end
    end
end
RecordStr = sprintf( 'SelectRotateVectorCalcualteData_Second 转轴数据选择标志 IsAngleBigStatic_SeclectFlag = %0.0f \n',IsAngleBigStatic_SeclectFlag );
%% 以上均不满足时说明找不到求转轴的数据
if IsAngleBigStatic_SeclectFlag == 0
   errordlg( '找不到转轴计算数据（SelectRotateVectorCalcualteData_First）' ); 
   Qnb_RCD = [];
   Qwr_RCD = [];
   return;
end

Qnb_RCD = Qnb_ZeroCal( :,IsAngleBigStatic );
Qwr_RCD = Qwr;

%% check
RotateAngleSecond_RCD = RotateAngleSecond(IsAngleBigStatic);
time = 1:length(RotateAngleSecond);
figure
plot( RotateAngleSecond*180/pi )
hold on
plot( time(IsAngleBigStatic),RotateAngleSecond_RCD*180/pi,'r.' )

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
function [ Qnb_RCD,Qwr_RCD,RecordStr ] = SelectRotateVectorCalcualteData_First( Qnb,Qwr,RoateVectorCalMinAngleFirst,SDOFStaticFlag,RoateVectorCalMinAngleScope,RoateVectorCalMinAngleScopeSub )

Qrw = Qinv( Qwr );
N = size(Qnb,2);
Qrb_false = QuaternionMultiply( repmat(Qrw,1,N),Qnb );
angleFirst = GetQAngle( Qrb_false ) ;

IsAngleBig =  angleFirst > RoateVectorCalMinAngleFirst | angleFirst < -RoateVectorCalMinAngleFirst ;

IsAngleBigStatic1 = IsAngleBig & SDOFStaticFlag.IsSDOFAccelerationZero(1:length(IsAngleBig))' ;
IsAngleBigStatic2 = IsAngleBig & SDOFStaticFlag.IsSDOFAccelerationToHeartZero(1:length(IsAngleBig))' ;
IsAngleBigStatic3 = IsAngleBig & SDOFStaticFlag.IsAccNormZero(1:length(IsAngleBig))' ;

%% 优先选择严格的 0 加速度判断

IsAngleBigStatic_SeclectFlag = 0 ;
if ~isempty(IsAngleBigStatic1>0)
    [ AngleScope1,AngleScopeSub1 ]  = GetAngleScope( angleFirst(IsAngleBigStatic1) ) ;
    if AngleScope1 > RoateVectorCalMinAngleScope 
        if AngleScopeSub1 > RoateVectorCalMinAngleScopeSub
            %%% 选择严格的0加速度标准时满足条件
            IsAngleBigStatic = IsAngleBigStatic1 ;
            IsAngleBigStatic_SeclectFlag = 1 ;
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
            end
        end
    end
end
%% 再其次选择模的判断条件  IsAccNormZero
if IsAngleBigStatic_SeclectFlag == 0
    if ~isempty( IsAngleBigStatic3>0 )
        [ AngleScope3,AngleScopeSub3 ]  = GetAngleScope( angleFirst(IsAngleBigStatic3) ) ;
        if AngleScope3 > RoateVectorCalMinAngleScope
            if AngleScopeSub3 > RoateVectorCalMinAngleScopeSub
                IsAngleBigStatic = IsAngleBigStatic3 ;
                IsAngleBigStatic_SeclectFlag = 3 ;
            end
        end
    end
end
RecordStr = sprintf( 'SelectRotateVectorCalcualteData_First 转轴数据选择标志 IsAngleBigStatic_SeclectFlag = %0.0f \n',IsAngleBigStatic_SeclectFlag );
%% 以上均不满足时说明找不到求转轴的数据
if IsAngleBigStatic_SeclectFlag == 0
   errordlg( '找不到转轴计算数据（SelectRotateVectorCalcualteData_First）' ); 
   Qnb_RCD = [];
   Qwr_RCD = [];
   return;
end

Qnb_RCD = Qnb( :,IsAngleBigStatic );
Qwr_RCD = Qwr;

%% check
angleFirst_RCD = angleFirst(IsAngleBigStatic);
time = 1:N;
figure
plot( angleFirst*180/pi )
hold on
plot( time(IsAngleBigStatic),angleFirst_RCD*180/pi,'r.' )


