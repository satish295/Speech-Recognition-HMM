function train()

clc; clear;

fprintf ('Reading and Training Database...\n');
waveDir='.\train\data\';
speakerData = dir(waveDir);
speakerData(1:2) = [];
speakerNum=length(speakerData); 

% train a VQ codebook for each speaker
for i=1:speakerNum                      
	person_name = speakerData(i,1).name(1:end-4);
	DATABASE{1,i} = person_name;
    fprintf ('Training %s... ',DATABASE{1,i});
    
	file = ['.\train\data\',person_name];
	[s, fs] = wavread(file);
	
	% Compute MFCC
    DATABASE{2,i} = mfcc(s, fs);  

	% Train VQ codebook
	DATABASE{3,i} = vqlbg(DATABASE{2,i});    
	
	fprintf('Done!!\n');
    
end

fprintf('Database Training Complete!!\n');
save speakerData;
save DATABASE;
fprintf('Database Saved.\n');