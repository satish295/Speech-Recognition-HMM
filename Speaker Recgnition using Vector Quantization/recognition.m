clc; clear;

uiwait(msgbox({'This Speaker Recognition System was developed by Mehul Agarwal, Akshay Thombre and Rishabh Chaudhry.', '', 'Welcome... '},'Speaker Recognition using Vector Quantization'));
while (1==1)
    choice=menu('Speaker Recognition using Vector Quantization',...
                'Generate and Recognize from File',...
                'Generate Database',...
                'Recognize from File',...
                'Exit');
    if (choice == 1)
        train();
        threshold();
        test();     
    end
    
    if (choice == 2)
        train();
        threshold();
    end
    
    if (choice == 3)
        test();
    end
    if (choice == 4)
        clear choice
        break;
    end    
end

close all;
msgbox('Thank you for using the Speaker Recognition System.','Thank You','help');
