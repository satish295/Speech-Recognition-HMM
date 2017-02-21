clc; clear;

uiwait(msgbox({'This Speaker Recognition System was developed by Mehul Agarwal, Akshay Thombre and Rishabh Chaudhry.', '', 'Welcome... '},'Speaker Recognition using Hidden Markov Model'));
while (1==1)
    choice=menu('Speaker Recognition using Hidden Markov model',...
                'Generate and Recognize from File',...
                'Generate Database',...
                'Recognize from File',...
                'Exit');
    if (choice == 1)
        training();
        threshold()
        hmm_recog();     
    end
    
    if (choice == 2)
        training(); 
        threshold();
    end
    
    if (choice == 3)`
        hmm_recog();
    end
    if (choice == 4)
        clear choice
        break;
    end    
end

msgbox('Thank you for using the Speaker Recognition System.','Thank You','help');
