unit StartTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  ADOConnection1, ADOQuery1, ADOStoredProc1, Vcl.DBCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.TabNotBk, Vcl.ExtCtrls, TypInfo;

type
  TStartTaskForm = class(TForm)
    ADOStoredProcStart: TADOStoredProc1;
    DataSourceStart: TDataSource;
    ADOQueryStart: TADOQuery1;
    ADOConnStart: TADOConnection1;
    TabbedNotebook1: TTabbedNotebook;
    GroupBox2: TGroupBox;
    GroupBox1: TGroupBox;
    YesButton: TSpeedButton;
    StatMemo: TMemo;
    SaveEdit: TEdit;
    Panel1: TPanel;
    GroupBox3: TGroupBox;
    ExitButton: TSpeedButton;
    InfNamewrkLabel: TDBText;
    NoButton: TSpeedButton;
    SaveBut: TSpeedButton;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    function  IsSomeFiles(s:string):tstringlist;
    function CreateInfList(tfomsfilename:string):boolean;
    procedure YesButtonClick(Sender: TObject);
    procedure NoButtonClick(Sender: TObject);
    procedure SaveButClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartTaskForm: TStartTaskForm;
  moreOneF:boolean;

implementation

uses
Unit1;

{$R *.dfm}

procedure TStartTaskForm.ExitButtonClick(Sender: TObject);
begin
starttaskform.Close;
end;

procedure TStartTaskForm.FormCreate(Sender: TObject);
begin
//������ ����������� � ��, �������� �������
    if MainForm.ReadConnStr<>'not_' then
    begin
    ADOConnStart.Close;
    ADOConnStart.ConnectionString:=MainForm.ReadConnStr;
      try
        ADOConnStart.Open;
      except //showmessage('������ ����������� �����������!');
      end;
    end;
//��������� �������� ��������������
    infNamewrklabel.DataSource:=MainForm.DataSource;
    infNamewrklabel.DataField:='��� ����������';
//������ ������ ����� �� ����� �� ��������� - ����
moreOneF:=false;
end;

function TStartTaskForm.IsSomeFiles(s:string):tstringlist;
var
ress:tstringlist;
k,i:integer;
firsttime:boolean;
st:string;
begin
 ress:=tstringlist.create;
firsttime:=true;
k:=0;
for i:=1 to Length(s) do begin
if s[i]='|' then
	begin
 	 if firsttime then
    begin
     ress.add(copy(s,1,i-1));
     firsttime:=false;
     k:=i;
    end
    	else begin
       ress.add(copy(s,k+1,i-pos('|',s,k)-1));
       k:=i;
     end;
	end;
 end;
 result:=ress;
end;

procedure TStartTaskForm.NoButtonClick(Sender: TObject);
var ind:integer;
begin
ind:=statmemo.lines.count-1;
 if statmemo.Lines[ind] = '��� ������ ��� ������ ��������������, ��������� ����������?'
  then statmemo.lines.Add('�������� ����� ��������� ��������...');

  if statmemo.Lines[ind] = '������������ � ������������ ���������?'
  then
    statmemo.lines.Add('��������� ������������ ��������� ��� ������ ������?');

  if statmemo.Lines[ind] = '��������� ������������ ��������� ��� ������ ������?'
  then
    statmemo.lines.Add('�������� ����� ��������� ��������...');

end;

procedure TStartTaskForm.SaveButClick(Sender: TObject);
var  OpenDialog: TFileOpenDialog;
begin
 OpenDialog := TFileOpenDialog.Create(MainForm);
try
  OpenDialog.Options := OpenDialog.Options + [fdoPickFolders];
  if not OpenDialog.Execute then
    Abort;

  saveedit.Text := OpenDialog.FileName;

finally
  OpenDialog.Free;
end;

end;

procedure TStartTaskForm.YesButtonClick(Sender: TObject);
var ind:integer;
begin
ind:=statmemo.lines.count-1;
 if statmemo.Lines[ind] = '��� ������ ��� ������ ��������������, ��������� ����������?'
  then statmemo.lines.Add('�������� ����� ��������� ����������...');

  if statmemo.Lines[ind] = '������������ � ������������ ���������?'
  then begin
    statmemo.lines.Add('�������� ������ ���������...');
    statmemo.lines.Add('�������� ����� ��������� ��������������...');
  end;

    if statmemo.Lines[ind] = '��������� ������������ ��������� �� ������ ������?'
      then begin
        statmemo.lines.Add('���������� ��������� �� ������ ������...');
        statmemo.lines.Add('�������� ����� ��������� ��������������...');
       end;
end;

function  TStartTaskForm.CreateInfList(tfomsfilename:string):boolean;
var nowdate:string;
tes:boolean;
begin
     { nowdate:='test';
      ADOQueryStart.Close;
     //���� ��� ������� ������� ��������� �� ����� ����� ���� ���� �������������
      ADOQueryStart.SQL.Add('if not exists (select * from sysobjects where name=''inf_disp'' and xtype=''U'') SELECT * INTO Inf_Disp FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0; Database='+tfomsfilename+''', ''select * from [����1$A5:BZ]'') else exec sp_rename ''Inf_Disp'', ''Inf_Disp_'+nowdate+'''');
     //  ADOQueryStart.SQL.Add('delete from Inf_Disp where [�_�/�] is null');
       ADOQueryStart.Open;  }
end;

procedure TStartTaskForm.FormShow(Sender: TObject);
var inftype:string;
begin

if infnamewrklabel.Caption<>'' then
   begin
   statmemo.lines.Clear;
   statmemo.lines.Add('������� ����������: '+TrimRight(infnamewrklabel.Caption));
   ADOQueryStart.SQL.Clear;
   ADOQueryStart.Close;
   //�������� �� ������� ���������� ������
   ADOQueryStart.SQL.Add('select * from Infs ins left join sp_status ss on ins.status_code=ss.st_code left join sp_type sps on ins.[type]=sps.[tname] where name='''+infnamewrklabel.Caption+'''');
   ADOQueryStart.Open;
      if IsSomeFiles(ADOQueryStart.FieldByName('Tfoms_path').AsString).Count>0 then
         moreOneF:=true;
      //���������� ��������������� ����
        statmemo.lines.Add('������ ����������: '+ADOQueryStart.FieldByName('st_name').AsString);
     //�������� ������� �����������
      if adoquerystart.FieldByName('st_code').AsInteger = 101
       then statmemo.lines.Add('������� ��������� ���������� �� �������...');
      //�������� �� ������� ������ �������
      if MainForm.CheckTableExist(adoquerystart.FieldByName('tremark').AsString) then
       begin
        statmemo.lines.Add('������� ��������� ������� ����������...');
        statmemo.lines.Add('������������ � ������������ ���������?');
       end
        else
         begin
          statmemo.lines.Add('��� ������ ��� ������ ��������������, ��������� ����������?');

         end;
   end
    else statmemo.lines.Add('���������� �� �������!') ;
end;

end.
