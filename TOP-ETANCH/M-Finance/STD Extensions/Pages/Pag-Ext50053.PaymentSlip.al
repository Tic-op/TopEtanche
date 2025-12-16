namespace Top.Top;

using Microsoft.Bank.Payment;

pageextension 50053 "Payment Slip" extends "Payment Slip"
{
     layout
    {

        modify("Document Date")
        {
            Editable = false;

        }
        addlast(Posting) //lets say after general tab

        {

            group("Agios")

            {
                group("Commissions")
                {
                    field("Is commissioned"; Rec."Is commissioned")
                    {
                        ApplicationArea = all;
                    }
                    field(Committees; Rec.Committees)
                    {
                        ApplicationArea = all;
                    }
                    field("VAT Committees"; Rec."VAT Committees")
                    {
                        ApplicationArea = all;

                    }
                }

                group("Interrêts")
                {
                    field(Interest; Rec.Interest)
                    {
                        ApplicationArea = all;

                    }
                    field("Amount Interest (Actual)"; Rec."Amount Interest (Actual)")
                    {
                        ApplicationArea = all;
                    }

                }

            }
        }
    }
}
