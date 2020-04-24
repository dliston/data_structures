function [output,t_output] = realign(t,WRT,data,interval)

  % function realign(t,WRT,data,interval);
  %
  % Aligns input data arrays with the timing matrix t.
  %
  % dbl 7/19/03
  %
  % re-worked the original version 01/14/09, 7/10/09

  % Assumes:
  %
  % 1. Rows are trials, columns are time.
  % 2. Time is evenly sampled.

  % Copyright 2020 Dorion Liston
  %
  % Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
  %
  % The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
  %
  % THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

  if ~isequal( size(t), size(data) )
      if isequal( size(t), [1 size(data,2)] )
          t = t(ones(size(data,1),1),:);
      else
          disp('Timing matrix not the same size as data.');
          return;
      end
  end

  if isequal( size(WRT), [1 1] )           % Resize scalar to a vector.
      WRT = WRT(ones(size(data,1),1),:);
  end

  % Exact
  %dt        = mode(unique(diff(t,[],2)));     % Robust given Assumption 2.
  % this earlier line didn't work for time samples with frame-to-frame jitter
  % in the microsecond decimal places
  delta = unique(diff(t,1,2));
  delta = delta(~isnan(delta));
  dt    = median(delta);

  %dt        = median(unique(diff(t,[],2)));
  %dt        = mode(unique(diff(t,1,2)));     % Robust given Assumption 2.
  t_aligned = t-WRT(:,ones(1,size(data,2)));  % Subtract measurement time.

  % Convert to column subscript, after rounding away jitter.
  interval  = round( interval ./ dt );     % adios, time.

  interval_length = diff(interval)+1;
  output          = ones(size(data,1),interval_length) .* nan;

  % Convert to column indices of the output matrix.
  output_col = round( t_aligned ./dt ) - interval(1) +1;
  b          = output_col>=1 & output_col<=interval_length;

  % Now, just extract the indices needed.
  row = (1:size(data,1))';
  row = row(:,ones(1,size(data,2)));

  col = 1:size(data,2);
  col = col(ones(size(data,1),1),:);

  % convert subscripts to a linear index
  input_index  = sub2ind(size(data),row(b),col(b));
  output_index = sub2ind(size(output),row(b),output_col(b));

  output(output_index) = data(input_index);

  if nargout==2
      t_output               = ones(size(output)) .* nan;
      t_output(output_index) = t_aligned(input_index);
  end

end
