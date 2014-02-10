
fileID = fopen('test.txt');
A = textscan(fileID, '%f %f %*f %*f');
fclose(fileID);
celldisp(A);