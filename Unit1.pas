unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Buttons, StdCtrls, Mask;

type
  TForm1 = class(TForm)
    pnlLeft: TPanel;
    StatusBar1: TStatusBar;
    pnlTop: TPanel;
    btnNew: TSpeedButton;
    txtToguess: TMaskEdit;
    procedure FormCreate(Sender: TObject);
    procedure btnNewClick(Sender: TObject);
    procedure txtToguessKeyPress(Sender: TObject; var Key: Char);
    procedure txtToguessKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  tNumber: String;

function generateNumber(): String;

implementation

{$R *.dfm}

function generateNumber(): String;
var i: Integer; n1, tempNumber: String;
begin
  tempNumber:='';
  i:=0;
  while i<4 do begin
    n1:=IntToStr(Random(10));
    if(Pos(n1, tempNumber)=0) then begin
      tempNumber:=tempNumber+n1;
      i:=i+1
    end;
  end;
  //ShowMessage(tempNumber);
  Result:=tempNumber;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Ready for a new game';
end;

procedure TForm1.btnNewClick(Sender: TObject);
begin
  if(btnNew.Tag=1) then begin
    Application.MessageBox('You are currently in a game. Are you sure you want '+
      'a new game?', 'New game confirmation', MB_YESNO+MB_ICONINFORMATION);
  end else begin
    btnNew.Tag:=1;
  end;
  StatusBar1.Panels[0].Text:='Generating number to guess...';
  tNumber:=generateNumber();
  StatusBar1.Panels[0].Text:='Number has been generated. Start your guess.';
  txtToguess.Enabled;
  txtToguess.ReadOnly:=False;
  txtToguess.SetFocus;
end;

procedure TForm1.txtToguessKeyPress(Sender: TObject; var Key: Char);
begin
  if(Pos(Key, txtToguess.Text)>0)then begin
    Application.MessageBox('Repeating a number is not allowed', 'No repeating', MB_OK+MB_ICONWARNING);
    Key:=#0;
  end;
end;

procedure TForm1.txtToguessKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var isValidate: Boolean; myLabel: TLabel;
begin
  if(Key=13) then begin
    isValidate:=True;
    if(txtToguess.Text[1]=' ') then isValidate:=False;
    if(txtToguess.Text[3]=' ') then isValidate:=False;
    if(txtToguess.Text[5]=' ') then isValidate:=False;
    if(txtToguess.Text[7]=' ') then isValidate:=False;
    if(not isValidate)then begin
      Application.MessageBox('Your entry is incomplete', 'Invalid input', MB_OK+MB_ICONWARNING)
    end else begin
      myLabel:=TLabel.Create(Self);
      myLabel.Top:=txtToguess.Top;
      myLabel.Left:=txtToguess.Left;
      myLabel.Width:=txtToguess.Width;
      myLabel.Height:=txtToguess.Height;
      myLabel.Parent:=txtToguess.Parent;
      myLabel.Font:=txtToguess.Font;
      myLabel.Caption:=txtToguess.Text;
      txtToguess.Text:='';
      txtToguess.Top:=txtToGuess.Top+43;
    end;
  end;
end;

end.
