function prbs_signal=PRBS_Signal(min_Duration,max_Duration,min_DutyCycle,max_DutyCycle,Ts,Length)
time = 0:Ts:Length-Ts;
prbs_signal = zeros(size(time));
i = 1;
while i <= length(time)
    pulse_length = randi([min_Duration max_Duration]);      % Total period duration
    if i + pulse_length > length(time)
        pulse_length = length(time) - i + 1;
    end
    
    duty = rand() * (max_DutyCycle-min_DutyCycle) + min_DutyCycle;          % Random duty cycle from 30% to 70%
    on_time = round(pulse_length * duty);
    
    prbs_signal(i:i+on_time-1) = 12;     % ON period
    prbs_signal(i+on_time:i+pulse_length-1) = 0;  % OFF period
    
    i = i + pulse_length;
end

end