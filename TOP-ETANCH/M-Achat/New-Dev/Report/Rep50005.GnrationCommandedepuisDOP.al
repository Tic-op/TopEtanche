namespace TopEtanch.TopEtanch;

using Microsoft.Purchases.Document;

report 50005 "Gén. Cmde depuis Confirmation"
{
    Caption = 'Génération Commande depuis Confirmation';
    ProcessingOnly = true;
    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            //  RequestFilterFields = "No.";
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));

            trigger OnPreDataItem()
            var
                PurchaseLineOrder: Record "Purchase Line";

            begin
                SetRange("No.", OrderNo);
                PurchaseLineOrder.SetRange("Document Type", PurchaseLineOrder."Document Type"::Order);
                PurchaseLineOrder.SetRange("Document No.", OrderNo);
                if not PurchaseLineOrder.IsEmpty then // A discuter ...
                    Error('Cette commande déjà contient des lignes...');
            end;

            trigger OnAfterGetRecord()
            var
                OrderGen: Codeunit "Purchase Order Generator";
            begin

                OrderGen.GenerateOrderLinesFromBlanket(OrderNo, DD, DF);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group("Réceptions prévues")
                {
                    field(DD; DD)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Début';
                    }

                    field(DF; DF)
                    {
                        ApplicationArea = All;
                        Caption = 'Date Fin';
                    }
                }
            }
        }
    }

    var
        OrderNo: Code[20];
        DD: Date;
        DF: Date;

    procedure SetParameters(POrderNo: Code[20])
    begin
        OrderNo := POrderNo;
    end;
}
