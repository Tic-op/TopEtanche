namespace TopEtanch.TopEtanch;


using Microsoft.Purchases.History;

page 50068 "Mettre à jour le document"
{
    ApplicationArea = All;
    Caption = 'Mettre à jour le document';
    PageType = Card;
    SourceTable = "Purch. Inv. Header";
    SourceTableView = SORTING("No.");
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = true;
    ModifyAllowed = true;
    Permissions = tabledata "Purch. Inv. Header" = m;



    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Général';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the posted invoice number.';
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor';
                    Editable = false;
                    ToolTip = 'Specifies the name of the vendor who shipped the items.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    ToolTip = 'Specifies the date the purchase header was posted.';
                }
            }
            group("Invoice Details")
            {
                Caption = 'Détails facture';
                field("Payment Reference"; Rec."Payment Reference")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the payment of the purchase invoice.';
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies how to make payment, such as with bank transfer, cash, or check.';
                }
                field("Creditor No."; Rec."Creditor No.")
                {
                    ApplicationArea = All;
                    Editable = true;
                    ToolTip = 'Specifies the number of the vendor.';
                }
                field("Posting Description"; Rec."Posting Description")
                {
                    ApplicationArea = All;
                    ;
                    Editable = true;
                    ToolTip = 'Specifies any text that is entered to accompany the posting, for example for information to auditors.';
                }
                field("Vendor Invoice No."; rec."Vendor Invoice No.")
                {
                    ApplicationArea = all;
                    Editable = true;
                }
            }
            group(Shipping)
            {
                Caption = 'Expédition';
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = All;
                    Caption = 'Code adresse destinataire';
                    Editable = true;

                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(MAJ)
            {
                ApplicationArea = All;
                Caption = 'Modifier';
                Promoted = true;
                PromotedCategory = Process;
                trigger OnAction()
                begin
                    UpdateVendsInvNum(rec, New_Vendor_Invoice_No);
                    CurrPage.Update();
                    Close();
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        New_Vendor_Invoice_No := Rec."Vendor Invoice No.";
    end;

    var
        New_Vendor_Invoice_No: Code[35];

    procedure UpdateVendsInvNum(var PurchInvH: Record "Purch. Inv. Header"; New_Vendor_Invoice_No: Code[35])
    begin
        if "New_Vendor_Invoice_No" <> PurchInvH."Vendor Invoice No." then begin
            PurchInvH.Validate("Vendor Invoice No.", New_Vendor_Invoice_No);
            PurchInvH.Modify();
        end;
    end;

    trigger OnOpenPage()
    begin
        xPurchInvHeader := Rec;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::LookupOK then
            if RecordChanged() then
                CODEUNIT.Run(CODEUNIT::"Purch. Inv. Header - Edit", Rec);
    end;

    var

        xPurchInvHeader: Record "Purch. Inv. Header";

    local procedure RecordChanged() IsChanged: Boolean
    begin
        IsChanged :=
            (Rec."Payment Reference" <> xPurchInvHeader."Payment Reference") or
            (Rec."Payment Method Code" <> xPurchInvHeader."Payment Method Code") or
            (Rec."Creditor No." <> xPurchInvHeader."Creditor No.") or
            (Rec."Ship-to Code" <> xPurchInvHeader."Ship-to Code") or
            (Rec."Posting Description" <> xPurchInvHeader."Posting Description");

        OnAfterRecordChanged(Rec, xRec, IsChanged, xPurchInvHeader);
    end;

    procedure SetRec(PurchInvHeader: Record "Purch. Inv. Header")
    begin
        Rec := PurchInvHeader;
        Rec.Insert();
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRecordChanged(var PurchInvHeader: Record "Purch. Inv. Header"; xPurchInvHeader: Record "Purch. Inv. Header"; var IsChanged: Boolean; xPurchInvHeaderGlobal: Record "Purch. Inv. Header")
    begin
    end;
}


