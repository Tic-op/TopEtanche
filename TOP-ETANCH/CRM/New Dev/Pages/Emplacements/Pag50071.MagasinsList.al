namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Location;

page 50071 MagasinsList
{
    APIGroup = 'Item';
    APIPublisher = 'TOP_ETANCH';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'magasinsList';
    DelayedInsert = true;
    EntityName = 'Magasin';
    EntitySetName = 'Magasins';
    PageType = API;
    SourceTable = Location;
    ODataKeyFields = SystemId;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SystemId; Rec.SystemId) { }

                field("code"; Rec.Code)
                {
                    Caption = 'Magasin code';
                }

                field("Name"; Rec.Name)
                {
                    Caption = 'Magasin Name';
                }

            }
        }
    }
    trigger OnOpenPage();
    begin
        Rec.SetFilter("Code", '<>transit');
    end;
}
