 % ascii_test_recv.m
%	Tests the complete receiver using an ASCII message.

% Set up standard parameters as you did before 

%% System parameters
param = system_param;

% Ascii message to send (feel free to use your own message here!)
ascii_text = 'Stand by .... Stand by .... Stand by .... Four scoreand seven years ago our fathers brought forth on this continent a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation, so conceived and so dedicated, can long endure. We are met on a great battle-field of that war. We have come to dedicate a portion of that field, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But, in a larger sense, we can not dedicate, we can not consecrate, we can not hallow, this ground. The brave men, living and dead, who struggled here, have consecrated it, far above our poor power to add or detract. The world will little note, nor long remember what we say here, but it can never forget what they did here. It is for us the living, rather, to be dedicated here to the unfinished work which they who fought here have thus far so nobly advanced. It is rather for us to be here dedicated to the great task remaining before us, that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion, that we here highly resolve that these dead shall not have died in vain, that this nation, under God, shall have a new birth of freedom, and that government: of the people, by the people, for the people, shall not perish from the earth.';

% Convert the ascii message to 4PSK symbols
frm =  ascii_to_symb_frame(2, param.frame.sync, param.frame.N, ascii_text);
symb = frm(:);
as = 1;
at = 1;
Ns = 192;
n = 1:Ns;
% Generate signal from symbols
[s s_debug] = make_signal_4psk(param.fs, param.f0, param.ft, param.cps, param.h_ps, as, at, symb);
Nb = floor(length(s)/Ns);
% Make signal into blocks
sb = reshape(s(1:Ns*Nb), Ns, Nb);

% Intialize state of frame synchronization code
frame_state = [];

% Initialize DDC and STR
ddc_state = ddc_init(param.ddc);
str_state = str_init(param.str);

% Process the waveform s as before ...
for ii=1:Nb
  % Get a single block
  x = sb(:, ii);

  % Add your code here!!!
  
  % Digital down converter
  [Ib Qb ddc_state ddc_debug] = ddc(x, ddc_state);

  % Symbol timing recovery
  [si str_state str_debug] = str(Ib, Qb, str_state);

  % Sample at optimal points
  i =1;
  for e=1:Ns
      if (si(e)==1)
          Ib_s(i)=Ib(e);
          Qb_s(i)=Qb(e);
          i=i+1;
      end
      
  end
  
  % Decision block
  for e=1: i-1
      if (Ib_s(e) > 0 && Qb_s(e) > 0)
          symb_out(e) = 0;
      end
      
      if (Ib_s(e) > 0 && Qb_s(e) < 0)
          symb_out(e) = 2;
      end
      
      if (Ib_s(e) < 0 && Qb_s(e) > 0)
          symb_out(e) = 1;
      end
      
      if (Ib_s(e) < 0 && Qb_s(e) < 0)
          symb_out(e) = 3;
      end
  end
  
  
  % Result should now be a vector of symbols (values 0-3) estimated from
  % the optimal sample points for the current block.  I assume here this vector is called
  % "symb_out"
  
  % Recover frames.  This code only prints something when a complete frame is ready.
  [frame_out frame_state] = frame(symb_out, param.frame, frame_state);
  if ~isempty(frame_out),
    fprintf('%s', symb_to_ascii(2, frame_out));
  end
  %pause;
  
end
 
