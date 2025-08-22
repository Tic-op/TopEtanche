namespace TopEtanch.TopEtanch;
using Microsoft.Purchases.Vendor;

page 50024 "PurchasePlanning List"
{
    ApplicationArea = All;
    Caption = 'Planning de réception';
    PageType = List;
    SourceTable = PurchasePlanning;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; rec."Vendor No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        VendorRec: Record Vendor;
                    begin
                        VendorName := '';
                        if VendorRec.Get(rec."Vendor No.") then
                            VendorName := VendorRec.Name;

                    end;
                }
                field(VendorName; VendorName)
                {
                    ApplicationArea = all;
                    Caption = 'Nom fournisseur';
                }

                field("Expected Date"; rec."Expected Date")
                {
                    ApplicationArea = All;
                }
                field(semaine; GetWeek())
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Approved by Vendor"; rec."Approved by Vendor")
                {
                    ApplicationArea = All;
                }

                field("Real Date"; rec."Real Date")
                {
                    ApplicationArea = All;
                }
                field("Comment"; rec."Comment")
                {
                    ApplicationArea = All;
                }

                field("DOP"; MontantDOPRestante)
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Commandé"; MontantCommande)
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Receptionné"; MontantReceptionne)
                {
                    DecimalPlaces = 0;
                    Editable = false;
                    ApplicationArea = All;

                }


            }

        }

    }
    trigger OnAfterGetRecord()
    begin
        rec.CalculerMontants(MontantCommande, MontantReceptionne, MontantDOPRestante);

        /*   if Vendor.Get(rec."Vendor No.") then
              VendorName := Vendor.Name
          else
              VendorName := ''; */
    end;

    local procedure GetWeek(): Text
    begin
        if rec."Expected Date" <> 0D then
            exit(format(Date2DWY(rec."Expected Date", 2)) + '.' + format(Date2DWY(rec."Expected Date", 3)))

    end;

    var


        MontantCommande, MontantReceptionne, MontantDOPRestante : Decimal;
        Vendor: Record Vendor;
        VendorName: Text;




}