clear;clc;close all;
path('toolbox',path);
path('skeleton',path);
path('PhenotypicTrait',path);
path('segment',path);
path('Evaluate',path);
warning('off');
tic;
DebugShow=false;
isPhenotyping=false;
isSkeletonOptima=false;
isWritePhe=false;
isWrite=0;%%%%% write the parameter into file  / false:read the parameters in the paper
%************ user parameter***********************************
Parameters.KnnNum=16; %%%% k parameter for skeleton 
Parameters.t2=0.2;
Parameters.alpha=1;%%% alpha parameter for stem 
Parameters.K1=5;%%%% K1 for fine segmentation 
Parameters.K2=Parameters.K1;
Parameters.beta=0.0;%%%%% beta for fine segmentation
Parameters.sigma=0.2; %%%%% sigma for fine segmentation
Parameters.idstop=0;
%%%%%%%%%%%%
IdName='1'; %%%%% Users can modify the file name from 1 to 30, corresponding to 30 samples in the paper
filename=['testsample\' IdName '\'];
Parameters=SerializeParameter(Parameters,IdName,isWrite);
if(isfield(Parameters,'idstop'))
idstop=Parameters.idstop;
else
  idstop=1;  
end
%************1 Skeleton Extraction*****************************************
%%%% default parameter from paper(Cao et al 2010) 
sampleScale=0.02;
t1 = 0.1; % for inner branch nodes
a1 = pi*5.0/7.0; % for inner branch nodes, 
t2 = Parameters.t2;    
t3 = 6; % for small cycles;
[P.pts,trueRegions]=loadSegmentFile2(filename); 
Features=ComputeFeature_mt(P.pts,32,false);
eg_skeleton_laplacian_rosa;
eg_refine_skeleton;
%**************************************************************************


%************* 2 Coarse segmentation based on skeleton*********************
[MainSkeleton,Phi_U0]=FindMainSkeleton(P.pts,P.spls,joints,roots, P.spls_adj,P.corresp );

[joints ,roots, branches]=find_Joints_mt(P.spls, P.spls_adj,P.pts, DebugShow); 
[sub_skeletons]=SkeletonDecomposition2(MainSkeleton,P.spls, joints,roots, P.spls_adj,P.corresp,Features,DebugShow);
%[sub_skeletons]=SkeletonDecomposition(P.spls, joints,roots, P.spls_adj,DebugShow);
[Phi_O,Phi_U]=CoaseSegBySkeleton(P.pts,P.corresp,sub_skeletons,joints,3,DebugShow);
%%%% transform global coordinate axis to plant coordinate axis
[PA_Pts,PA_Spls]= ConstructPlantAxis(P.pts,P.spls,Phi_U,sub_skeletons);

%%%%% stem constraint 
[PA_StopX,PA_StartX]= FindLeafStopZ(sub_skeletons,joints,PA_Spls);  
[Phi_S,Phi_U]=StemSegment(PA_Pts,Phi_U,PA_StartX,Parameters.alpha,idstop,DebugShow);
Phi_O{end+1}=Phi_S;
PA_StopX(end+1)=-inf;
PA_StopX=flip(PA_StopX);
Phi_O=flip(Phi_O);
Phi_U=UpdatePhi_U(PA_Pts,Phi_O);

%Phi_U=[Phi_U;Phi_U0];


%**************************************************************************

%********************3 fine segmentation***********************************
id=sub_skeletons{end}(1);
StemBottomPt=PA_Spls(id,:);
autoRegions=FineSegmentation(PA_Pts,StemBottomPt,Phi_O,Phi_U,Parameters.K1,Parameters.K2,Parameters.beta,Parameters.sigma,DebugShow);
%**************************************************************************


%******************4 Evaluate**************************
[Precison,Recall,Micro_F1,Macro_F1,OA,Precisons,Recalls,F1s,RegionsCorresp] = Verification_mt(PA_Pts, trueRegions, autoRegions,length(PA_Pts),IdName,false);
str=['total time=' num2str(toc)];
disp(str);
str=['Precison=' num2str(Precison)];
disp(str);
str=['Recall=' num2str(Recall)];
disp(str);
str=['Macro_F1=' num2str(Macro_F1)];
disp(str);
str=['Micro_F1=' num2str(Micro_F1)];
disp(str);
str=['OA=' num2str(OA)];
disp(str);



%%%%%%%%%%%%%%%%%%%%%%Application%%%%%%%%%%%%%%%%%%%%%%%%
PlantHeight=0;PlantWidth=0;
if(isPhenotyping)
  traitfile=[IdName '.txt'];
  for i=1:length(trueRegions)
    id=RegionsCorresp(i);
    AutoRegions{i}=autoRegions{id};
  end
  [PlantHeight,PlantWidth,OrganSkeletons]=PhenotypicTrait(PA_Pts,AutoRegions,traitfile,DebugShow);
end


if(isSkeletonOptima)
[OrganSkeleton,newSpls,new_Spls_Adj]=refineSkeleton(autoRegions,PA_Pts,PA_Spls,P.corresp,P.spls_adj,IdName,true);
end





