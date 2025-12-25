page 50078 "Droit douane ledger entry"
{
    Caption = 'Détail NGP';
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = DroitDouaneLedgerEntry;

    layout
    {
        area(Content)
        {
            repeater(Repeater1)
            {
                field("DI No"; Rec."DI No")
                {
                    ApplicationArea = All;
                    Visible = false;

                }

                field(NGP; Rec.NGP)
                {
                    ApplicationArea = All;

                }
                field(Origin; Rec.Origin)
                {
                    ApplicationArea = all;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = all;
                }
            }
        }

    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}