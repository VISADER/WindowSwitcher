unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, sButton, ExtCtrls, sPanel, acSlider, sEdit,
  CoolTrayIcon, sSkinManager, sLabel, IniFiles, ScktComp, Psock, ShellAPI,
  Buttons, sBitBtn, ComCtrls, sStatusBar;

type
  TForm1 = class(TForm)
    sSkinManager1: TsSkinManager;
    Timer1: TTimer;
    Timer2: TTimer;
    Timer3: TTimer;
    CoolTrayIcon1: TCoolTrayIcon;
    sEdit1: TsEdit;
    sEdit2: TsEdit;
    sButton3: TsButton;
    sLabel1: TsLabel;
    sLabel2: TsLabel;
    sLabel3: TsLabel;
    Powersock1: TPowersock;
    sLabel4: TsLabel;
    sEdit3: TsEdit;
    sButton4: TsButton;
    sBitBtn1: TsBitBtn;
    sBitBtn2: TsBitBtn;
    sBitBtn3: TsBitBtn;
    sStatusBar1: TsStatusBar;
    sLabel5: TsLabel;
    sSlider1: TsSlider;
    ServerSocket1: TServerSocket;
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure sEdit1DblClick(Sender: TObject);
    procedure sEdit2DblClick(Sender: TObject);
    procedure sSlider1SliderChange(Sender: TObject);
    procedure sButton3Click(Sender: TObject);
    procedure CoolTrayIcon1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure sLabel1DblClick(Sender: TObject);
    procedure sLabel2DblClick(Sender: TObject);
    procedure sLabel3DblClick(Sender: TObject);
    procedure ServerSocket1ClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sBitBtn1Click(Sender: TObject);
    procedure sButton4Click(Sender: TObject);
    procedure sBitBtn2Click(Sender: TObject);
    procedure sBitBtn3Click(Sender: TObject);
    procedure ServerSocket1ClientConnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocket1ClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure sLabel5Click(Sender: TObject);
    procedure Timer3Timer(Sender: TObject);
  private
    { Private declarations }
  public
    function WCenter(wcntr: string): String;
  end;

var
  Form1: TForm1;
  tmpStr : PChar;
  M,L,ac:Integer;

implementation

{$R *.dfm}

procedure TForm1.Timer1Timer(Sender: TObject);
var
  HWnd : THandle;
  N : Integer;
begin
 HWnd := GetForeGroundWindow;
 N := GetWindowTextLength(HWnd);
 tmpStr := StrAlloc(N + 1);
 GetWindowText(HWnd, tmpStr, N + 1);
 if sEdit1.Enabled=True then begin
  sEdit1.Text := tmpStr;
 end;
 if sEdit2.Enabled=True then begin
  sEdit2.Text := tmpStr;
 end;
end;

procedure TForm1.Timer2Timer(Sender: TObject);
var
H:HWND;
begin
  if M=0 then begin
    H := FindWindow(nil, PChar(sEdit1.Text));
    //ShowWindow(H, 1);
    //SetForegroundWindow(H);
    //Windows.SetFocus(H);
    SetWindowPos(H, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    Inc(M);
  end
  else begin
    H := FindWindow(nil, PChar(sEdit2.Text));
    //ShowWindow(H, 1);
    //SetForegroundWindow(H);
    //Windows.SetFocus(H);
    SetWindowPos(H, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
    Dec(M);
  end;
  Inc(L);
  sStatusBar1.SimpleText:=WCenter('Окна менялись '+IntToStr(L)+' раз(а)   ')+'Окна менялись '+IntToStr(L)+' раз(а)   ';
end;

procedure TForm1.sEdit1DblClick(Sender: TObject);
begin
sEdit1.Enabled:=False;
end;

procedure TForm1.sLabel1DblClick(Sender: TObject);
begin
sEdit1.Enabled:=True;
end;

procedure TForm1.sEdit2DblClick(Sender: TObject);
begin
sEdit2.Enabled:=False;
end;

procedure TForm1.sLabel2DblClick(Sender: TObject);
begin
sEdit2.Enabled:=True;
end;

procedure TForm1.sSlider1SliderChange(Sender: TObject);
begin
  if sSlider1.SliderOn=True then begin
    Timer1.Enabled:=True;
    Timer2.Enabled:=False;
    //sEdit1.Enabled:=True;
    //sEdit2.Enabled:=True;
  end
  else begin
    Timer1.Enabled:=False;
    Timer2.Enabled:=True;
    sEdit1.Enabled:=False;
    sEdit2.Enabled:=False;
  end;
end;

procedure TForm1.sButton3Click(Sender: TObject);
begin
CoolTrayIcon1.ShowBalloonHint('WindowSwitcher', 'Нажмите чтобы развернуть программу из трея', bitInfo, 11);
CoolTrayIcon1.HideMainForm;
CoolTrayIcon1.IconVisible:=True;
end;

procedure TForm1.CoolTrayIcon1Click(Sender: TObject);
begin
CoolTrayIcon1.ShowMainForm;
CoolTrayIcon1.IconVisible:=False;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
Form1.Height:=160;
M:=0;
L:=0;
//Form1.Visible:=True;
ServerSocket1.Close;
ServerSocket1.Active:=False;
//ServerSocket1.Active:=True;
ServerSocket1.Port:=727;
ServerSocket1.Open;
  if ServerSocket1.Active then
  begin
  //MessageBox(handle,PChar('Server '+Powersock1.LocalIP+':'+IntToStr(ServerSocket1.Port)+' started'+#13#10), PChar('INFO'), 64);
  sStatusBar1.SimpleText:=WCenter('Server '+Powersock1.LocalIP+':'+IntToStr(ServerSocket1.Port)+' started | ')+'Server '+Powersock1.LocalIP+':'+IntToStr(ServerSocket1.Port)+' started | ';
  end
  else sStatusBar1.SimpleText:=WCenter('Server is not started')+'Server is not started';
end;

procedure TForm1.sLabel3DblClick(Sender: TObject);
begin
//MessageBox(handle,PChar(Powersock1.LocalIP+':'+IntToStr(ServerSocket1.Port)+#13#10), PChar('IP данные'), 64);
end;

procedure TForm1.ServerSocket1ClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
st,sp,text:String;
index,ac:Integer;
H:HWND;
begin
ac:=0;
sp:='WS';
st:=Socket.ReceiveText;
//ShowMessage(Socket.ReceiveText);
//(0, 'open', PAnsiChar(st), nil, nil, SW_SHOW);
index:=Pos('#', st);
text:=st;
//ShowMessage(st+'|'+IntToStr(index)+'|'+(copy(text, 1, index-1))+'|'+(copy(text, index + 1, length(text) - index)));
  if st='Edit1' then begin
    H := FindWindow(nil, PChar(sEdit1.Text));
    //ShowWindow(H, 1);
    //SetForegroundWindow(H);
    //Windows.SetFocus(H);
    //ShowMessage('Edit1');
    SetWindowPos(H, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
  if st='Edit2' then begin
    H := FindWindow(nil, PChar(sEdit2.Text));
    //ShowWindow(H, 1);
    //SetForegroundWindow(H);
    //Windows.SetFocus(H);
    //ShowMessage('Edit2');
    SetWindowPos(H, HWND_TOPMOST, 0, 0, 0, 0, SWP_NOSIZE or SWP_NOMOVE);
  end;
  if sp=Copy(text, 1, index-1) then begin
    Timer2.Enabled:=False;
    Timer2.Interval:=StrToInt((copy(text, index + 1, length(text) - index)))*60000;
    //sStatusBar1.SimpleText:=WCenter(ServerSocket1.)+ServerSocket1.Socket.Connections[];
    for ac:=0 to ServerSocket1.Socket.ActiveConnections-1 do begin
    ServerSocket1.Socket.Connections[ac].SendText('WS#'+IntToStr(Timer2.Interval));
    //ShowMessage(IntToStr(ServerSocket1.Socket.ActiveConnections));
    end;
    sStatusBar1.SimpleText:=WCenter('Информировано '+IntToStr(ServerSocket1.Socket.ActiveConnections)+' клиент(а)')+'Информировано '+IntToStr(ServerSocket1.Socket.ActiveConnections)+' клиент(а)';
    //Timer2.Enabled:=True;
    //ShowMessage(copy(text, index + 1, length(text) - index));
  end;
end;

procedure TForm1.sBitBtn1Click(Sender: TObject);
begin
  sEdit3.Text:=IntToStr(Timer2.Interval);
  if Form1.Height=160 then begin
    Form1.Height:=225;
  end
  else begin
    Form1.Height:=160;
  end;
end;

procedure TForm1.sButton4Click(Sender: TObject);
begin
Timer2.Enabled:=False;
Timer2.Interval:=StrToInt(sEdit3.Text);
if sSlider1.SliderOn=False then begin
Timer2.Enabled:=True;
end;
end;

function TForm1.WCenter(wcntr: string): String;
var
  wc: string;
  ws: Integer;
begin
  if (Length(wcntr))>=28 then begin
  wc:='';
  end
  else begin
  ws:=Round((44-(Length(wcntr)))/2);
  repeat
  Insert(' ',wc,ws);
  Dec(ws);
  until ws=0;
  end;
  WCenter:=wc;
end;

procedure TForm1.sBitBtn2Click(Sender: TObject);
var
  Ini: Tinifile;
begin
Timer1.Enabled:=False;
Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'WindowSwitcher.ini');
sEdit1.Text:=Ini.ReadString('WindowSwitcher','Window1',sEdit1.Text);
sEdit2.Text:=Ini.ReadString('WindowSwitcher','Window2',sEdit2.Text);
Ini.Free;
//MessageBox(handle,PChar('Загрузка произведена!'+#13#10), PChar('Информация'), 64);
sStatusBar1.SimpleText:=WCenter('Загрузка произведена!   ')+'Загрузка произведена!   ';
sSlider1.SliderOn:=False;
end;

procedure TForm1.sBitBtn3Click(Sender: TObject);
var
  Ini: Tinifile;
begin
Timer1.Enabled:=False;
Ini:=TiniFile.Create(extractfilepath(paramstr(0))+'WindowSwitcher.ini');
Ini.WriteString('WindowSwitcher','Window1',sEdit1.Text);
Ini.WriteString('WindowSwitcher','Window2',sEdit2.Text);
Ini.Free;
//MessageBox(handle,PChar('Сохранение произведено!'+#13#10), PChar('Информация'), 64);
sStatusBar1.SimpleText:=WCenter('Сохранение произведено!  ')+'Сохранение произведено!   ';
Timer1.Enabled:=True;
end;

procedure TForm1.ServerSocket1ClientConnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ac:=ServerSocket1.Socket.ActiveConnections;
  sStatusBar1.SimpleText:=WCenter('Клиент #'+IntToStr(ServerSocket1.Socket.ActiveConnections)+' подключился   ')+'Клиент #'+IntToStr(ServerSocket1.Socket.ActiveConnections)+' подключился   ';
end;

procedure TForm1.ServerSocket1ClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  //ac:=ServerSocket1.Socket.ActiveConnections;
  sStatusBar1.SimpleText:=WCenter('Клиент #'+IntToStr(ServerSocket1.Socket.ActiveConnections)+' отключился   ')+'Клиент #'+IntToStr(ServerSocket1.Socket.ActiveConnections)+' отключился    ';
end;

procedure TForm1.sLabel5Click(Sender: TObject);
begin
  if sLabel5.Caption=IntToStr(Length(sStatusBar1.SimpleText)) then sLabel5.Caption:='     '
  else sLabel5.Caption:=IntToStr(Length(sStatusBar1.SimpleText));
end;

procedure TForm1.Timer3Timer(Sender: TObject);
var
text:string;
begin
text:=sStatusBar1.SimpleText;
sStatusBar1.SimpleText:=Copy(text,2,Length(text)-1)+copy(text,1,1);
end;

end.
