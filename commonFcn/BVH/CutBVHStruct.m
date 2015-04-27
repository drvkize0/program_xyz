%% xyz   2015.4.1


function BVHStruct = CutBVHStruct( BVHStruct,cutRate )

%% BVHStruct.BVHData
data = BVHStruct.data ;
BVHFormat = BVHStruct.BVHFormat ;
BVHDataNew  = [];
BVHDataRotationNew = [];
N = length(BVHFormat);
isContainPosition = 0 ;
for k=1:N
    BVHDataNew_k = eval( sprintf('data.%s',BVHFormat{k}) ) ;
    BVHDataNew_k = CutBVHDataNew_k( BVHDataNew_k,cutRate )  ;
    BVHDataNew = [ BVHDataNew,BVHDataNew_k  ];
    eval( sprintf('data.%s = BVHDataNew_k;',BVHFormat{k}) ) ;
    
    BVHDataNew_k_M = size(BVHDataNew_k,2);
    if k==1
        BVHDataRotation_k = BVHDataNew_k( :,BVHDataNew_k_M-5:BVHDataNew_k_M );
    else
        BVHDataRotation_k = BVHDataNew_k( :,BVHDataNew_k_M-2:BVHDataNew_k_M );
    end
    BVHDataRotationNew = [ BVHDataRotationNew,BVHDataRotation_k ];
    if k>1 && BVHDataNew_k_M>3
       isContainPosition = 1 ; 
    end
end


%% Update  Frames  Frame_Time
BVHHeadStr = BVHStruct.BVHHeadStr ;

MOTION_Str_Start_k = strfind( BVHHeadStr,'MOTION' );
Frames_Str_Start_k = strfind( BVHHeadStr,'Frames: ' );
Frame_Time_Str_Start_k = strfind( BVHHeadStr,'Frame Time: ' );

FramesNum_Str = BVHHeadStr( Frames_Str_Start_k+7:Frame_Time_Str_Start_k-1 ) ;
FramesNum_old = str2double(FramesNum_Str);
Frame_Time_Str = BVHHeadStr( Frame_Time_Str_Start_k+11:length(BVHHeadStr)-1 ) ;
Frame_Time = str2double(Frame_Time_Str);

Nframes = size(BVHDataNew,1);
Frame_Time_New = Frame_Time*FramesNum_old/Nframes ;

BVHHeadStr = sprintf( '%sMOTION\n  \nFrames: %0.0f\nFrame Time: %0.2f\n',BVHHeadStr(1:MOTION_Str_Start_k-1),Nframes,Frame_Time_New );


BVHStruct.BVHData = BVHDataNew ;
BVHStruct.BVHDataRotation = BVHDataRotationNew ;
BVHStruct.isContainPosition = isContainPosition ;
BVHStruct.data = data ;
BVHStruct.BVHHeadStr = BVHHeadStr ;


function BVHDataNew_k_New = CutBVHDataNew_k( BVHDataNew_k,cutRate ) 

N = size(BVHDataNew_k,1);
N_new = fix(N/cutRate) ;

if N_new<1
    
   N_new = 1 ;
   cutRate = fix(N/N_new) ;
   N_new = fix(N/cutRate) ;
end

BVHDataNew_k_New = zeros( N_new,size(BVHDataNew_k,2) );
i = 0 ;
for k=1:cutRate:N
    i = i+1 ;
    BVHDataNew_k_New(i,:) = BVHDataNew_k( k,: );
end
BVHDataNew_k_New = BVHDataNew_k_New( 1:i,: );
% 
% ȡһ��
NN = size(BVHDataNew_k_New,1);
BVHDataNew_k_New = BVHDataNew_k_New( fix(NN/2):NN,: );