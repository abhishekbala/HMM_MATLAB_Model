voltage = data(1:2:length(data));
current = data(2:2:length(data));
averageVoltage = (min(voltage)+max(voltage))/2;
peakToPeak = max(voltage)-min(voltage);
 
for i = 1:length(voltage)
    voltage(i) = voltage(i)-averageVoltage;
    voltage(i) = voltage(i)*340/peakToPeak;
end 
plot(voltage);

for i = 1:length(current)
    current(i) = current(i)-492;   %to be verified
    current(i) = current(i)/15.5;                             % to normalize
end

plot(current);

power = zeros(1,length(voltage));
for i = 1:length(voltage)
power(i) = current(i)*voltage(i);
end
averagePower = 0;
%for i = 1:17
    %averagePOwer = 