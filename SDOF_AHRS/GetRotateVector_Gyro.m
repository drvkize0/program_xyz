%% xyz 2015.4.27

%% �����ݻ��ּ���ת��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [ Ypr_Gyro,RecordStr ] = GetRotateVector_Gyro( imuInputData,InitialData,AHRSThreshod,SDOFStaticFlag )

RoateVectorCalMinAngleSecond = AHRSThreshod.RoateVectorCalMinAngleSecond ;

Qwr = InitialData.Qwb0 ;
[ Qwb,Vwb,rwb,Attitude ] = SINSNav( imuInputData,InitialData ) ;
Qrb = LeftQMultiplyMatrix(  Qinv(Qwr) )*Qwb ;
[ QAngle,QVectorNormed] = GetQAngle( Qrb ) ;

%% when rotate angle is too small , calcualtion error of Qrb_NormVector and Ypr_Gyro is too big
% first, select the largest 10 degree angle data
QAngleMax= max(abs(QAngle)) ;
Index_BigAngleSection = abs(QAngle) >  QAngleMax-5*pi/180 ;
% second , select  angle data bigger than RoateVectorCalMinAngleSecond
Index_BigAngler = abs(QAngle) > abs(RoateVectorCalMinAngleSecond );   

Index_BigAngle = Index_BigAngler & Index_BigAngleSection ;
Qrb_NormVector_BigAngle_V = QVectorNormed( :,Index_BigAngle );   % get big rotate angle data

Ypr_Gyro = mean( Qrb_NormVector_BigAngle_V,2) ;     % get the mean roate vector

Ypr_GyroStr = sprintf( '%0.5f  ',Ypr_Gyro );
RecordStr = sprintf( ' Ypr_Gyro = %s ;',Ypr_GyroStr );
disp(RecordStr);