namespace Top.Top;
using Microsoft.Inventory.Journal;
using Microsoft.Inventory.Location;

report 50031 "Mise à jour magasin"
{
    Caption = 'Mise à jour magasin';

    UsageCategory = None;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(ItemJnlLine; "Item Journal Line")
        {


            RequestFilterFields = Description;

            trigger OnAfterGetRecord()
            begin
                if NewLocationCode = '' then
                    Error('Veuillez saisir un code magasin.');

                if ItemJnlLine."New Location Code" <> NewLocationCode then begin
                    ItemJnlLine.Validate("New Location Code", NewLocationCode);
                    ItemJnlLine.Modify(true);
                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    Caption = 'Options';

                    field(NewLocationCode; NewLocationCode)
                    {
                        Caption = 'Nouveau magasin';
                        ApplicationArea = All;
                        TableRelation = Location;
                    }
                }
            }
        }
    }

    var
        NewLocationCode: Code[10];
}
