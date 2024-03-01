unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Graphics, Controls, Forms, Dialogs, ExtCtrls, ComCtrls, StdCtrls,
  Buttons, Math, Contnrs, SynEditHighlighter, SynHighlighterPas, SynEdit, SynEditCodeFolding, uPSComponent, uPSDebugger,
  uPSRuntime, upsCompiler, uPSPreProcessor, ImgList, ToolWin, Menus, ActnList, StdActns, ShellApi, Clipbrd,
  System.Actions, Generics.Collections, System.UITypes, System.ImageList, Vcl.Grids, IOUtils, System.Classes;

type
  TPointPair = class
  public
    X1: Double;
    Y1: Double;
    X2: Double;
    Y2: Double;
    Color: TColor;
    constructor Create(AX1, AY1, AX2, AY2: Double; AColor: TColor);
  end;

  TCircle = class
  public
    CX: Double;
    CY: Double;
    R: Integer;
    Color: TColor;
    constructor Create(ACX, ACY: Double; AR: Integer; AColor: TColor);
  end;

  TTextLabel = class
  public
    CX: Double;
    CY: Double;
    Text: String;
    Color: TColor;
    constructor Create(ACX, ACY: Double; AText: String; AColor: TColor);
  end;

  TMainForm = class(TForm)
    Toolbar: TToolBar;
    ConsoleMemo: TMemo;
    ColorShape: TShape;
    PaintBox: TPaintBox;
    CodeEditor: TSynEdit;
    StatusBar: TStatusBar;
    SynPasSyn: TSynPasSyn;
    WatchTable: TStringGrid;
    ActionList: TActionList;
    ColorDialog: TColorDialog;
    OpenFileDialog: TOpenDialog;
    PascalScript: TPSScriptDebugger;
    SaveAction: TAction;
    SaveAsAction: TAction;
    SaveBmpDialog: TSaveDialog;
    SaveFileDialog: TSaveDialog;
    ToolbarImages: TImageList;
    ToolbarImagesDisabled: TImageList;
    SpeedScrollBar: TScrollBar;
    LeftPanelWidthScrollBar: TScrollBar;
    SpeedLabel: TLabel;
    ColorLabel: TLabel;
    EditorWidthLabel: TLabel;
    TopPanel: TPanel;
    LeftPanel: TPanel;
    RightPanel: TPanel;
    BottomPanel: TPanel;
    CutMenuItem: TMenuItem;
    CopyMenuItem: TMenuItem;
    SaveMenuItem: TMenuItem;
    PasteMenuItem: TMenuItem;
    SaveAsMenuItem: TMenuItem;
    SaveFilePopup: TPopupMenu;
    CodeEditorPopup: TPopupMenu;
    RunButton: TToolButton;
    HelpButton: TToolButton;
    StopButton: TToolButton;
    NewFileButton: TToolButton;
    OpenFileButton: TToolButton;
    SaveFileButton: TToolButton;
    StepIntoButton: TToolButton;
    RealSizeButton: TToolButton;
    SettingsButton: TToolButton;
    ExportImageButton: TToolButton;
    ClearScreenButton: TToolButton;
    ToolbarSeparator1: TToolButton;
    ToolbarSeparator2: TToolButton;
    ToolbarSeparator3: TToolButton;
    StepOverButton: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure RightPanelResize(Sender: TObject);
    procedure LeftPanelWidthScrollBarChange(Sender: TObject);
    procedure NewFileButtonClick(Sender: TObject);
    procedure OpenFileButtonClick(Sender: TObject);
    procedure RunButtonClick(Sender: TObject);
    procedure StepIntoButtonClick(Sender: TObject);
    procedure StepOverButtonClick(Sender: TObject);
    procedure RealSizeButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure ExportImageButtonClick(Sender: TObject);
    procedure ClearScreenButtonClick(Sender: TObject);
    procedure SettingsButtonClick(Sender: TObject);
    procedure HelpButtonClick(Sender: TObject);
    procedure ColorShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SaveActionExecute(Sender: TObject);
    procedure SaveAsActionExecute(Sender: TObject);
    procedure CodeEditorPopupPopup(Sender: TObject);
    procedure CutMenuItemClick(Sender: TObject);
    procedure CopyMenuItemClick(Sender: TObject);
    procedure PasteMenuItemClick(Sender: TObject);
    procedure WatchTableSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
    procedure WatchTableDblClick(Sender: TObject);
    procedure PaintBoxPaint(Sender: TObject);
    procedure PaintBoxMouseLeave(Sender: TObject);
    procedure PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure CodeEditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CodeEditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer; Mark: TSynEditMark);
    procedure CodeEditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);

    /// <summary>
    ///  Novi potprogram u Pascal Script dodajemo tako što ga prvo implementiramo ovde kod nas, pa
    ///  ga baš u ovoj ovde metodi registrujemo prosleđujući pointer na njega i željeno zaglavlje.
    ///  Po principu callback-a će ga Pascal Script zvati po potrebi.
    /// </summary>
    procedure PascalScriptCompile(Sender: TPSScript);

    procedure PascalScriptIdle(Sender: TObject);
    procedure PascalScriptAfterExecute(Sender: TPSScript);
    procedure PascalScriptBreakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
    procedure PascalScriptLineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);

    /// <summary>
    ///  Čita sadržaj fajla za potrebe <c>{$INCLUDE ...}</c> direktive.
    /// </summary>
    function PascalScriptNeedFile(Sender: TObject; const OrginFileName: AnsiString;
      var FileName, Output: AnsiString): Boolean;

  private
    { Private declarations }

    FGridWH: Integer;
    FActiveLine: Integer;
    FRealSize: Boolean;
    FCurrentFileName: String;

    FStack: TList<Integer>; // TStack nije pogodno za iteraciju, ne bih mogao lako da ispišem sve elemente steka
    FLines: TObjectList<TPointPair>;
    FCircles: TObjectList<TCircle>;
    FEllipses: TObjectList<TPointPair>;
    FTextLabels: TObjectList<TTextLabel>;

    /// <summary>
    ///  <c>False</c> ako klik na Run označava početak izvršavanja algoritma. <c>True</c> ako označava
    ///  nastavak normalnog izvršavanja nakon udara u breakpoint ili kliktanja na Step Over/Step Into.
    /// </summary>
    FResume: Boolean;

    /// <summary>
    ///  Pascal Script koristi '.' kao decimalni separator. Funkcije za konverziju iz stringa u relan broj i obratno po
    ///  defaultu koriste sitemska podešavanja, te vrednosti promenljivih neće biti ispravno fomatirane ako u sistemu
    ///  nije postavljen baš taj separator. Zato ja podešavam i prosleđujem ovaj objekat svim tim funkcijama.
    /// </summary>
    FFormat: TFormatSettings;

    function Compile: Boolean;
    function Execute: Boolean;
    function FormatComplex(s: String): String;
    function PixelExists(X, Y: Integer): Boolean;
    function MixBytes(FG, BG, TRANS: Byte): Byte;
    function MixColors(FG, BG: TColor; T: Byte): TColor;
    /// <summary>
    ///  Transformiše fiktivne u realne koordinate. U realnosti je piksel sa koordinatama (0, 0) uvek onaj u
    ///  gornjem-levom uglu platna. Ali ako smo smestili koordinatni sistem u centar platna, nećemo misliti na
    ///  ugaoni piksel dok budemo stavljali te koordinate jer bi on za nas tada bio na nekoj negativnoj poziciji.
    /// </summary>
    function OffsetCoordinate(X: Integer): Integer; overload;
    function OffsetCoordinate(X: Double): Double; overload;
    function UnoffsetCoordinate(X: Integer): Integer;

    procedure ClearScreen;
    procedure AdjustRightPanel;
    procedure WatchTableRefresh;
    procedure RefreshPaintBoxes;
    procedure CheckRange(Arr: Array of Integer);
    procedure SaveFile(FileName: String);
    procedure ToggleBreakPoint(Line: Integer);
    procedure SetCurrentFile(FileName: String);
    procedure ScrollToActiveLine(Row: Cardinal);
    procedure PutPixel(X, Y: Integer; Color: TColor);
    procedure RemovePixel(X, Y: Integer);

    // ** naši potprogrami ** //
    function MyFrac(X: Double): Double;
    function MyRandomRange(AFrom, ATo: Integer): Integer;
    procedure ReadInt(var X: Integer);
    procedure ReadFloat(var X: Double);
    function IsEmpty: Boolean;
    procedure Push(X: Integer);
    procedure Pop(var X: Integer);
    procedure Plot(X, Y: Integer);
    procedure PlotEx(X, Y, Alpha: Integer);
    procedure TurnOff(X, Y: Integer);
    procedure Invert(X, Y: Integer);
    function IsOn(X, Y: Integer): Boolean;
    procedure DrawLine(X1, Y1, X2, Y2: Double);
    procedure DrawCircle(CX, CY: Double; R: Integer);
    procedure DrawEllipse(X1, Y1, X2, Y2: Double);
    procedure DrawText(CX, CY: Double; Text: String);
    procedure SetColor(Color: String);
    procedure SetColorRGB(R, G, B: Byte);
    procedure WriteLn(Text: String);
  public
    { Public declarations }
    FCenterOrigin: Boolean;
    FPixelsPerQuadrantSide: Integer;

    /// <summary>
    ///  "Matrica" piksela. Prava matrica bi zauzela dosta memorije, od koje bi većina u
    ///  realnosti ostala neiskorišćena. Ovo pre svega važi ako je upaljen prikaz piksela
    ///  u realnoj večini pošto bi u tom slučaju matrica bila velikih dimenzija. U rečniku
    ///  zato čuvam samo obojene piksele. Elementi rečnika su oblika <c>{x: {y: color}}</c>.
    /// </summary>
    FPixels: TObjectDictionary<Integer, TDictionary<Integer, TColor>>;

    procedure ResizeGrid(Dimensions: Integer);
    procedure SetRealSize(RealSize: Boolean);
    procedure SetCenterOrigin(CenterOrigin: Boolean);
  end;

const
  LINE_WIDTH = 1;
  BLANK_COLOR = clCream;
  AXIS_COLOR = clGreen;
  GRID_COLOR = clMoneyGreen;
  SLEEP_INTERVAL_DURATION = 20;
  INITIAL_PIXELS_PER_QUADRANT_SIDE = 20;

  WATCH_TABLE_VARIABLE_ROW = 1;
  WATCH_TABLE_VALUE_ROW = 2;

  HELP_FILE_NAME = 'MrPixel.pdf';
  NEW_FILE_TEMPLATE_FILENAME = 'NewFileTemplate.txt';

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

uses RealSizeUnit, SettingsUnit, InspectVariableUnit;

constructor TPointPair.Create(AX1, AY1, AX2, AY2: Double; AColor: TColor);
begin
  X1 := AX1;
  Y1 := AY1;
  X2 := AX2;
  Y2 := AY2;
  Color := AColor;
end;

constructor TCircle.Create(ACX, ACY: Double; AR: Integer; AColor: TColor);
begin
  CX := ACX;
  CY := ACY;
  R := AR;
  Color := AColor;
end;

constructor TTextLabel.Create(ACX, ACY: Double; AText: String; AColor: TColor);
begin
  CX := ACX;
  CY := ACY;
  Text := AText;
  Color := AColor;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  Randomize;

  FRealSize := False;
  FCenterOrigin := True;

  {
    TObjectList/TObjectDictionary je TList/TDictionary koji sam oslobađa memoriju posedovanih elemenata pri njihovom
    brisanju iz kolekcije, te mi ne moramo brinuti o tome. TObjectList u konstruktoru prima Boolean koji određuje da
    li je vlasnik svojih elemenata (default je True). Za TObjectDictionary doOwnsKeys znači da poseduje ključeve, a
    doOwnsValues da poseduje vrednosti (možemo navesti i oba).
  }

  FStack := TList<Integer>.Create;
  FLines := TObjectList<TPointPair>.Create;
  FCircles := TObjectList<TCircle>.Create;
  FEllipses := TObjectList<TPointPair>.Create;
  FTextLabels := TObjectList<TTextLabel>.Create;
  FPixels := TObjectDictionary < Integer, TDictionary < Integer, TColor >>.Create([doOwnsValues]);

  WatchTable.RowHeights[0] := 2; // pomoćni red za promenu veličine ćelija
  WatchTable.Cells[0, WATCH_TABLE_VARIABLE_ROW] := 'Variable';
  WatchTable.Cells[0, WATCH_TABLE_VALUE_ROW] := 'Value';

  FFormat := TFormatSettings.Create('');
  FFormat.DecimalSeparator := '.';

  RightPanel.DoubleBuffered := True;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  ResizeGrid(INITIAL_PIXELS_PER_QUADRANT_SIDE);
  NewFileButton.Click;
  CodeEditor.SetFocus;

  WriteLn(' by Branislav Stojković');
  WriteLn('  & Nikola Kostić');
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  AdjustRightPanel;
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  {
    Pošto želim da ove prečice rade koja god da je komponenta u fokusu, upalio sam KeyPreview na formi.
    To znači da forma presreće sve događaje vezane za tastaturu. Ako sam u formi obradio događaj i ne
    želim da nakon toga bude prosleđen komponenti kojoj je bio namenjen, stavljam Key na #0 (KeyPress)
    ili 0 (KeyDown/KeyUp).
  }
  if Key = vk_F5 then
    begin
      RunButton.Click;
      Key := 0;
    end
  else if Key = vk_F6 then
    begin
      StepIntoButton.Click;
      Key := 0;
    end
  else if Key = vk_F7 then
    begin
      StepOverButton.Click;
      Key := 0;
    end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StopButton.Click;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FStack.Free;
  FLines.Free;
  FCircles.Free;
  FEllipses.Free;
  FTextLabels.Free;
  FPixels.Free;
end;

procedure TMainForm.RightPanelResize(Sender: TObject);
begin
  {
    Ako nije upaljen prikaz u realnoj veličini, broj piksela u mreži zavisi samo od podešavanja.
    Jasno je da u suprotnom važi da su dimenzije mreže jednake dimenzijama platna. Zato u tom
    slučaju pri svakoj promeni dimenzija brišem sve sa platna.
  }
  if FRealSize then
    ClearScreen;
end;

procedure TMainForm.LeftPanelWidthScrollBarChange(Sender: TObject);
begin
  AdjustRightPanel;
end;

procedure TMainForm.NewFileButtonClick(Sender: TObject);
var
  Code: String;
begin
  Code := '';
  SetCurrentFile('');

  if FileExists(NEW_FILE_TEMPLATE_FILENAME) then
    Code := TFile.ReadAllText(NEW_FILE_TEMPLATE_FILENAME)
  else
    WriteLn(NEW_FILE_TEMPLATE_FILENAME + ' is missing.');
    
  CodeEditor.Text := Code;
end;

procedure TMainForm.OpenFileButtonClick(Sender: TObject);
begin
  if OpenFileDialog.Execute then
    begin
      SetCurrentFile(OpenFileDialog.FileName);
      CodeEditor.Lines.LoadFromFile(OpenFileDialog.FileName);
    end;
end;

procedure TMainForm.RunButtonClick(Sender: TObject);
begin
  if PascalScript.Running then
    FResume := True
  else if Compile then
    Execute;
end;

procedure TMainForm.StepIntoButtonClick(Sender: TObject);
begin
  if PascalScript.Exec.Status = isRunning then
    PascalScript.StepInto
  else
    begin
      if Compile then
        begin
          PascalScript.StepInto;
          Execute;
        end;
    end;
end;

procedure TMainForm.StepOverButtonClick(Sender: TObject);
begin
  if PascalScript.Exec.Status = isRunning then
    PascalScript.StepOver
  else
    begin
      if Compile then
        begin
          PascalScript.StepOver;
          Execute;
        end;
    end;
end;

procedure TMainForm.RealSizeButtonClick(Sender: TObject);
begin
  RealSizeForm.Visible := not RealSizeForm.Visible;
end;

procedure TMainForm.StopButtonClick(Sender: TObject);
begin
  if PascalScript.Exec.Status = isRunning then
    PascalScript.Stop;
end;

procedure TMainForm.ExportImageButtonClick(Sender: TObject);
var
  bmp: TBitmap;
begin
  if SaveBmpDialog.Execute then
    begin

      bmp := TBitmap.Create;

      try
        bmp.Width := PaintBox.Width;
        bmp.Height := PaintBox.Height;
        PaintBox.Refresh;
        BitBlt(bmp.Canvas.Handle, 0, 0, bmp.Width, bmp.Height, PaintBox.Canvas.Handle, 0, 0, SRCCOPY);
        bmp.SaveToFile(SaveBmpDialog.FileName);
      finally
        bmp.Free
      end

    end;
end;

procedure TMainForm.ClearScreenButtonClick(Sender: TObject);
begin
  ClearScreen;
end;

procedure TMainForm.SettingsButtonClick(Sender: TObject);
begin
  SettingsForm.ShowModal;
end;

procedure TMainForm.HelpButtonClick(Sender: TObject);
var
  Folder: String;
  FilePath: String;
  SEI: TShellExecuteInfo;
begin
  Folder := ExtractFilePath(Application.ExeName);
  FilePath := TPath.Combine(Folder, HELP_FILE_NAME);

  if FileExists(FilePath) then
    begin
      ZeroMemory(@SEI, SizeOf(SEI));
      SEI.cbSize := SizeOf(SEI);
      SEI.lpDirectory := PChar(Folder);
      SEI.lpFile := PChar(FilePath);
      SEI.nShow := SW_SHOWNORMAL;
      ShellExecuteEx(@SEI);
    end
  else
    WriteLn('Help file is missing.');

end;

procedure TMainForm.ColorShapeMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbRight then
    ColorShape.Brush.Color := RGB(Random(255), Random(255), Random(255))
  else
    begin
      ColorDialog.Color := ColorShape.Brush.Color;
      if ColorDialog.Execute then
        ColorShape.Brush.Color := ColorDialog.Color;
    end;
end;

procedure TMainForm.SaveActionExecute(Sender: TObject);
begin
  if FCurrentFileName <> '' then
    SaveFile(FCurrentFileName)
  else
    SaveAsAction.Execute;
end;

procedure TMainForm.SaveAsActionExecute(Sender: TObject);
begin
  if SaveFileDialog.Execute then
    begin
      SaveFile(SaveFileDialog.FileName);
      SetCurrentFile(SaveFileDialog.FileName);
    end;
end;

procedure TMainForm.CodeEditorPopupPopup(Sender: TObject);
begin
  CutMenuItem.Enabled := CodeEditor.SelLength > 0;
  CopyMenuItem.Enabled := CodeEditor.SelLength > 0;
  PasteMenuItem.Enabled := Clipboard.HasFormat(CF_TEXT);
end;

procedure TMainForm.CutMenuItemClick(Sender: TObject);
begin
  CodeEditor.CutToClipboard;
end;

procedure TMainForm.CopyMenuItemClick(Sender: TObject);
begin
  CodeEditor.CopyToClipboard;
end;

procedure TMainForm.PasteMenuItemClick(Sender: TObject);
begin
  CodeEditor.PasteFromClipboard;
end;

procedure TMainForm.WatchTableSetEditText(Sender: TObject; ACol, ARow: Integer; const Value: String);
var
  VarName: String;
begin
  if ARow = 1 then
    begin
      VarName := WatchTable.Cells[ACol, ARow];
      if VarName = '' then
        WatchTable.Cells[ACol, WATCH_TABLE_VALUE_ROW] := ''
      else
        WatchTableRefresh;
    end;
end;

procedure TMainForm.WatchTableRefresh;
var
  D: Double;
  I: Integer;
  N: Integer;
  Col: Integer;
  VarName: String;
  VarValue: String;
  FormattedVarValue: String;
begin
  if PascalScript.Exec.Status = isRunning then
    for Col := 1 to WatchTable.ColCount do
      begin
        VarName := WatchTable.Cells[Col, WATCH_TABLE_VARIABLE_ROW];

        if VarName = '' then
          Continue;

        if CompareText(VarName, '<stack>') = 0 then
          begin
            FormattedVarValue := '[';
            for I := FStack.Count - 1 downto 0 do
              begin
                FormattedVarValue := FormattedVarValue + IntToStr(FStack.Items[I]);
                if I > 0 then
                  FormattedVarValue := FormattedVarValue + ', ';
              end;
            FormattedVarValue := FormattedVarValue + ']';
          end
        else
          begin
            VarValue := String(PascalScript.GetVarContents(AnsiString(VarName)));
            FormattedVarValue := VarValue;

            if TryStrToInt(VarValue, N) then
              FormattedVarValue := IntToStr(N)
            else if TryStrToFloat(VarValue, D, FFormat) then
              FormattedVarValue := FloatToStr(D, FFormat)
            else if ((Pos('[', VarValue) > 0) or (Pos('(', VarValue) > 0)) then
              FormattedVarValue := FormatComplex(VarValue);
          end;

        WatchTable.Cells[Col, WATCH_TABLE_VALUE_ROW] := FormattedVarValue;

      end;
end;

procedure TMainForm.WatchTableDblClick(Sender: TObject);
var
  ACol: Integer;
  ARow: Integer;
  CursorPos: TPoint;
  CellContent: String;
begin
  GetCursorPos(CursorPos);
  CursorPos := WatchTable.ScreenToClient(CursorPos);
  WatchTable.MouseToCell(CursorPos.X, CursorPos.Y, ACol, ARow);
  if ((ACol > 0) and (ARow = WATCH_TABLE_VALUE_ROW)) then
    begin
      CellContent := WatchTable.Cells[ACol, WATCH_TABLE_VALUE_ROW];
      if CellContent <> '' then
        begin
          InspectVariableForm.Caption := WatchTable.Cells[ACol, WATCH_TABLE_VARIABLE_ROW];
          InspectVariableForm.VariableValueMemo.Text := CellContent;
          InspectVariableForm.ShowModal;
        end;
    end;
end;

procedure TMainForm.PaintBoxPaint(Sender: TObject);
var
  I: Integer;
  GridR: Integer;
  GridC: Integer;
  PixelX: Integer;
  PixelY: Integer;
  TextWidth: Integer;
  TextHeight: Integer;
  Multiplier: Integer;
  HalfPaintBox: Integer;
  InnerItem: TPair<Integer, TColor>;
  OuterItem: TPair<Integer, TDictionary<Integer, TColor>>;
begin
  // ** clearing canvas ** //
  PaintBox.Canvas.Pen.Style := psClear;
  PaintBox.Canvas.Brush.Color := BLANK_COLOR;
  PaintBox.Canvas.Rectangle(0, 0, PaintBox.Width, PaintBox.Height);
  PaintBox.Canvas.Pen.Style := psSolid;

  // ** filling pixels ** //
  for OuterItem in FPixels do
    for InnerItem in OuterItem.Value do
      begin
        PixelX := OffsetCoordinate(OuterItem.Key);
        PixelY := OffsetCoordinate(InnerItem.Key);
        if FRealSize then
          PaintBox.Canvas.Pixels[PixelX, PixelY] := InnerItem.Value
        else
          begin
            PaintBox.Canvas.Brush.Color := InnerItem.Value;
            PaintBox.Canvas.Rectangle(
              PixelX * FGridWH,
              PixelY * FGridWH,
              (PixelX + 1) * FGridWH + LINE_WIDTH,
              (PixelY + 1) * FGridWH + LINE_WIDTH
            );
          end;
      end;

  if not FRealSize then
    begin
      // ** drawing grid ** //
      PaintBox.Canvas.Pen.Width := LINE_WIDTH;
      PaintBox.Canvas.Pen.Color := GRID_COLOR;

      for GridR := 1 to 2 * FPixelsPerQuadrantSide do
        begin
          PaintBox.Canvas.MoveTo(0, GridR * FGridWH);
          PaintBox.Canvas.LineTo(PaintBox.Width, GridR * FGridWH);
        end;

      for GridC := 1 to 2 * FPixelsPerQuadrantSide do
        begin
          PaintBox.Canvas.MoveTo(GridC * FGridWH, 0);
          PaintBox.Canvas.LineTo(GridC * FGridWH, PaintBox.Height);
        end;
    end;

  // ** drawing arrows ** //
  if FCenterOrigin then
    begin
      PaintBox.Canvas.Pen.Color := AXIS_COLOR;
      HalfPaintBox := (PaintBox.Width - IfThen(FRealSize, 0, FGridWH)) div 2;
      // ** vertical arrow ** //
      PaintBox.Canvas.MoveTo(HalfPaintBox, 0);
      PaintBox.Canvas.LineTo(HalfPaintBox, PaintBox.Height);
      PaintBox.Canvas.LineTo(HalfPaintBox - 7, PaintBox.Height - 9);
      PaintBox.Canvas.MoveTo(HalfPaintBox, PaintBox.Height);
      PaintBox.Canvas.LineTo(HalfPaintBox + 7, PaintBox.Height - 9);
      // ** horizontal arrow ** //
      PaintBox.Canvas.MoveTo(0, HalfPaintBox);
      PaintBox.Canvas.LineTo(PaintBox.Width, HalfPaintBox);
      PaintBox.Canvas.LineTo(PaintBox.Width - 9, HalfPaintBox - 7);
      PaintBox.Canvas.MoveTo(PaintBox.Width, HalfPaintBox);
      PaintBox.Canvas.LineTo(PaintBox.Width - 9, HalfPaintBox + 7);
    end;

  // ** drawing shapes ** //
  Multiplier := IfThen(FRealSize, 1, FGridWH);
  PaintBox.Canvas.Pen.Width := LINE_WIDTH;

  for I := 0 to FCircles.Count - 1 do
    with FCircles.Items[I] do
      begin
        CX := OffsetCoordinate(CX);
        CY := OffsetCoordinate(CY);
        PaintBox.Canvas.Pen.Color := Color;
        PaintBox.Canvas.Brush.Color := Color;
        PaintBox.Canvas.Ellipse(
          Round(CX * Multiplier) - R,
          Round(CY * Multiplier) - R,
          Round(CX * Multiplier) + R,
          Round(CY * Multiplier) + R
        );
      end;

  PaintBox.Canvas.Brush.Style := bsClear;

  for I := 0 to FEllipses.Count - 1 do
    with FEllipses.Items[I] do
      begin
        PaintBox.Canvas.Pen.Color := Color;
        PaintBox.Canvas.Ellipse(
          Round(OffsetCoordinate(X1) * Multiplier),
          Round(OffsetCoordinate(Y1) * Multiplier),
          Round(OffsetCoordinate(X2) * Multiplier),
          Round(OffsetCoordinate(Y2) * Multiplier)
        );
      end;

  for I := 0 to FLines.Count - 1 do
    with FLines.Items[I] do
      begin
        PaintBox.Canvas.Pen.Color := Color;
        PaintBox.Canvas.MoveTo(Round(OffsetCoordinate(X1) * Multiplier), Round(OffsetCoordinate(Y1) * Multiplier));
        PaintBox.Canvas.LineTo(Round(OffsetCoordinate(X2) * Multiplier), Round(OffsetCoordinate(Y2) * Multiplier));
      end;

  for I := 0 to FTextLabels.Count - 1 do
    with FTextLabels.Items[I] do
      begin
        PaintBox.Canvas.Font.Color := Color;
        TextWidth := PaintBox.Canvas.TextWidth(Text);
        TextHeight := PaintBox.Canvas.TextHeight(Text);
        PaintBox.Canvas.TextOut(
          Round(OffsetCoordinate(CX) * Multiplier - TextWidth div 2),
          Round(OffsetCoordinate(CY) * Multiplier - TextHeight div 2),
          Text
        );
      end;
end;

procedure TMainForm.PaintBoxMouseLeave(Sender: TObject);
begin
  StatusBar.SimpleText := '';
end;

procedure TMainForm.PaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  C: Integer;
  R: Integer;
begin
  C := UnoffsetCoordinate(IfThen(FRealSize, X, X div FGridWH));
  R := UnoffsetCoordinate(IfThen(FRealSize, Y, Y div FGridWH));
  StatusBar.SimpleText := '(' + IntToStr(C) + ', ' + IntToStr(R) + ')';
end;

procedure TMainForm.CodeEditorKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = vk_F8 then
    ToggleBreakPoint(CodeEditor.CaretY);
end;

procedure TMainForm.CodeEditorGutterClick(Sender: TObject; Button: TMouseButton; X, Y, Line: Integer;
  Mark: TSynEditMark);
begin
  ToggleBreakPoint(Line);
end;

procedure TMainForm.ToggleBreakPoint(Line: Integer);
begin
  if PascalScript.HasBreakPoint(PascalScript.MainFileName, Line) then
    PascalScript.ClearBreakPoint(PascalScript.MainFileName, Line)
  else
    PascalScript.SetBreakPoint(PascalScript.MainFileName, Line);
  CodeEditor.Refresh;
end;

procedure TMainForm.CodeEditorSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean;
  var FG, BG: TColor);
begin
  if PascalScript.HasBreakPoint(PascalScript.MainFileName, Line) then
    begin
      Special := True;
      if Line = FActiveLine then
        begin
          FG := clWhite;
          BG := clPurple;
        end
      else
        begin
          FG := clWhite;
          BG := clRed;
        end;
    end
  else if Line = FActiveLine then
    begin
      Special := True;
      FG := clWhite;
      BG := clBlue;
    end
  else
    Special := False;
end;

procedure TMainForm.PascalScriptCompile(Sender: TPSScript);
begin
  PascalScript.AddMethod(Self, @TMainForm.MyFrac, 'function Frac(X: Double): Double;');
  PascalScript.AddMethod(Self, @TMainForm.MyRandomRange, 'function RandomRange(AFrom, ATo: Integer): Integer;');
  PascalScript.AddMethod(Self, @TMainForm.ReadInt, 'procedure ReadInt(var X: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.ReadFloat, 'procedure ReadFloat(var X: Double);');
  PascalScript.AddMethod(Self, @TMainForm.IsEmpty, 'function IsEmpty: Boolean;');
  PascalScript.AddMethod(Self, @TMainForm.Push, 'procedure Push(X: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.Pop, 'procedure Pop(var X: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.Plot, 'procedure Plot(X, Y: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.PlotEx, 'procedure PlotEx(X, Y, Alpha: Integer)');
  PascalScript.AddMethod(Self, @TMainForm.TurnOff, 'procedure TurnOff(X, Y: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.Invert, 'procedure Invert(X, Y: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.IsOn, 'function IsOn(X, Y: Integer): Boolean;');
  PascalScript.AddMethod(Self, @TMainForm.DrawLine, 'procedure DrawLine(X1, Y1, X2, Y2: Double);');
  PascalScript.AddMethod(Self, @TMainForm.DrawCircle, 'procedure DrawCircle(CX, CY: Double; R: Integer);');
  PascalScript.AddMethod(Self, @TMainForm.DrawEllipse, 'procedure DrawEllipse(X1, Y1, X2, Y2: Double);');
  PascalScript.AddMethod(Self, @TMainForm.DrawText, 'procedure DrawText(CX, CY: Double; Text: String);');
  PascalScript.AddMethod(Self, @TMainForm.SetColor, 'procedure SetColor(Color: String);');
  PascalScript.AddMethod(Self, @TMainForm.SetColorRGB, 'procedure SetColorRGB(R, G, B: Byte);');
  PascalScript.AddMethod(Self, @TMainForm.WriteLn, 'procedure WriteLn(Text: String);');
end;

procedure TMainForm.PascalScriptIdle(Sender: TObject);
begin
  Application.HandleMessage;
  if FResume then
    begin
      FResume := False;
      PascalScript.Resume;
      FActiveLine := 0;
      CodeEditor.Refresh;
    end;
end;

procedure TMainForm.PascalScriptAfterExecute(Sender: TPSScript);
begin
  FActiveLine := 0;
  CodeEditor.Refresh;
end;

procedure TMainForm.PascalScriptBreakpoint(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  ScrollToActiveLine(Row);
end;

procedure TMainForm.PascalScriptLineInfo(Sender: TObject; const FileName: AnsiString; Position, Row, Col: Cardinal);
begin
  if ((PascalScript.Exec.DebugMode <> dmRun) and (FileName = '')) then
    ScrollToActiveLine(Row);
end;

function TMainForm.PascalScriptNeedFile(Sender: TObject; const OrginFileName: AnsiString;
  var FileName, Output: AnsiString): Boolean;
var
  FilePath: String;
begin
  FilePath := TPath.Combine(ExtractFilePath(Application.ExeName), String(FileName));

  if FileExists(FilePath) then
    begin
      Result := True;
      Output := AnsiString(TFile.ReadAllText(FilePath));
    end
  else
    Result := False;
end;

{ =============================================
  =                 Functions                 =
  ============================================= }

function TMainForm.Compile: Boolean;
var
  I: LongInt;
  CompilerErrors: String;
  CompilerMessage: TPSPascalCompilerMessage;
begin
  ConsoleMemo.Clear;
  FStack.Clear;

  PascalScript.Script.Assign(CodeEditor.Lines);
  Result := PascalScript.Compile;

  CompilerErrors := '';
  for I := 0 to PascalScript.CompilerMessageCount - 1 do
    begin
      CompilerMessage := PascalScript.CompilerMessages[I];
      if CompilerMessage.ClassType = TPSPascalCompilerError then
        CompilerErrors := CompilerErrors + String(CompilerMessage.MessageToString) + #13
      else
        WriteLn(String(CompilerMessage.MessageToString));
    end;

  if not Result then
    MessageDlg(CompilerErrors, mtError, [mbOK], 0);
end;

function TMainForm.Execute: Boolean;
var
  Msg: AnsiString;
begin
  if PascalScript.Execute then
    Result := True
  else
    begin
      if PascalScript.ExecErrorParam <> '' then
        Msg := PascalScript.ExecErrorParam
      else
        Msg := PascalScript.ExecErrorToString;
      MessageDlg('[Exception] (' + IntToStr(PascalScript.ExecErrorRow) + ':' + IntToStr(PascalScript.ExecErrorCol) +
        '): ' + String(Msg), mtError, [mbOK], 0);
      Result := False;
    end;
end;

function TMainForm.FormatComplex(s: String): String;
var
  I: Integer;
  FlPtNum: String;
begin
  // sample input string
  // '[ 0.00000000000000E+0000, 0.00000000000000E+0000, 0.00000000000000E+0000]'

  I := 1;
  Result := '';
  while I <= Length(s) do
    begin

      while (not CharInSet(s[I], ['0' .. '9', '.', 'E', '-', '+'])) and (I <= Length(s)) do
        begin
          Result := Result + s[I];
          Inc(I);
        end;

      FlPtNum := '';

      while CharInSet(s[I], ['0' .. '9', '.', 'E', '-', '+']) and (I <= Length(s)) do
        begin
          FlPtNum := FlPtNum + s[I];
          Inc(I);
        end;

      if FlPtNum <> '' then
        Result := Result + FloatToStr(StrToFloat(FlPtNum, FFormat), FFormat);
    end;
end;

function TMainForm.PixelExists(X: Integer; Y: Integer): Boolean;
begin
  Result := False;
  if FPixels.ContainsKey(X) then
    if FPixels.Items[X].ContainsKey(Y) then
      Result := True;
end;

function TMainForm.MixBytes(FG, BG, TRANS: Byte): Byte;
asm
  push bx
  push cx
  push dx
  mov DH, TRANS
  mov BL, FG
  mov AL, DH
  mov CL, BG
  xor AH, AH
  xor BH, BH
  xor CH, CH
  mul BL
  mov BX, AX
  xor AH, AH
  mov AL, DH
  xor AL, $FF
  mul CL
  add AX, BX
  shr AX, 8
  pop dx
  pop cx
  pop bx
end;

function TMainForm.MixColors(FG, BG: TColor; T: Byte): TColor;
var
  R, G, B: Byte;
begin
  R := MixBytes(FG and 255, BG and 255, T);
  G := MixBytes((FG shr 8) and 255, (BG shr 8) and 255, T);
  B := MixBytes((FG shr 16) and 255, (BG shr 16) and 255, T);
  Result := R + G * 256 + B * 65536;
end;

function TMainForm.OffsetCoordinate(X: Integer): Integer;
var
  Offset: Integer;
begin
  Offset := IfThen(FRealSize, PaintBox.Width div 2, FPixelsPerQuadrantSide);
  Result := IfThen(FCenterOrigin, X + Offset, X);
end;

function TMainForm.OffsetCoordinate(X: Double): Double;
var
  Offset: Integer;
begin
  Offset := IfThen(FRealSize, PaintBox.Width div 2, FPixelsPerQuadrantSide);
  Result := IfThen(FCenterOrigin, X + Offset, X);
end;

function TMainForm.UnoffsetCoordinate(X: Integer): Integer;
var
  Offset: Integer;
begin
  Offset := IfThen(FRealSize, PaintBox.Width div 2, FPixelsPerQuadrantSide);
  Result := IfThen(FCenterOrigin, X - Offset, X);
end;

{ =============================================
  =                Procedures                 =
  ============================================= }

procedure TMainForm.ClearScreen;
begin
  FLines.Clear;
  FCircles.Clear;
  FEllipses.Clear;
  FTextLabels.Clear;
  FPixels.Clear;

  StopButton.Click;
  MainForm.PaintBox.Refresh;
  RealSizeForm.RealSizePaintBox.Refresh;
end;

procedure TMainForm.AdjustRightPanel;
var
  RightPanelWidth: Integer;
  PotentialLeftPanelWidth: Integer;
  PotentialRightPanelWidth: Integer;
begin
  PotentialLeftPanelWidth := (ClientWidth * LeftPanelWidthScrollBar.Position) div LeftPanelWidthScrollBar.Max;
  PotentialRightPanelWidth := ClientWidth - PotentialLeftPanelWidth;

  RightPanelWidth := Min(PotentialRightPanelWidth, RightPanel.Height);
  // get a number that's divisible with 2 * FPixelsPerQuadrantSide + 1
  RightPanelWidth := RightPanelWidth - RightPanelWidth mod (2 * FPixelsPerQuadrantSide + 1);
  // add a couple of extra pixels for the last line
  RightPanelWidth := RightPanelWidth + LINE_WIDTH;

  LeftPanel.Width := ClientWidth - RightPanelWidth;
  RightPanel.Width := RightPanelWidth;
  RightPanel.Left := LeftPanel.Width;
  PaintBox.Width := RightPanelWidth;
  PaintBox.Height := RightPanelWidth;

  FGridWH := RightPanelWidth div (2 * FPixelsPerQuadrantSide + 1);
end;

procedure TMainForm.RefreshPaintBoxes;
var
  I: Integer;
  NumberOfIntervals: Integer;
begin
  with MainForm do
    begin
      PaintBox.Refresh;
      RealSizeForm.RealSizePaintBox.Refresh;

      {
        Da bi aplikacija mogla da obrađuje događaje i kako se ne bi zamrzla, vreme
        za spavanje delimo na kraće intervale i nakon svakog tražimo obradu poruka.
      }

      NumberOfIntervals := (SpeedScrollBar.Max - SpeedScrollBar.Position) div SLEEP_INTERVAL_DURATION;

      if NumberOfIntervals = 0 then
        begin
          Sleep(1);
          Application.ProcessMessages;
        end
      else
        for I := 1 to NumberOfIntervals do
          begin
            Sleep(SLEEP_INTERVAL_DURATION);
            Application.ProcessMessages;
          end;
    end;
end;

procedure TMainForm.CheckRange(Arr: Array of Integer);
var
  A: Integer;
  MinC: Integer;
  MaxC: Integer;
begin
  for A in Arr do
    begin
      if FCenterOrigin then
        begin
          MaxC := IfThen(FRealSize, (PaintBox.Width - FGridWH) div 2, FPixelsPerQuadrantSide);
          MinC := -MaxC;
        end
      else
        begin
          MinC := 0;
          MaxC := IfThen(FRealSize, PaintBox.Width, FPixelsPerQuadrantSide);
        end;
      if not((A >= MinC) and (A <= MaxC)) then
        raise ERangeError.Create(FloatToStr(A, FFormat) + ' is out of range');
    end;
end;

procedure TMainForm.SaveFile(FileName: String);
var
  StringList: TStrings;
begin
  StringList := TStringList.Create;

  try
    StringList.Text := CodeEditor.Text;
    StringList.SaveToFile(FileName);
  finally
    StringList.Free;
  end;
end;

procedure TMainForm.SetRealSize(RealSize: Boolean);
var
  OldRealSize: Boolean;
begin
  OldRealSize := FRealSize;
  FRealSize := RealSize;
  if OldRealSize <> FRealSize then
    ClearScreen;

  if FRealSize then
    RealSizeForm.Close;

  RealSizeButton.Enabled := not FRealSize;
end;

procedure TMainForm.SetCenterOrigin(CenterOrigin: Boolean);
var
  OldCenterOrigin: Boolean;
begin
  OldCenterOrigin := FCenterOrigin;
  FCenterOrigin := CenterOrigin;
  if OldCenterOrigin <> FCenterOrigin then
    ClearScreen;
end;

procedure TMainForm.SetCurrentFile(FileName: String);
begin
  FCurrentFileName := FileName;
  Self.Caption := Application.Title;
  if FileName <> '' then
    Self.Caption := Self.Caption + ' - ' + FileName;
  PascalScript.ClearBreakPoints;
  ClearScreen;
end;

procedure TMainForm.ResizeGrid(Dimensions: Integer);
begin
  FPixelsPerQuadrantSide := Dimensions;

  if RealSizeForm <> nil then
    begin
      RealSizeForm.ClientWidth := 2 * FPixelsPerQuadrantSide;
      RealSizeForm.ClientHeight := 2 * FPixelsPerQuadrantSide;
    end;

  ClearScreen;
  AdjustRightPanel;
end;

procedure TMainForm.ScrollToActiveLine(Row: Cardinal);
begin
  FActiveLine := Row;
  CodeEditor.CaretX := 1;
  CodeEditor.CaretY := FActiveLine;

  if (FActiveLine < CodeEditor.TopLine + 2) or (FActiveLine > CodeEditor.TopLine + CodeEditor.LinesInWindow - 2) then
    CodeEditor.TopLine := FActiveLine - (CodeEditor.LinesInWindow div 2);

  WatchTableRefresh;
  CodeEditor.Refresh;
end;

procedure TMainForm.PutPixel(X, Y: Integer; Color: TColor);
begin
  if not FPixels.ContainsKey(X) then
    FPixels.Add(X, TDictionary<Integer, TColor>.Create);
  FPixels.Items[X].AddOrSetValue(Y, Color);
end;

procedure TMainForm.RemovePixel(X: Integer; Y: Integer);
begin
  if PixelExists(X, Y) then
    begin
      FPixels.Items[X].Remove(Y);
      if FPixels.Items[X].Count = 0 then
        FPixels.Remove(X);
    end;
end;

{ =============================================
  =          Pascal Script Functions          =
  ============================================= }

function TMainForm.MyFrac(X: Double): Double;
begin
  Result := Frac(X);
end;

function TMainForm.MyRandomRange(AFrom, ATo: Integer): Integer;
begin
  Result := RandomRange(AFrom, ATo);
end;

procedure TMainForm.ReadInt(var X: Integer);
var
  S: String;
begin
  if InputQuery('[Pascal Script]', 'Enter integer value:', s) then
    if not TryStrToInt(s, X) then
      if MessageDlg('Input error, integer value is expected!', mtError, [mbOK, mbCancel], 0) = mrOK then
        Read(X)
      else
        PascalScript.Stop;
end;

procedure TMainForm.ReadFloat(var X: Double);
var
  S: String;
begin
  if InputQuery('[Pascal Script]', 'Enter floating point value:', S) then
    if not TryStrToFloat(S, X, FFormat) then
      if MessageDlg('Input error, floating point value is expected!', mtError, [mbOK, mbCancel], 0) = mrOK then
        Read(X)
      else
        PascalScript.Stop;
end;

function TMainForm.IsEmpty: Boolean;
begin
  Result := FStack.Count = 0;
end;

procedure TMainForm.Push(X: Integer);
begin
  FStack.Add(X);
end;

procedure TMainForm.Pop(var X: Integer);
begin
  if FStack.Count > 0 then
    begin
      X := FStack.Last;
      FStack.Delete(FStack.Count - 1);
    end
  else
    raise EListError.Create('Stack is empty');
end;

procedure TMainForm.Plot(X, Y: Integer);
var
  Color: Integer;
begin
  CheckRange([X, Y]);
  Color := ColorShape.Brush.Color;

  if Color <> BLANK_COLOR then
    PutPixel(X, Y, Color)
  else
    RemovePixel(X, Y);

  RefreshPaintBoxes;
end;

procedure TMainForm.PlotEx(X, Y, Alpha: Integer);
begin
  CheckRange([X, Y]);
  PutPixel(X, Y, MixColors(ColorShape.Brush.Color, BLANK_COLOR, Alpha));
  RefreshPaintBoxes;
end;

procedure TMainForm.TurnOff(X, Y: Integer);
begin
  CheckRange([X, Y]);
  RemovePixel(X, Y);
  RefreshPaintBoxes;
end;

procedure TMainForm.Invert(X, Y: Integer);
begin
  CheckRange([X, Y]);
  if PixelExists(X, Y) then
    RemovePixel(X, Y)
  else
    PutPixel(X, Y, ColorShape.Brush.Color);
  RefreshPaintBoxes;
end;

function TMainForm.IsOn(X, Y: Integer): Boolean;
begin
  CheckRange([X, Y]);
  Result := PixelExists(X, Y);
end;

procedure TMainForm.DrawLine(X1, Y1, X2, Y2: Double);
begin
  CheckRange([Round(X1), Round(Y1), Round(X2), Round(Y2)]);
  FLines.Add(TPointPair.Create(X1, Y1, X2, Y2, ColorShape.Brush.Color));
  PaintBox.Refresh;
end;

procedure TMainForm.DrawCircle(CX, CY: Double; R: Integer);
begin
  CheckRange([Round(CX),Round(CY)]);
  FCircles.Add(TCircle.Create(CX, CY, R, ColorShape.Brush.Color));
  MainForm.PaintBox.Refresh;
end;

procedure TMainForm.DrawEllipse(X1, Y1, X2, Y2: Double);
begin
  CheckRange([Round(X1), Round(Y1), Round(X2), Round(Y2)]);
  FEllipses.Add(TPointPair.Create(X1, Y1, X2, Y2, ColorShape.Brush.Color));
  MainForm.PaintBox.Refresh;
end;

procedure TMainForm.DrawText(CX, CY: Double; Text: String);
begin
  CheckRange([Round(CX),Round(CY)]);
  FTextLabels.Add(TTextLabel.Create(CX, CY, Text, ColorShape.Brush.Color));
  MainForm.PaintBox.Refresh;
end;

procedure TMainForm.SetColor(Color: String);
begin
  ColorShape.Brush.Color := StringToColor(Color);
end;

procedure TMainForm.SetColorRGB(R, G, B: Byte);
begin
  ColorShape.Brush.Color := RGB(R, G, B);
end;

procedure TMainForm.WriteLn(Text: String);
begin
  ConsoleMemo.Lines.Append(Text);
  ConsoleMemo.Lines.Text := TrimRight(ConsoleMemo.Lines.Text);
end;

end.
