namespace PHARMATEC.PHARMATEC;

using Microsoft.Inventory.Location;

page 50073 Magasin
{
    APIGroup = 'apiGroup';
    APIPublisher = 'TOP_ETANCH';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'magasin';
    DelayedInsert = true;
    EntityName = 'magasin';
    EntitySetName = 'magasins';
    PageType = API;
    SourceTable = Location;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(SystemId; Rec.SystemId) { }
                field("Stock"; Rec."Valeur Stock")
                {
                    /* Trigger OnValidate()
                    begin
                        Rec.CalcFields("Valeur Stock");
                    end; */
                }
                field(Code; Rec.Code)
                { }


                part(emplacement; Emplacement)
                {
                    EntitySetName = 'emplacements';
                    EntityName = 'emplacement';
                    SubPageLink = "Location Code" = field(Code);
                }

            }

        }


    }
    var
        article: code[20];

    Trigger OnAfterGetRecord()
    begin

        Rec.CalcFields("Valeur Stock");
    end;


}
