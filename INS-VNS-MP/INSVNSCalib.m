%% xyz 2015 儿童节 特供
%% 惯性 视觉 坐标系标定
% 位移差数据： dX_Vision
% r系： 视觉系
% w系： 惯性系（NED）
% Crw： 视觉系到关系关系的方向余弦矩阵

function Crw = INSVNSCalib( INSVNSCalib_VS_k,dX_Vision,InertialPosition )

N = size(INSVNSCalib_VS_k,2);
dX_Inertial = zeros(3,N);
for k=1:N
    INSVNSCalib_VS_k(1,k) = VisionK_to_InertialK( INSVNSCalib_VS_k(1,k) ) ;
    INSVNSCalib_VS_k(2,k) = VisionK_to_InertialK( INSVNSCalib_VS_k(2,k) ) ;
    
    dX_Inertial(:,k) = InertialPosition( :, INSVNSCalib_VS_k(2,k)) - InertialPosition( :, INSVNSCalib_VS_k(1,k)) ;
    
    dX_Inertial(3,k) = 0; % 地向给0
end


Crw = dX_Inertial(1:2,:) / dX_Vision(1:2,:) ;
Crw = [Crw [0;0]; [0 0 1]];

Attitude = C2Attitude( Crw,'NED' ) ;
fprintf( '视觉到惯性系的姿态： [ %0.2f  %0.2f  %0.2f ] \n',Attitude.yaw*180/pi,Attitude.pitch*180/pi,Attitude.roll*180/pi );

if abs(Attitude.yaw) > 10*pi/180
   fprintf('视觉到惯性的航向角比较大'); 
end
