unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Buttons, StdCtrls, Mask, Menus;

type
  TForm1 = class(TForm)
    pnlLeft: TPanel;
    StatusBar1: TStatusBar;
    pnlTop: TPanel;
    btnNew: TSpeedButton;
    scrlLeft: TScrollBox;
    txtToguess: TMaskEdit;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    New1: TMenuItem;
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
  myComponentCount, Attempt: Integer;

function generateNumber(): String;
function howManyCorrect(myGuess: String): Integer;
function howManyPositionCorrect(myGuess: String): Integer;

implementation

{$R *.dfm}

function generateNumber(): String;
var i: Integer; n1, tempNumber: String;
begin
  tempNumber:='';
  i:=0;
  while i<4 do begin
    Randomize();
    n1:=IntToStr(Random(10));
    if(Pos(n1, tempNumber)=0) then begin
      tempNumber:=tempNumber+n1+' ';
      i:=i+1
    end;
  end;
  //ShowMessage(tempNumber);
  Result:=tempNumber;
end;

function howManyCorrect(myGuess: String): Integer;
var i, max, found: Integer;
begin
  found:=0;
  max:=Length(myGuess);
  for i:=1 to max do begin
    if(myGuess[i]=' ') then Continue;
    if(Pos(myGuess[i], tNumber)>0) then found:=found+1;
  end;
  Result:=found;
end;

function howManyPositionCorrect(myGuess: String): Integer;
var i, max, found: Integer;
begin
  found:=0;
  max:=Length(myGuess);
  for i:=1 to max do begin
    if(myGuess[i]=' ') then Continue;
    if(myGuess[i]=tNumber[i]) then found:=found+1;
  end;
  Result:=found;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  StatusBar1.Panels[0].Text:='Click pen icon for a new game';
  myComponentCount:=Form1.ComponentCount;
end;

procedure TForm1.btnNewClick(Sender: TObject);
var i,idUser: Integer;
begin
  idUser:=0;
  if(btnNew.Tag=1) then begin
    idUser:=Application.MessageBox('You are currently in a game. Are you sure you want '+
      'a new game?', 'New game confirmation', MB_YESNO+MB_ICONWARNING);
    if(idUser=idYes) then begin
      txtToguess.Left:=16;
      txtToguess.Top:=0;
      btnNew.Tag:=1;
      //btnNewClick(Sender);
    end else begin
      Exit;
    end;
  end else if(btnNew.Tag=2) then begin
    txtToguess.Left:=16;
    txtToguess.Top:=1;
  end else begin
    btnNew.Tag:=1;
  end;

  if((idUser=idYes)or(btnNew.Tag=2)) then begin
    for i:=0 to Attempt do begin
      if(TLabel(FindComponent('lblAttempt'+IntToStr(i))) <> NIL) then begin
        TLabel(FindComponent('lblAttempt'+IntToStr(i))).Free
      end;
      if(TLabel(FindComponent('lblCorrect'+IntToStr(i))) <> NIL) then begin
        TLabel(FindComponent('lblCorrect'+IntToStr(i))).Free;
      end;
      if(TLabel(FindComponent('lblPositionCorrect'+IntToStr(i))) <> NIL) then begin
        TLabel(FindComponent('lblPositionCorrect'+IntToStr(i))).Free;
      end;
    end;
    Attempt:=0;
    btnNew.Tag:=1;
  end;
  StatusBar1.Panels[0].Text:='Generating number to guess...';
  tNumber:=generateNumber();
  //ShowMessage(tNumber);
  StatusBar1.Panels[0].Text:='Number has been generated. Start your guess.';
  txtToguess.Enabled:=True;
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
var isValidate: Boolean; myLabel, myLabelCorrect, myLabelPositionCorrect: TLabel;
  iHowManyCorrect, iHowManyPositionCorrect: Integer;
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
      iHowManyCorrect:=howManyCorrect(txtToguess.Text);
      iHowManyPositionCorrect:=howManyPositionCorrect(txtToguess.Text);
      Attempt:=Attempt+1;
      myLabel:=TLabel.Create(Self);
      myLabel.Top:=txtToguess.Top;
      myLabel.Left:=txtToguess.Left;
      myLabel.Width:=txtToguess.Width;
      myLabel.Height:=txtToguess.Height;
      myLabel.Parent:=txtToguess.Parent;
      myLabel.Font:=txtToguess.Font;
      myLabel.Caption:=txtToguess.Text;
      myLabel.Name:='lblAttempt'+IntToStr(Attempt);

      myLabelCorrect:=TLabel.Create(Self);
      myLabelCorrect.Top:=txtToguess.Top;
      myLabelCorrect.Left:=txtToguess.Left+120;
      myLabelCorrect.Width:=20;
      myLabelCorrect.Height:=txtToguess.Height;
      myLabelCorrect.Parent:=txtToguess.Parent;
      myLabelCorrect.Font:=txtToguess.Font;
      myLabelCorrect.Caption:=IntToStr(iHowManyCorrect);
      myLabelCorrect.Name:='lblCorrect'+IntToStr(Attempt);

      myLabelPositionCorrect:=TLabel.Create(Self);
      myLabelPositionCorrect.Top:=txtToguess.Top;
      myLabelPositionCorrect.Left:=txtToguess.Left+150;
      myLabelPositionCorrect.Width:=20;
      myLabelPositionCorrect.Height:=txtToguess.Height;
      myLabelPositionCorrect.Parent:=txtToguess.Parent;
      myLabelPositionCorrect.Font:=txtToguess.Font;
      myLabelPositionCorrect.Caption:=IntToStr(iHowManyPositionCorrect);
      myLabelPositionCorrect.Name:='lblPositionCorrect'+IntToStr(Attempt);

      if((iHowManyCorrect=4)and(iHowManyPositionCorrect=4))then begin
        Application.MessageBox('Congratulations! You won the game',
          'You win!', MB_OK+MB_ICONINFORMATION);
        txtToguess.ReadOnly:=True;
        txtToguess.Enabled:=False;
        btnNew.Tag:=2;
        StatusBar1.Panels[0].Text:='You won!';
      end;

      txtToguess.Text:='';
      txtToguess.Top:=txtToGuess.Top+43;
    end;
  end;
end;

end.
