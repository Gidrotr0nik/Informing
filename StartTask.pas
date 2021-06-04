unit StartTask;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Data.Win.ADODB,
  ADOConnection1, ADOQuery1, ADOStoredProc1, Vcl.DBCtrls, Vcl.Buttons,
  Vcl.ComCtrls, Vcl.TabNotBk, Vcl.ExtCtrls, TypInfo, Clipbrd, UITypes;

type
  TStartTaskForm = class(TForm)
    ADOStoredProcStart: TADOStoredProc1;
    DataSourceStart: TDataSource;
    ADOQueryStart: TADOQuery1;
    ADOConnStart: TADOConnection1;
    WorkingTabNote: TTabbedNotebook;
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
    GroupBox4: TGroupBox;
    ArchNameLabel: TLabel;
    Archedit: TEdit;
    ArchHelpText: TMemo;
    AddArchButton: TSpeedButton;
    procedure ExitButtonClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CreateInfList(tfomsfilename:string;rename:boolean;oldexist:boolean;tname:string;tCode:integer);
    procedure YesButtonClick(Sender: TObject);
    procedure NoButtonClick(Sender: TObject);
    procedure SaveButClick(Sender: TObject);
    procedure Stat_101_worker;
    procedure Stat_111_worker;
    procedure Stat_201_worker;
    procedure Stat_211_worker;
    procedure Stat_221_worker;
    procedure Stat_300_worker;
    procedure Stat_301_worker;
    procedure Stat_600_worker;
    procedure WorkingTabNoteChange(Sender: TObject; NewTab: Integer;
      var AllowChange: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AddArchButtonClick(Sender: TObject);
    function GetTfomsPath(userpth:string):string;
    procedure FullInfList(tcode:integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  StartTaskForm: TStartTaskForm;
  stcode:integer;

implementation

uses
Unit1;

{$R *.dfm}

procedure TStartTaskForm.ExitButtonClick(Sender: TObject);
begin
starttaskform.Close;
end;

procedure TStartTaskForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
workingtabnote.PageIndex:=0;
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
end;


procedure TStartTaskForm.NoButtonClick(Sender: TObject);
var ind:integer;
begin
ind:=statmemo.lines.count-1;
 if statmemo.Lines[ind] = '��� ������ ��� ������ ��������������, ��������� ����������?'
    then statmemo.lines.Add('�������� ����� ��������� ��������...');

  if statmemo.Lines[ind] = '������������ � ������������ ���������?'
    then statmemo.lines.Add('��������� ������������ ��������� ��� ������ ������?');

  if statmemo.Lines[ind] = '��������� ������������ ��������� ��� ������ ������?'
    then statmemo.lines.Add('�������� ����� ��������� ��������...');

  if statmemo.Lines[ind] = '������ ������� ������ ������?'
      then statmemo.lines.Add('�������� ������ ���������� ��������...');


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

function TStartTaskForm.GetTfomsPath(userpth:string):string;
var fname:string;
begin
fname:=extractfilename(userpth);
 ADOQueryStart.Close;
 ADOQueryStart.SQL.Text:='select WDpth from settings';
 ADOQueryStart.Open;

result:=adoquerystart.FieldByName('WDpth').AsString+'\����������\'+TrimRight(infnamewrklabel.Caption)+'\'+fname;
end;

procedure TStartTaskForm.FullInfList(tcode:integer);
var tproc,mat,mto:string;
begin
 ADOQueryStart.Close;
 ADOQueryStart.SQL.Text:='select tproc from sp_type where tcode='+inttostr(tcode);
 ADOQueryStart.Open;
 tproc:=adoquerystart.FieldByName('tproc').AsString;

 ADOQueryStart.Close;
 ADOQueryStart.SQL.Text:='select * from infs where name='''+infnamewrklabel.Caption+'''';
 ADOQueryStart.Open;
  mat:=adoquerystart.FieldByName('MounthAt').AsString;
  mto:=adoquerystart.FieldByName('MounthTo').AsString;

   statmemo.lines.Add('�������� ������ ��������������...');
   statmemo.lines.Add('���������� ��������� ��� ������ ��������� �����...');

   ADOStoredProcStart.ProcedureName:= Trim(tproc);
       ADOStoredProcStart.Parameters.Refresh;
       ADOStoredProcStart.Parameters.ParamByName('@mounthAt').Value:=mat;
       ADOStoredProcStart.Parameters.ParamByName('@mounthTo').Value:=mto;
       application.ProcessMessages;
       ADOStoredProcStart.ExecProc;


     adoquerystart.Close;
     ADOQueryStart.SQL.Clear;
     ADOQueryStart.SQL.text:='update infs set status_code=''201'' where name='''+infnamewrklabel.Caption+''' select 1';
     ADOQueryStart.Open;

   statmemo.lines.Add('�������� ������ ������� ���������!');
   MainForm.StatusBar.Panels[0].Text:='������ ���������� '+TrimRight(infnamewrklabel.Caption)+' ������ �������!';
   messagedlg( '������ ���������� '+Trim(infnamewrklabel.Caption)+' ������� ������!' , mtInformation, [mbOk], 0, mbOk);

  StartTaskForm.Close;
  mainform.ADOQuery.Close;
  mainform.ADOQuery.open;
end;


procedure TStartTaskForm.YesButtonClick(Sender: TObject);
var ind,tcode:integer;
tname,tpath:string;
begin
ind:=statmemo.lines.count-1;
ADOQueryStart.Close;
ADOQueryStart.SQL.Text:='select * from Infs ins left join sp_status ss on ins.status_code=ss.st_code left join sp_type sps on ins.[type]=sps.[tname] where name='''+infnamewrklabel.Caption+'''';
ADOQueryStart.Open;
tname:=adoquerystart.FieldByName('tremark').AsString;
tpath:=adoquerystart.FieldByName('Tfoms_path').AsString;
tcode:=adoquerystart.FieldByName('tcode').AsInteger;
// ����� - ������ 101
 if statmemo.Lines[ind] = '��� ������ ��� ������ ��������������, ��������� ����������?'
  then CreateInfList(GetTfomsPath(tpath),false,false,Trim(tname),tcode);

 if statmemo.Lines[ind] = '������������ � ������������ ���������?'
  then CreateInfList(GetTfomsPath(tpath),false,true,Trim(tname),tcode);

 if statmemo.Lines[ind] = '��������� ������������ ��������� ��� ������ ������?'
  then CreateInfList(GetTfomsPath(tpath),true,true,Trim(tname),tcode);

// �������� - ������ 111
  if statmemo.Lines[ind] = '������ ������� ������ ������?'
      then FullInfList(tcode);

end;

procedure TStartTaskForm.AddArchButtonClick(Sender: TObject);
var tnm,id:string;
begin
if Archedit.text<>'' then
  begin
   ADOQueryStart.Close;
   ADOQueryStart.SQL.Text:='select tremark,inf_id from Infs ins left join sp_type sps on ins.[type]=sps.[tname] where name='''+infnamewrklabel.Caption+'''';
   ADOQueryStart.Open;

   tnm:=adoquerystart.FieldByName('tremark').AsString;
   id:=adoquerystart.FieldByName('inf_id').AsString;
   tnm:=TrimRight(tnm);

   ADOQueryStart.Close;
   ADOQueryStart.SQL.Text:='exec sp_rename '''+tnm+''','''+tnm+'_'+Archedit.text+'_'+id+''' select 1';
   ADOQueryStart.Open;

   ADOQueryStart.Close;
   ADOQueryStart.SQL.Text:='update infs set status_code=301 where name='''+infnamewrklabel.Caption+''' select 1';
   ADOQueryStart.Open;

   StartTaskForm.Close;
   MainForm.StatusBar.Panels[0].Text:='���������� '+TrimRight(infnamewrklabel.Caption)+' ���������� � ����� �������!';
   messagedlg( '���������� '+infnamewrklabel.Caption+' ������� ���������� � �����!' , mtInformation, [mbOk], 0, mbOk);
   mainform.ADOQuery.Close;
   mainform.ADOQuery.Open;
  end
    else messagedlg( '��� �� ����� ���� ������! ������� ��� �������.' , mtError, [mbOk], 0, mbOk);
end;

procedure  TStartTaskForm.CreateInfList(tfomsfilename:string;rename:boolean;oldexist:boolean;tname:string;tCode:integer);
var nowdate,renamer:string;
    tes:boolean;
begin
      nowdate:=FormatDateTime('dd_mm_yyyy', Now);
      ADOQueryStart.Close;

      if oldexist then
        begin
          if rename then
                      begin
                        statmemo.lines.Add('���������� ��������� �� ������ ������...');
                        renamer:='exec sp_rename '''+tname+''','''+tname+'_'+nowdate+''' select 1';
                        statmemo.lines.Add('��������� ������� ������������� � '+tname+'_'+nowdate);
                      end
            else
              begin
                statmemo.lines.Add('�������� ������ ���������...');
                renamer:='drop table '+tname+' select 1';
              end;
        end
         else renamer:='select 1';



      adoquerystart.Close;
        ADOQueryStart.SQL.Clear;
        ADOQueryStart.SQL.add(renamer);
      ADOQueryStart.Open;

   
       statmemo.lines.Add('�������� ����� ��������� ����������...');
       statmemo.lines.Add('���������� ��������� ��� ������ ��������� �����...');

    application.ProcessMessages;
    starttaskform.Cursor:=crHourGlass;
       ADOStoredProcStart.ProcedureName:='CreateStruct';
       ADOStoredProcStart.Parameters.Refresh;
       ADOStoredProcStart.Parameters.ParamByName('@TfomsFile').Value:=tfomsfilename;
       ADOStoredProcStart.Parameters.ParamByName('@Tcode').Value:=tCode;
     application.ProcessMessages;
       ADOStoredProcStart.ExecProc;

    application.ProcessMessages;

     adoquerystart.Close;
     ADOQueryStart.SQL.Clear;
     ADOQueryStart.SQL.text:='update infs set status_code=''111'' where name='''+infnamewrklabel.Caption+''' select 1';
     ADOQueryStart.Open;

    starttaskform.Cursor:=crDefault;
    statmemo.lines.Add('�������� ��������� ������� ���������!');



   MainForm.StatusBar.Panels[0].Text:='����� ��������� ��� ���������� '+TrimRight(infnamewrklabel.Caption)+' ������� �������!';
   messagedlg( '��������� ��� '+infnamewrklabel.Caption+' ������� �������!' , mtInformation, [mbOk], 0, mbOk);

  StartTaskForm.Close;
  mainform.ADOQuery.Close;
  mainform.ADOQuery.open;
end;

procedure TStartTaskForm.Stat_101_worker;
begin
statmemo.lines.Add('������� ��������� ���������� �� �������...');
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
end;


procedure TStartTaskForm.Stat_111_worker;
begin
statmemo.lines.Add('������ ��������������� �� ������.');
statmemo.lines.Add('������ ������� ������ ������?');
end;

procedure TStartTaskForm.Stat_201_worker;
begin
 //code
end;

procedure TStartTaskForm.Stat_211_worker;
begin
//code
end;

procedure TStartTaskForm.Stat_221_worker;
begin
//code
end;

procedure TStartTaskForm.Stat_300_worker;
begin
statmemo.lines.Add('������������� ��������� ������ ���������� � �����.');
end;

procedure TStartTaskForm.Stat_301_worker;
begin
  //code
end;

procedure TStartTaskForm.Stat_600_worker;
begin
  //code
end;

procedure TStartTaskForm.WorkingTabNoteChange(Sender: TObject; NewTab: Integer;
  var AllowChange: Boolean);
begin
 if (stcode=101) or (stcode=111) then
  begin
      if (NewTab = 1) or (NewTab = 2) or (NewTab = 3) or (NewTab = 4)  then
        messagedlg( '���������� ������� � ���������� ����� ���� �� �������� ���������!' , mtWarning, [mbOk], 0, mbOk);
    AllowChange := not (NewTab = 1) and not (NewTab = 2) and not (NewTab = 3) and not (NewTab = 4);
  end;

  if stcode=201 then
  begin
     if (NewTab = 2) or (NewTab = 3) or (NewTab = 4)  then
       messagedlg( '���������� ������� � ���������� ����� ���� �� �������� ���������!' , mtWarning, [mbOk], 0, mbOk);
    AllowChange := not (NewTab = 2) and not (NewTab = 3) and not (NewTab = 4);
  end;

  if stcode=211 then
  begin
     if (NewTab = 3) or (NewTab = 4)  then
       messagedlg( '���������� ������� � ���������� ����� ���� �� �������� ���������!' , mtWarning, [mbOk], 0, mbOk);
    AllowChange := not (NewTab = 3) and not (NewTab = 4);
  end;

  if stcode=221 then
  begin
     if NewTab = 4  then
      messagedlg( '���������� ������� � ���������� ����� ���� �� �������� ���������!' , mtWarning, [mbOk], 0, mbOk);
     AllowChange :=  not (NewTab = 4);
  end;

  if stcode=301 then
  begin
      if  NewTab = 4  then
        messagedlg( '���������� ��������� � �����! ���������� ��� ��������� � ������.' , mtWarning, [mbOk], 0, mbOk);
    AllowChange :=  not (NewTab = 4);
  end;
end;

procedure TStartTaskForm.FormShow(Sender: TObject);
var inftype:string;

begin
workingtabnote.PageIndex:=0;
if infnamewrklabel.Caption<>'' then
   begin
    statmemo.lines.Clear;
    statmemo.lines.Add('������� ����������: '+TrimRight(infnamewrklabel.Caption));

    ADOQueryStart.Close;
    ADOQueryStart.SQL.Text:='select * from Infs ins left join sp_status ss on ins.status_code=ss.st_code left join sp_type sps on ins.[type]=sps.[tname] where name='''+infnamewrklabel.Caption+'''';
    ADOQueryStart.Open;
    stcode:=adoquerystart.FieldByName('st_code').AsInteger;
   //���������� ��������������� ����
    statmemo.lines.Add('������ ����������: '+ADOQueryStart.FieldByName('st_name').AsString);

   //�������� ������� �����������
     if stcode = 101
       then Stat_101_worker;

     if stcode = 111
        then Stat_111_worker;

     if stcode = 201
       then Stat_201_worker;

     if stcode = 211
       then Stat_211_worker;

     if stcode = 221
       then Stat_221_worker;

     if stcode = 300
       then Stat_300_worker;

     if stcode = 301
       then Stat_301_worker;

     if stcode = 600
       then Stat_600_worker;

   end
    else statmemo.lines.Add('���������� �� �������!') ;
end;

end.
