function [output] = downsample_data_structure(data,multiplier)

  % function [output] = downsample_data_structure(data,multiplier)

  % Copyright 2020 Dorion Liston
  %
  % Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  %
  % The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
  %
  % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  ind      = 1:size(data.timestamp,2);         % same size as data structure
  [~,t0]   = min(abs(data.timestamp),[],2);    % where is the zero value
  b        = mod(ind - t0(1),multiplier)==0;
  output   = downsample(data,b);
end

function [output] = downsample(data,b)
  fields = fieldnames(data);

  for i=1:length(fields)
    if isstruct(data.(fields{i}))
        output.(fields{i}) = downsample(data.(fields{i}),b);
    else
        output.(fields{i}) = data.(fields{i})(:,b);
    end
  end
end
