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
//Строка подключения к БД, проверка реестра
    if MainForm.ReadConnStr<>'not_' then
    begin
    ADOConnStart.Close;
    ADOConnStart.ConnectionString:=MainForm.ReadConnStr;
      try
        ADOConnStart.Open;
      except //showmessage('Строка подключения некорректна!');
      end;
    end;
//Установка рабочего информирования
    infNamewrklabel.DataSource:=MainForm.DataSource;
    infNamewrklabel.DataField:='Имя оповещения';
//Больше одного файла из ТФОМС по умолчанию - ЛОЖЬ
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
 if statmemo.Lines[ind] = 'Все готово для начала информирования, запустить немедленно?'
  then statmemo.lines.Add('Создание новой структуры отменено...');

  if statmemo.Lines[ind] = 'Игнорировать и перезаписать структуру?'
  then
    statmemo.lines.Add('Сохранить существующую структуру под другим именем?');

  if statmemo.Lines[ind] = 'Сохранить существующую структуру под другим именем?'
  then
    statmemo.lines.Add('Создание новой структуры отменено...');

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
 if statmemo.Lines[ind] = 'Все готово для начала информирования, запустить немедленно?'
  then statmemo.lines.Add('Создание новой структуры оповещения...');

  if statmemo.Lines[ind] = 'Игнорировать и перезаписать структуру?'
  then begin
    statmemo.lines.Add('Удаление старой структуры...');
    statmemo.lines.Add('Создание новой структуры информирования...');
  end;

    if statmemo.Lines[ind] = 'Сохранить существующую структуру по другим именем?'
      then begin
        statmemo.lines.Add('Сохранение структуры по другим именем...');
        statmemo.lines.Add('Создание новой структуры информирования...');
       end;
end;

function  TStartTaskForm.CreateInfList(tfomsfilename:string):boolean;
var nowdate:string;
tes:boolean;
begin
     { nowdate:='test';
      ADOQueryStart.Close;
     //Если нет таблицы создаем переносим из файла ТФОМС если есть переименуется
      ADOQueryStart.SQL.Add('if not exists (select * from sysobjects where name=''inf_disp'' and xtype=''U'') SELECT * INTO Inf_Disp FROM OPENROWSET(''Microsoft.ACE.OLEDB.12.0'',''Excel 12.0; Database='+tfomsfilename+''', ''select * from [Лист1$A5:BZ]'') else exec sp_rename ''Inf_Disp'', ''Inf_Disp_'+nowdate+'''');
     //  ADOQueryStart.SQL.Add('delete from Inf_Disp where [№_п/п] is null');
       ADOQueryStart.Open;  }
end;

procedure TStartTaskForm.FormShow(Sender: TObject);
var inftype:string;
begin

if infnamewrklabel.Caption<>'' then
   begin
   statmemo.lines.Clear;
   statmemo.lines.Add('Выбрано оповещение: '+TrimRight(infnamewrklabel.Caption));
   ADOQueryStart.SQL.Clear;
   ADOQueryStart.Close;
   //Проверка на наличие нескольких файлов
   ADOQueryStart.SQL.Add('select * from Infs ins left join sp_status ss on ins.status_code=ss.st_code left join sp_type sps on ins.[type]=sps.[tname] where name='''+infnamewrklabel.Caption+'''');
   ADOQueryStart.Open;
      if IsSomeFiles(ADOQueryStart.FieldByName('Tfoms_path').AsString).Count>0 then
         moreOneF:=true;
      //Заполнение информационного поля
        statmemo.lines.Add('Статус оповещения: '+ADOQueryStart.FieldByName('st_name').AsString);
     //Проверка статуса оповещзения
      if adoquerystart.FieldByName('st_code').AsInteger = 101
       then statmemo.lines.Add('Рабочяя структура оповещения не создана...');
      //Проверка на наличие старой таблицы
      if MainForm.CheckTableExist(adoquerystart.FieldByName('tremark').AsString) then
       begin
        statmemo.lines.Add('Найдена структура другого оповещения...');
        statmemo.lines.Add('Игнорировать и перезаписать структуру?');
       end
        else
         begin
          statmemo.lines.Add('Все готово для начала информирования, запустить немедленно?');

         end;
   end
    else statmemo.lines.Add('Оповещение не выбрано!') ;
end;

end.
