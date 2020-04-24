function [output] = concatenate_structures(input,dim)

% function [output] = concatenate_structures(input,dim)

if nargin==1
    dim = 1;
end

% takes an input structure array and concatenates the fields togther along
% the first dimension

fields = fieldnames(input);

for i=1:length(fields)
    
    output.(fields{i})= [];
    
    bStringField = isstr(input(1).(fields{i}));
    bStructure   = isstruct(input(1).(fields{i}));
    
    if bStructure
      
        if length(input(1).(fields{i}))==1
        
            for j=1:size(input,2); 
                b(j) = input(j).(fields{i});
            end

            c = concatenate_structures(b,dim);
            clear b;

            output.(fields{i}) = c;
        
        else   % does this structure have it's own shape
            
            for j=1:size(input,2);    
                b(j) = concatenate_structures(input(j).(fields{i}),dim);
            end
                c = concatenate_structures(b,dim);
            
            output.(fields{i}) = c;           
        end
        
    else
        
        for j=1:size(input,2);
       
            if ~bStringField
                
                num_rows = size(input(1).(fields{i}),1);
                num_dimensions = ndims(input(1).(fields{i}));
                
% %                 if num_dimensions==2 & (num_rows>1 & num_rows<10)
% %                     dim = 1;
% %                     %cat_dimension = ndims(input(1).(fields{i}))+1;
% %                 elseif num_dimensions==2 & num_rows==1001  % hack to cat boot variables back
% %                     dim = ndims(input(1).(fields{i}))+1;
% %                 else    
% %                     dim = 1;
% %                 end
              
                output.(fields{i}) = cat(dim,output.(fields{i}),input(j).(fields{i}));

            elseif bStringField
                %output.(fields{i}){j,1} = input(j).(fields{i});
                output.(fields{i}) = cat(1,output.(fields{i}),input(j).(fields{i}));
               
            elseif bStructure 
                output.(fields{i}){j} = input(j).(fields{i});
            end
        
        end
    end
end

