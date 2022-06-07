function [frame_out, state_out] = frame(symb, p, state_in);

% [frame_out, frame_state] = frame(symb, p, frame_state);
%
% Takes raw symbol stream and detects frames.  Frames with errors are discarded.
%
% Inputs:
%	symb	Input symbols
%	p	Parameters
%		.N	Number of symbols per frame
%		.sync	Sync pattern
%	frame_state

if isempty(state_in),
  state.mode = 0;	
  state.match = 0;
  state.symb = zeros(p.N,1);
  state.symb_N = 0;
  state.frame_ready = 0;
else
  state = state_in;
end

frame_out = [];

% Process all symbols
for ii=1:length(symb),
  symb1 = symb(ii);
  
  % Check which mode
  if state.mode == 0,
    % Searching for sync
    if symb1 == p.sync(state.match+1),
      % Matched a sync character
      state.match = state.match + 1;
      if state.match == length(p.sync),
	% Matched complete sync character.  Go to frame mode.
	state.mode = 1;
	state.symb_N = 0;
	
	if state.frame_ready == 1,
	  % Return frame.  Enclosed by SYNCs
	  frame_out = state.symb;
	  state.frame_ready = 0;
	end
      
      end
    else
      % Sync mismatch
      state.mode = 0;
      % Do we have a frame?
      if state.frame_ready == 1,
	% Error condition
	frame_out = -1;
	state.frame_ready = 0;
      end

      if symb1 == p.sync(1),
	state.match = 1;
      else
	state.match = 0;
      end
    end
  else
    % Have sync from before.  Fill frame
    state.symb_N = state.symb_N + 1;
    state.symb(state.symb_N) = symb1;
    if (state.symb_N == p.N)
      % We have a full frame
      state.frame_ready = 1;
      state.mode = 0;
      state.match = 0;
      state.symb_N = 0;
    end
  end
end

state_out = state;
  
  
  
  