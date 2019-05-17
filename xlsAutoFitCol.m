function xlsAutoFitCol(filename,sheetname,varargin)

%set the column to auto fit
%

%xlsAutoFitCol(filename,sheetname,range)
% Example:
%xlsAutoFitCol('filename','Sheet1','A:F')

options = varargin;

range = varargin{1};
    
[fpath,file,ext] = fileparts(char(filename));
if isempty(fpath)
    fpath = pwd;
end
Excel = actxserver('Excel.Application');
set(Excel,'Visible',0);
Workbook = invoke(Excel.Workbooks, 'open', [fpath filesep file ext]);


sheet = get(Excel.Worksheets, 'Item',sheetname);
invoke(sheet,'Activate');

ExAct = Excel.Activesheet;
   
ExActRange = get(ExAct,'Range',range);
ExActRange.Select;

invoke(Excel.Selection.Columns,'Autofit');

invoke(Workbook, 'Save');
invoke(Excel, 'Quit');
delete(Excel);

