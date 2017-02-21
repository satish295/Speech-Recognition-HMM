function threshold()

load speakerData;
load DATABASE;

fprintf ('\n\nTraining Threshold...\n');

% train threshold for each speaker
for i = 1:speakerNum                     
    person_name = speakerData(i,1).name(1:end-4);
    file = ['.\train\distance\',person_name];
	[s, fs] = wavread(file);   
    fprintf ('Training %s... ',DATABASE{1,i});
    
	% Compute MFCC
    v = mfcc(s, fs);           

    d = disteu(v, DATABASE{3,i});
    dist = sum(min(d,[],2)) / size(d,1);
    dist = dist + 1;
    DATABASE{4,i} = dist;
    fprintf('Done!!\n');
              
end
fprintf('Threshold Training Complete!!\n');
save DATABASE;
fprintf('Database Saved.\n');
