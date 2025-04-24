unit InspectVariableUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TInspectVariableForm = class(TForm)
    VariableValueMemo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  InspectVariableForm: TInspectVariableForm;

implementation

{$R *.dfm}

end.
