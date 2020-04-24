function [output] = realign_data_structure(data, WRT, interval)

  % [output] = realign_data_structure(data, WRT, interval)
  %
  % run realign.m on all fields within a stereotypical data structure.  this
  % data structure includes a .timestamp field, which is handled as an
  % individual case.
  %
  % function [output] = realign_data_structure(data, WRT, interval)
  %
  % SEE ALSO:
  %
  %   concatenate_structures

  % realign_data_structure
  %        .timestamp
  %           realign_structure
  %               .vel
  %               .deg

  % Copyright 2020 Dorion Liston
  %
  % Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  %
  % The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
  %
  % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  if length(WRT)>1 % loop through all the initial timestamps

    for i=1:size(WRT,1)
      output(i) = realign_data_structure(data,WRT(i),interval);
    end
    output = concatenate_structures(output);

  else

      if size(data.timestamp,1) > size(data.timestamp,2)
        data = transpose_data_structure(data);
      end

      t      = double(data.timestamp);     % identify the hard-coded timestamp field
      WRT    = double(WRT);
      fields = fieldnames(data);

      for i=1:length(fields)

          if strcmp(fields{i},'timestamp')

              [bs,t_realigned]   = realign(t,WRT,data.(fields{i}),interval);
              output.(fields{i}) = t_realigned;
              %output.(fields{i}) = bs;  % we want the original timestamps, for now

          elseif isstruct(data.(fields{i}))
              output.(fields{i}) = realign_structure(t,WRT,data.(fields{i}),interval);
          else
              output.(fields{i}) = realign(t,WRT,data.(fields{i}),interval);
          end

      end

  end

end

function [output] = realign_structure(t,WRT,data,interval)

% second level of this script, parameterized to handle the problem
% differently.

% specify four input argments, including the timestamp.

  fields = fieldnames(data);

  for i=1:length(fields)

      if isstruct(data.(fields{i}))
          output.(fields{i}) = realign_structure(t,WRT,data.(fields{i}),interval);
      else
          output.(fields{i}) = realign(t,WRT,data.(fields{i}),interval);
      end

  end

end
