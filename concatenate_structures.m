function [output] = concatenate_structures(input,dim)

% function [output] = concatenate_structures(input,dim)

% Copyright 2020 Dorion Liston
%
% Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
%
% The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
%
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

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
<<<<<<< HEAD

        else   % does this structure have it's own shape

            for j=1:size(input,2);
=======
        
        else   % does this structure have its own shape
            
            for j=1:size(input,2);    
>>>>>>> 85fbc77e007a818be40551e9b1a2c8b95d0a6963
                b(j) = concatenate_structures(input(j).(fields{i}),dim);
            end
                c = concatenate_structures(b,dim);

            output.(fields{i}) = c;
        end

    else

        for j=1:size(input,2);

            if ~bStringField

                num_rows = size(input(1).(fields{i}),1);
                num_cols = size(input(1).(fields{i}),2);
                num_dimensions = ndims(input(1).(fields{i}));

                if (num_dimensions==2 && num_cols==7 && num_rows==7)  % hack to cat boot variables back
                  dim = ndims(input(1).(fields{i}))+1;
                else
                  dim = 1;
                end

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
