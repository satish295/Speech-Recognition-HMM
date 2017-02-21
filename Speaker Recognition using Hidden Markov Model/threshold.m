function threshold()

load DATABASE;
waveDir='.\threshold\';
speakerData = dir(waveDir);
speakerData(1:2) = [];
speakerNum=length(speakerData); %speakerNum

eps=.000001;
ufft = [1 5 6 8 10];
fprintf ('\n\nReading and Training Thresholds...\n');
person_index = 0;
max_coeffs = [-Inf -Inf -Inf];
min_coeffs = [ Inf  0  0];

%Reading into Database and Calculate MFCC
for i=1:speakerNum
	person_name = speakerData(i,1).name(1:end-4);
	
	file = ['.\threshold\',person_name];
	[s, fs] = wavread(file);
    v = mfcc(s, fs);
	DATABASE{7,i} = vqlbg(v);
	
end

%Scaling MFCC between 1-1260
for k=1:speakerNum
	vq = DATABASE{7,k};
	minc = min(vq(:));
	maxc = max(vq(:));
	
	[m, n] = size(vq);
	for i=1:m
		for j=1:n
			scaled(i,j) = floor((((vq(i,j)-minc)/(maxc-minc))*(1260-1))+1);
        end
    end
    
    DATABASE{8,k} = scaled;
	
    t = 1;
    for i=1
        for j=1:n
            x(1,t) = scaled(i,j);
            t=t+1;
        end
    end
    DATABASE{9,k} = x;
end


%Training using HMM
TRGUESS = ones(7,7) * eps;
TRGUESS(7,7) = 1;
for r=1:6
        TRGUESS(r,r) = 0.6;
        TRGUESS(r,r+1) = 0.4;    
end

EMITGUESS = (1/1260)*ones(7,1260);

for k=1:speakerNum
    fprintf ('Training %s... ',DATABASE{1,k});
    seqmat = DATABASE{9,k};
    [ESTTR,ESTEMIT]=hmmtrain(seqmat,TRGUESS,EMITGUESS,'Tolerance',.01,'Maxiterations',10,'Algorithm', 'BaumWelch');
    ESTTR = max(ESTTR,eps);
    ESTEMIT = max(ESTEMIT,eps);
    DATABASE{10,k}{1,1} = ESTTR;
    DATABASE{10,k}{1,2} = ESTEMIT;

	%Training each User's Threshold
    vs = DATABASE{8,k};
    t = 1;
    for i=1:3
        for j=1:n
            seq(1,t) = vs(i,j);
            t=t+1;
        end
    end  
    
    TRANS = DATABASE{5,k}{1,1};
    EMIS = DATABASE{5,k}{1,2};
    [ignore,logpseq] = hmmdecode(seq,TRANS,EMIS); 
    DATABASE{11,k} = logpseq;
    P=exp(logpseq);
    DATABASE{12,k} = P;
    fprintf('Done!!\n');
end
fprintf('Threshold Training Complete!!\n');

save DATABASE;
fprintf('Database Saved.\n\n\n');

end

