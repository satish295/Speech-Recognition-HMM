function hmm_recog()

load DATABASE;
fprintf('Select File for Testing...');
[filename, pathname] = uigetfile('*.wav','select a wave file to load');
if pathname == 0
    errordlg('ERROR! No file selected!');
    return; 
end    

f = [pathname, filename];
fprintf('\nTesting selected file "%s"...\n',filename);

[s, fs] = wavread(f);
v = mfcc(s, fs);
v = vqlbg(v);

minc = min(v(:));
maxc = max(v(:));

[m, n] = size(v);

for i=1:m
    for j=1:n
        vs(i,j) = floor((((v(i,j)-minc)/(maxc-minc))*(1260-1))+1);
    end
end


t = 1;
for i=1
    for j=1:n
        seq(1,t) = vs(i,j);
        t=t+1;
    end
end  


waveDir='.\train\';
speakerData = dir(waveDir);
speakerData(1:2) = [];
speakerNum = length(speakerData);
results = zeros(1,speakerNum);
for i=1:speakerNum    
    TRANS = DATABASE{5,i}{1,1};
    EMIS = DATABASE{5,i}{1,2};
    [ignore,logpseq] = hmmdecode(seq,TRANS,EMIS);  
    DATABASE{14,i} = logpseq;
    P=exp(logpseq);
    DATABASE{15,i} = P;
    
    if DATABASE{14,i} < DATABASE{11,i}
        DATABASE{17,i} = -Inf;
    else
        DATABASE{17,i} = DATABASE{14,i};
    end
    DATABASE{18,i} = exp(DATABASE{17,i});
    
    results(1,i) = DATABASE{18,i};
    
end

[maxlogpseq,person_index] = max(results);

if maxlogpseq < DATABASE{12,person_index}
    fprintf('Selected Speaker not Recognized!!\n\n');
else
    fprintf('Recognized selected speaker as %s.\n\n', DATABASE{1,person_index});
end

save DATABASE;



