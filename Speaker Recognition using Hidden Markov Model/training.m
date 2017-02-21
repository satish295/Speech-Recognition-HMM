function training()

clc; clear;

waveDir='.\train\';
speakerData = dir(waveDir);
speakerData(1:2) = [];
speakerNum=length(speakerData); %speakerNum

eps=.000001;
ufft = [1 5 6 8 10];
fprintf ('Reading and Training Database ...\n');
DATABASE = cell(0,0);
person_index = 0;
max_coeffs = [-Inf -Inf -Inf];
min_coeffs = [ Inf  0  0];

%Reading into Database and Calculate MFCC
for i=1:speakerNum
	person_name = speakerData(i,1).name(1:end-4);
	DATABASE{1,i} = person_name;
	
	file = ['.\train\',person_name];
	[s, fs] = wavread(file);
    v = mfcc(s, fs);
	DATABASE{2,i} = vqlbg(v);
	
end

%Scaling MFCC between 1-1260
for k=1:speakerNum
	vq = DATABASE{2,k};
	minc = min(vq(:));
	maxc = max(vq(:));
	
	[m, n] = size(vq);
	for i=1:m
		for j=1:n
			scaled(i,j) = floor((((vq(i,j)-minc)/(maxc-minc))*(1260-1))+1);
        end
    end
    
    DATABASE{3,k} = scaled;
	
    t = 1;
    for i=1
        for j=1:n
            x(1,t) = scaled(i,j);
            t=t+1;
        end
    end
    DATABASE{4,k} = x;
end


%Training using HMM
TRGUESS = ones(7,7) * eps;
TRGUESS(7,7) = 1;
for r=1:6
        TRGUESS(r,r) = 0.6;
        TRGUESS(r,r+1) = 0.4;    
end

EMITGUESS = (1/1260)*ones(7,1260);

for i=1:speakerNum
    fprintf ('Training %s... ',DATABASE{1,i});
    seqmat = DATABASE{4,i};
    [ESTTR,ESTEMIT]=hmmtrain(seqmat,TRGUESS,EMITGUESS,'Tolerance',.01,'Maxiterations',10,'Algorithm', 'BaumWelch');
    ESTTR = max(ESTTR,eps);
    ESTEMIT = max(ESTEMIT,eps);
    DATABASE{5,i}{1,1} = ESTTR;
    DATABASE{5,i}{1,2} = ESTEMIT;
    fprintf('Done!!\n');
end
fprintf('Database Training Complete!!\n');

save DATABASE;
fprintf('Database Saved.\n');

end

