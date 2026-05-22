namespace Top.Top;

using Microsoft.Sales.Receivables;
using Microsoft.Bank.Payment;

pageextension 50058 "Apply Customer Entries" extends "Apply Customer Entries"
{
    layout
    {


        addafter("Currency Code")
        {


            field("Document Externe"; Rec."External Document No.")
            {
                ApplicationArea = all;
                Editable = false;
            }
            field("Sales (LCY)"; Rec."Sales (LCY)")
            {
                ApplicationArea = all;
                Editable = false;
                Caption = 'Montant HT';
            }
        }
    }

    /*  trigger OnQueryClosePage(CloseAction: Action): Boolean
      var
          PL: Record "Payment Line";
      begin

          if Rec.FindSet() then
              repeat
                  if Rec."Applies-to ID" <> '' then begin
                      PL.Reset();
                      PL.SetRange("Applies-to ID", Rec."Applies-to ID");

                      if PL.FindFirst() then begin
                          if PL."Due Date" <> PL.DateEch then begin
                              PL."Due Date" := PL.DateEch;
                              PL.Modify();
                          end;
                      end;
                  end;
              until Rec.Next() = 0;

          exit(true);
      end;*/
}
