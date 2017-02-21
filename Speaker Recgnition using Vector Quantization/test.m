function test()

load speakerData;
load DATABASE;

[filename, pathname] = uigetfile('*.wav','select a wave file to load');
if pathname == 0
    errordlg('ERROR! No file selected!');
    return;
end    
f = [pathname, filename];
fprintf('\n\nTesting selected file "%s"...\n',filename);
[s, fs] = wavread(f);

% Compute MFCC
v = mfcc(s, fs);            

distmin = inf;
k = 0;

% For each trained codebook, compute distortion
for l = 1:length(speakerData)      
    d = disteu(v, DATABASE{3,l});
    
    dist = sum(min(d,[],2)) / size(d,1);
    fprintf('\n\nDistace from codeword of %s = %f' , DATABASE{1,l} , dist);
       
	t = DATABASE{4,l};
    diff = t-dist;
    fprintf('\nDifference between the distace and threshold = %f' , diff);
        
    if dist < t
    if dist < distmin
         distmin = dist;
         k = l;
	end
    end      
end

if k ~= 0 
    msg = sprintf('\n\nSpeaker "%s" recognized as %s', filename, speakerData(k,1).name(1:end-4));
else 
    msg = sprintf('\n\nSpeaker "%s" not recognized!!', filename);
end
disp(msg);
  

