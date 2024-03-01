unit SettingsUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons;

type
  TSettingsForm = class(TForm)
    FontNameCombo: TComboBox;
    OkSettingsButton: TButton;
    FontLabel: TLabel;
    TimesLabel: TLabel;
    OriginLabel: TLabel;
    FontSizeLabel: TLabel;
    PixelsPerQuadrantLabel: TLabel;
    FontSizeEdit: TEdit;
    PixelsPerQuadrantEdit: TEdit;
    PixelsPerQuadrantFakeEdit: TEdit;
    CenterRadio: TRadioButton;
    TopLeftRadio: TRadioButton;
    RealSizeCheckBox: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure PixelsPerQuadrantEditChange(Sender: TObject);
    procedure AllowOnlyNumbersKeyPress(Sender: TObject; var Key: Char);
    procedure OkSettingsButtonClick(Sender: TObject);
    procedure RealSizeCheckBoxClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  SettingsForm: TSettingsForm;

implementation

{$R *.dfm}

uses MainUnit;

procedure TSettingsForm.FormCreate(Sender: TObject);
begin
  FontNameCombo.Items.AddStrings(Screen.Fonts);
  FontSizeEdit.Text := IntToStr(MainForm.CodeEditor.Font.Size);
  FontNameCombo.ItemIndex := FontNameCombo.Items.IndexOf(MainForm.CodeEditor.Font.Name);
end;

procedure TSettingsForm.FormShow(Sender: TObject);
begin
  OkSettingsButton.SetFocus;
end;

procedure TSettingsForm.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) = VK_RETURN then
  begin
    Key := #0; // prevent beeping
    OkSettingsButton.Click;
  end;
end;

procedure TSettingsForm.PixelsPerQuadrantEditChange(Sender: TObject);
begin
  PixelsPerQuadrantFakeEdit.Text := PixelsPerQuadrantEdit.Text;
end;

procedure TSettingsForm.RealSizeCheckBoxClick(Sender: TObject);
begin
  PixelsPerQuadrantEdit.Enabled := not RealSizeCheckBox.Checked;
end;

procedure TSettingsForm.AllowOnlyNumbersKeyPress(Sender: TObject; var Key: Char);
begin
  if Ord(Key) <> VK_BACK then
    if not ((Key >= '0') and (Key <= '9')) then
    begin
      Beep;
      Key := #0;
    end;
end;

procedure TSettingsForm.OkSettingsButtonClick(Sender: TObject);
var
  PixelsPerQuadrantSide: Integer;
begin
  MainForm.SetRealSize(RealSizeCheckBox.Checked);
  MainForm.SetCenterOrigin(CenterRadio.Checked);

  if PixelsPerQuadrantEdit.Text <> '' then
  begin
    PixelsPerQuadrantSide := StrToInt(PixelsPerQuadrantEdit.Text);
    if MainForm.FPixelsPerQuadrantSide <> PixelsPerQuadrantSide then
      MainForm.ResizeGrid(PixelsPerQuadrantSide);
  end;

  if FontSizeEdit.Text <> '' then
    MainForm.CodeEditor.Font.Size := StrToInt(FontSizeEdit.Text);

  if FontNameCombo.Text <> '' then
    MainForm.CodeEditor.Font.Name := FontNameCombo.Text;

  Close;
end;

end.
