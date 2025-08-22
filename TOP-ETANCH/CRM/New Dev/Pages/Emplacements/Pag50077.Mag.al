namespace PHARMATEC.PHARMATEC;

using Microsoft.Inventory.Location;

page 50077 Mag
{
    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    ApplicationArea = All;
    Caption = 'mag';
    DelayedInsert = true;
    EntityName = 'mag';
    EntitySetName = 'mags';
    PageType = API;
    SourceTable = Location;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field("code"; Rec."Code")
                {
                    Caption = 'Code';
                }
                field(valeurStock; Rec."Valeur Stock")
                {
                    Caption = 'Stock';
                }
                part(emp; EmplacementsAPI)
                {
                    ApplicationArea = all;
                    EntitySetName = 'emplacements';
                    EntityName = 'emplacement';
                    SubPageLink = "Location Code" = field("Code");
                    UpdatePropagation = Both;

                }

            }
        }
    }
}
