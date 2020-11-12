function x = binfileload( path, IDname,IDnum,CHnum,N,Nstart )
%x = binfileload( path, IDname,IDnum,CHnum,N,Nstart )
%  This function loads single-precision, little-endian binary files without header information.
% The file name has the format: IDnameIDnum_CHnum.bin, where IDnum and CHnum have %03.0f format. 
% Example: % ID001_004.bin
% path: file path, e.g., 'C:\Data'
% IDname: Root test name, e.g., 'ID'
% IDnum: Test number, e.g., 4
% CHnum: Channel number, e.g., 12
% Nstart: number of samples to offset from beginning of file.  Default is beginning of file
% N: Number of samples to read.  Default is the entire file
% KLG, 11/14/13

if nargin<6
    Nstart=0;
end

if nargin<5
    N=inf;
end


filename=[path,'\',IDname,sprintf('%03.0f',IDnum),'_',sprintf('%03.0f',CHnum),'.bin'];

% Read in data

fid=fopen(filename,'r');
Nstart=Nstart*4;   % Convert from samples to bytes
fseek(fid,Nstart,'bof');
x=fread(fid,N,'single');
fclose(fid);


end

