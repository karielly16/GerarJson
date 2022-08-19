unit arquivoJson;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.Imaging.pngimage, System.JSON, Data.DB, Vcl.Grids,
  Vcl.DBGrids, Datasnap.DBClient, Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Data.FMTBcd, Data.SqlExpr, Data.Win.ADODB, shellapi,
  FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.VCLUI.Wait,
  FireDAC.DApt;

type
  TArquivJson = class(TForm)
    imgClose: TImage;
    ShapeNome: TShape;
    edtPath: TEdit;
    btnDelete: TButton;
    DS: TDataSource;
    DBGrid: TDBGrid;
    ShapeDatabase: TShape;
    edtDatabase: TEdit;
    imgFundo: TImage;
    fdDados: TFDMemTable;
    fdDadospath: TStringField;
    fdDadosdatabase: TStringField;
    pnlBackground: TPanel;
    pnlTopo: TPanel;
    pnlEdits: TPanel;
    pnlEditPath: TPanel;
    pnlEditDatabase: TPanel;
    pnlButtons: TPanel;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure imgCloseClick(Sender: TObject);
    procedure DBGridKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnInserirClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    FPathArquivo: String;
  public
    { Public declarations }
  end;

var
  ArquivJson: TArquivJson;
  listas: TStringlist;

const
  ARQUIVO = 'conf.json';

implementation

{$R *.dfm}

uses
  Data.DBXJSON, REST.Response.Adapter, DataSetConverter4D,
  DataSetConverter4D.Impl;

procedure TArquivJson.btnInserirClick(Sender: TObject);
var
  i: Integer;
begin
  try
    fdDados.Insert;
    for i := 0 to ComponentCount - 1 do

    begin
      if Components[i] is TEdit then
        if TEdit(Components[i]).Text = '' then
        begin
          ShowMessage('Existem campos não preenchidos!');
          Abort
        end;


    end;

    fdDadospath.value := edtPath.Text;
    fdDadosdatabase.value := edtDatabase.Text;
    fdDados.Post;

  finally
    edtPath.Clear;
    edtDatabase.Clear;
  end;

end;

procedure TArquivJson.btnDeleteClick(Sender: TObject);
begin
  if Application.MessageBox(PChar('Deseja excluir o cadastro?'), 'Confirmação',
    MB_USEGLYPHCHARS + MB_DEFBUTTON2) = mrYes then
    fdDados.Delete;
end;

procedure TArquivJson.FormClose(Sender: TObject; var Action: TCloseAction);
var
  vJSON: TStringlist;
begin
  vJSON := TStringlist.Create;

  try
    vJSON.Text := TConverter.New.DataSet(fdDados).AsJSONArray.Format;

    vJSON.SaveToFile(FPathArquivo);

  finally
    vJSON.Free;
  end;
end;

procedure TArquivJson.FormCreate(Sender: TObject);
var
  JSON: TStringlist;
begin
  fdDados.Active := true;

  FPathArquivo := ExtractFilePath(Application.ExeName) + ARQUIVO;

  if FileExists(FPathArquivo) then
  begin
    JSON := TStringlist.Create;

    try
      JSON.LoadFromFile(FPathArquivo);

      TConverter.New.JSON.Source
        (TJSONArray(TJSONObject.ParseJSONValue(JSON.Text))).ToDataSet(fdDados);
    finally
      FreeAndNil(JSON);
    end;
  end;

  for var i := 0 to DBGrid.Columns.Count - 1 do
  begin
    DBGrid.Columns[i].Width := 200;

    if i = 0 then
      DBGrid.Columns[i].Title.Caption := 'Caminho'
    else
      DBGrid.Columns[i].Title.Caption := 'Banco de Dados';
  end;
end;

procedure TArquivJson.DBGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Shift = [ssCtrl]) and (Key = 46) then
    Key := 0;
end;

procedure TArquivJson.imgCloseClick(Sender: TObject);
begin
  Close;
end;

end.
