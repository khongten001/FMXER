unit FMXER.ListViewFrame;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, Generics.Collections, System.Rtti;

type
  TListViewItemClickProc = reference to procedure (const AItem: TListViewItem);

  TListViewFrame = class(TFrame)
    ListView: TListView;
    procedure ListViewItemClick(const Sender: TObject;
      const AItem: TListViewItem);
    procedure ListViewPullRefresh(Sender: TObject);
  private
    FOnSelectHandlers: TDictionary<TListViewItem, TListViewItemClickProc>;
    FItemBuilderProc: TProc;
    function GetItemAppearance: string;
    procedure SetItemAppearance(const Value: string);
    procedure SetItemBuilderProc(Value: TProc);
    function GetSelectedItem: TListViewItem;
    function GetAccessoryVisible: Boolean;
    procedure SetAccessoryVisible(const Value: Boolean);
    function GetSearchVisible: Boolean;
    procedure SetSearchVisible(const Value: Boolean);
    function GetCanSwipeDelete: Boolean;
    procedure SetCanSwipeDelete(const Value: Boolean);
  protected
    procedure RebuildItems; virtual;
    procedure HitTestChanged; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure AfterConstruction; override;

    function AddItem(const AText: string; const ADetailText: string = '';
      const AImageIndex: Integer = -1; const AOnSelect: TListViewItemClickProc = nil): TListViewItem;
    procedure ClearItems;

    property AccessoryVisible: Boolean read GetAccessoryVisible write SetAccessoryVisible;
    property CanSwipeDelete: Boolean read GetCanSwipeDelete write SetCanSwipeDelete;
    property ItemAppearance: string read GetItemAppearance write SetItemAppearance;
    property ItemBuilderProc: TProc read FItemBuilderProc write SetItemBuilderProc;
    property SearchVisible: Boolean read GetSearchVisible write SetSearchVisible;
    property SelectedItem: TListViewItem read GetSelectedItem;
  end;

implementation

{$R *.fmx}

uses
  FMXER.IconFontsData;

{ TListViewFrame }

function TListViewFrame.AddItem(const AText: string; const ADetailText: string = '';
  const AImageIndex: Integer = -1; const AOnSelect: TListViewItemClickProc = nil): TListViewItem;
begin
  Result := ListView.Items.Add;

  Result.Text := AText;
  Result.Detail := ADetailText;
  if AImageIndex <> -1 then
    Result.ImageIndex := AImageIndex;

  if Assigned(AOnSelect) then
    FOnSelectHandlers.Add(Result, AOnSelect);

end;

procedure TListViewFrame.AfterConstruction;
begin
  inherited;
  if not Assigned(ListView.Images) then
    ListView.Images := IconFonts.ImageList;
end;

procedure TListViewFrame.ClearItems;
begin
  ListView.Items.BeginUpdate;
  try
    ListView.Items.Clear;
  finally
    ListView.Items.EndUpdate;
  end;
end;

constructor TListViewFrame.Create(AOwner: TComponent);
begin
  inherited;
  FOnSelectHandlers := TDictionary<TListViewItem, TListViewItemClickProc>.Create();
end;

destructor TListViewFrame.Destroy;
begin
  FreeAndNil(FOnSelectHandlers);
  inherited;
end;

function TListViewFrame.GetAccessoryVisible: Boolean;
begin
  Result := Assigned(ListView)
    and ListView.ItemAppearanceObjects.ItemObjects.Accessory.Visible;
end;

function TListViewFrame.GetCanSwipeDelete: Boolean;
begin
  if not Assigned(ListView) then
    Exit(False);

  Result := ListView.CanSwipeDelete;
end;

function TListViewFrame.GetItemAppearance: string;
begin
  Result := Listview.ItemAppearance.ItemAppearance;
end;

function TListViewFrame.GetSearchVisible: Boolean;
begin
  if not Assigned(ListView) then
    Exit(False);

  Result := ListView.SearchVisible
end;

function TListViewFrame.GetSelectedItem: TListViewItem;
begin
  Result := ListView.Selected as TListViewItem;
end;

procedure TListViewFrame.HitTestChanged;
begin
  inherited;
  if Assigned(ListView) then
    ListView.HitTest := HitTest;
end;

procedure TListViewFrame.ListViewItemClick(const Sender: TObject;
  const AItem: TListViewItem);
begin
  var LHandler: TListViewItemClickProc := nil;
  if FOnSelectHandlers.TryGetValue(AItem, LHandler) and Assigned(LHandler) then
    LHandler(AItem);
end;

procedure TListViewFrame.ListViewPullRefresh(Sender: TObject);
begin
  RebuildItems;
end;

procedure TListViewFrame.RebuildItems;
begin
  FOnSelectHandlers.Clear;

  if Assigned(FItemBuilderProc) then
    FItemBuilderProc()
  else
    ListView.Items.Clear;
end;

procedure TListViewFrame.SetAccessoryVisible(const Value: Boolean);
begin
  if not Assigned(ListView) then
    Exit;

  ListView.ItemAppearanceObjects.ItemObjects.Accessory.Visible := Value;
end;

procedure TListViewFrame.SetCanSwipeDelete(const Value: Boolean);
begin
  if not Assigned(ListView) then
    Exit;

  ListView.CanSwipeDelete := Value;
end;

procedure TListViewFrame.SetItemAppearance(const Value: string);
begin
  Listview.ItemAppearance.ItemAppearance := Value;
end;

procedure TListViewFrame.SetItemBuilderProc(Value: TProc);
begin
  if TProc(FItemBuilderProc) <> TProc(Value) then
  begin
    FItemBuilderProc := Value;

    RebuildItems;
  end;
end;

procedure TListViewFrame.SetSearchVisible(const Value: Boolean);
begin
  if not Assigned(ListView) then
    Exit;

  ListView.SearchVisible := Value;
end;

end.
