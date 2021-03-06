function [success] = huffmandecoding(bincode)
if exist('DecodedRunlength.txt')~=0
    delete DecodedRunlength.txt;
end
huffmanDcCoffients = {'00','010', '011', '100', '101', '110', '1110', ...
    '11110', '111110', '1111110', '11111110', '111111110'};
huffmanAcCoffients = {
    '00'               '01'               '100'              '1011'             '11010'            '1111000'          '11111000'         '1111110110'       '1111111110000010' '1111111110000011';...
    '1100'             '11011'            '1111001'          '111110110'        '11111110110'      '1111111110000100' '1111111110000101' '1111111110000110' '1111111110000111' '11111111100001000';...
    '11100'            '11111001'         '1111110111'       '111111110100'     '1111111110001001' '1111111110001010' '1111111110001011' '1111111110001100' '1111111110001101' '1111111110001110';...
    '111010'           '111110111'        '111111110101'     '1111111110001111' '1111111110010000' '1111111110010001' '1111111110010010' '1111111110010011' '1111111110010100' '1111111110010101';...
    '111011'           '1111111000'       '1111111110010110' '1111111110010111' '1111111110011000' '1111111110011001' '1111111110011010' '1111111110011011' '1111111110011100' '1111111110011101';...
    '1111010'          '11111110111'      '1111111110011110' '1111111110011111' '1111111110100000' '1111111110100001' '1111111110100010' '1111111110100011' '1111111110100100' '1111111110100101';...
    '1111011'          '111111110110'     '1111111110100110' '1111111110100111' '1111111110101000' '1111111110101001' '1111111110101010' '1111111110101011' '1111111110101100' '1111111110101101';...
    '11111010'         '111111110111'     '1111111110101110' '1111111110101111' '1111111110110000' '1111111110110001' '1111111110110010' '1111111110110011' '1111111110110100' '1111111110110101';...
    '111111000'        '111111111000000'  '1111111110110110' '1111111110110111' '1111111110111000' '1111111110111001' '1111111110111010' '1111111110111011' '1111111110111100' '1111111110111101';...
    '111111001'        '1111111110111110' '1111111110111111' '1111111111000000' '1111111111000000' '1111111111000010' '1111111111000011' '1111111111000100' '1111111111000101' '1111111111000110';...
    '111111010'        '1111111111000111' '1111111111001000' '1111111111001001' '1111111111001010' '1111111111001011' '1111111111001100' '1111111111001101' '1111111111001110' '1111111111001111';...
    '1111111001'       '1111111111010000' '1111111111010001' '1111111111010010' '1111111111010011' '1111111111010100' '1111111111010101' '1111111111010110' '1111111111010111' '1111111111011000';...
    '1111111010'       '1111111111011001' '1111111111011010' '1111111111011011' '1111111111011100' '1111111111011101' '1111111111011110' '1111111111011111' '1111111111100000' '1111111111100001';...
    '11111111000'      '1111111111100010' '1111111111100011' '1111111111100100' '1111111111100101' '1111111111100110' '1111111111100111' '1111111111101000' '1111111111101001' '1111111111101010';...
    '1111111111101011' '1111111111101100' '1111111111101101' '1111111111101110' '1111111111101111' '1111111111110000' '1111111111110001' '1111111111110010' '1111111111110011' '1111111111110100';...
    '1111111111110101' '1111111111110110' '1111111111110111' '1111111111111000' '1111111111111001' '1111111111111010' '1111111111111011' '1111111111111100' '1111111111111101' '1111111111111110'
    };
main = 1;
HuffmanDecoding = '';
DcDecode = '';
mid = '';
i = 0;

while(main == 1)
    run = 1;
    mid = '';
    if(length(bincode) >= 6)
       if(strmatch(bincode(1:6),'001010'))
            if(length(bincode) == 6)
                run = 0;
                mid = '0';
                main = 0;
            else
                bincode = bincode(7:end);
                mid = '0';
                run = 0;
            end
        end
    end
    if(run == 1)
        
        %%%%%%%%%%%%%%%%%%%%% DC Decoding %%%%%%%%%%%%%%%%%%%%
        DcCondition = 1;
        while(DcCondition == 1)
            for index = 1 : 1 : length(bincode)
                if(ismember(bincode(1:index),huffmanDcCoffients) == 1)
                    DcCondition = 0;
                    DcCategoryDecoding = strmatch(bincode(1:index),huffmanDcCoffients);
                    DcCategoryDecoding = DcCategoryDecoding - 1;
                    lengthDcBinary = index;
                    break
                end
                
            end
        end
        
        if(DcCategoryDecoding > 0)
            DcCofficientBinaryCode = bincode(lengthDcBinary+1:lengthDcBinary+DcCategoryDecoding);
            if(str2num(DcCofficientBinaryCode(1)) == 0)
                for i = 1 : 1 : length(DcCofficientBinaryCode)
                    if(str2num(DcCofficientBinaryCode(i)) == 1)
                        DcCofficientBinaryCode(i) = '0';
                    else
                        DcCofficientBinaryCode(i) = '1';
                    end
                end
                %%%%%%%%%%%%%%%%%%%% Negative Dc Decoded %%%%%%%%%%%%%%%%%%%%%%
                DcDecode = -bin2dec(DcCofficientBinaryCode);
            else
                %%%%%%%%%%%%%%%%%%%% Positive Dc Decoded %%%%%%%%%%%%%%%%%%%%%%
                DcDecode = bin2dec(DcCofficientBinaryCode);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            mid = DcDecode;
        else
            mid = '0';
        end
        
        %%%%%%%%%%%%%%%%%%%%% AC Decoding %%%%%%%%%%%%%%%%%%%%
        binaryAfterDc = bincode(lengthDcBinary+DcCategoryDecoding+1:end);
        AcRun = 1;
        if(strmatch(binaryAfterDc(1:4),'1010'))
            AcRun = 0;
            bincode = binaryAfterDc(5:end);
        end
        if(AcRun == 1)
        EOB = 1;
        position = 0;
        %AcCategory = 0;
        while(EOB == 1)
            binaryAfterDc;
            if(length(binaryAfterDc) == 4)
                break;
            end
            for index = 1 : 1 : length(binaryAfterDc)
                if(ismember(binaryAfterDc(1:index),huffmanAcCoffients)==1)
                    position = strmatch(binaryAfterDc(1:index),huffmanAcCoffients);
                    lengthAcBinary = index;
                    AcCategory = floor(position/16);
                    runlength = position - 16*AcCategory -1;
                    AcCategory = AcCategory + 1;
                    break;
                end

            end
            if(runlength == -1)
                runlength = position - 1;
                AcCategory = 1;
            end
            binaryAfterDc = binaryAfterDc(lengthAcBinary+1:end);
            if(str2num(binaryAfterDc(1)) == 0)
                for i = 1 : 1 : AcCategory
                    if(str2num(binaryAfterDc(i)) == 1)
                        binaryAfterDc(i) = '0';
                    else
                        binaryAfterDc(i) = '1';
                    end
                end
                %%%%%%%%%%%%%%%%%%%% Negative AC Number %%%%%%%%%%%%%%%%%%%%%%
                AcCategoryDecoded = -bin2dec(binaryAfterDc(1:AcCategory)) ;
            else
                %%%%%%%%%%%%%%%%%%%% Positive AC Number %%%%%%%%%%%%%%%%%%%%%%
                AcCategoryDecoded = bin2dec(binaryAfterDc(1:AcCategory)) ;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            
            test =  binaryAfterDc;
            oneBlock = [num2str(runlength),' ',num2str(AcCategoryDecoded)];
            mid = [num2str(mid),' ',oneBlock ];
            binaryAfterDc = binaryAfterDc(1+AcCategory:end);
            
            if(length(binaryAfterDc)>4)
                if(strmatch(binaryAfterDc(1:4),'1010'))
                    EOB = 0;
                else
                    bincode = binaryAfterDc(5:end);
                end
            end
        end
        if(length(strmatch(binaryAfterDc,'1010')) == 1)
            main = 0;
        else
            bincode = binaryAfterDc(5:end);
        end
        %dlmwrite('DecodedRunlength.txt',mid,'-append','delimiter',''); 
        end
    end
    mid;
   dlmwrite('DecodedRunlength.txt',mid,'-append','delimiter','');
    
end
success = 1;
end