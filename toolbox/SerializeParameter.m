function [ Parameters ] = SerializeParameter(Parameters,IdName,write)
%LOADPARAMETER 此处显示有关此函数的摘要Parameters
%   SerializeParameter : write/read the parameters into/from file
%   'result\IdName_Parameter.mat'
%   write=true; write
%   write=false: read
   if(write)
      save(['Parameters\' IdName '_Parameter.mat'],'Parameters');   
   else
      Parameters=load(['Parameters\' IdName '_Parameter.mat']); 
      Parameters=Parameters.Parameters;
   end
end

