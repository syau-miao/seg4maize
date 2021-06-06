function [ Parameters ] = SerializeParameter(Parameters,IdName,write)
%LOADPARAMETER �˴���ʾ�йش˺�����ժҪParameters
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

