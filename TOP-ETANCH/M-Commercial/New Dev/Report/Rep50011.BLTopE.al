namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Sales.Customer;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Document;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using Pharmatec_Ticop.Pharmatec_Ticop;

report 50011 "BLTop-E"
{
    ApplicationArea = all;
    Caption = 'Expédition vente enregistrée';
    DefaultLayout = RDLC;
    RDLCLayout = 'BL-Top-E.rdl';
    dataset
    {
        dataitem(SalesSHipmentHeader; "Sales Shipment Header")
        {
            //  DataItemTableView = where ("Document Type"= const("Sales Document Type"::Quote));

            Column(No_; "No.") { }
            Column(Posting_Date; "Posting Date") { }
            Column(Document_Date; "Document Date") { }
            // Column(Quote_Valid_Until_Date;"Quote Valid Until Date"){}
            // Column(Promised_Delivery_Date;"Promised Delivery Date"){}
            Column(Order_No_; "Order No.") { }

            Column(No_Client; "Sell-to Customer No.") { }
            Column(Nom_Client; "Sell-to Customer Name") { }
            Column(Address_Client; "Sell-to Address") { }
            Column(MF_Client; "VAT Registration No.") { }
            Column(Tel_Client; "Sell-to Phone No.") { }
            Column(Mail_Client; "Sell-to E-Mail") { }
            Column(TotalBrut; TotalBrut) { }
            Column(Totalremise; Totalremise) { }
            Column(TotalHT; TotalHT) { }
            Column(totalTVA; TotalTva) { }
            Column(Timbre; Timbre) { }
            Column(Net_a_payer; NetaPayer) { }
            column(txtMntTLettres; txtMntTLettres) { }
            //Debut Companyinf 

            column(CompanyPicture; Companyinf.Picture) { }
            Column(CompanyAddress; Companyinf.Address) { }
            Column(CompanyPhone_No_; Companyinf."Phone No.") { }
            Column(CompanyFax_No_; Companyinf."Fax No.") { }
            column(CompanyVAT_Registration_No_; Companyinf."VAT Registration No.") { }
            Column(CompanyE_Mail; Companyinf."E-Mail") { }
            Column(CompanyHome_Page; Companyinf."Home Page") { }



            // End Companyinf

            dataitem("SalesShipmentLine"; "Sales Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesSHipmentHeader;
                UseTemporary = true;
                // DataItemTableView= where (Type=filter(<> '%1'),"Quantity (Base)" = filter(>0));

                column("Code"; VendorItemCode) { }
                column(Description; Description) { }
                column(Quantité__Base_; "Quantity (Base)") { }
                Column(PU_HT; "Unit Price") { }
                column(Remise_Ligne; "Line Discount %") { }
                Column(PU_TTC; "Unit Price" * (1 - "Line Discount %" / 100) * (1 + "VAT %" / 100)) { }
                Column(MontantHT; "Quantity (Base)" * "Unit Price" * (1 - "Line Discount %" / 100)) { }
                Column(VAT__; "VAT %") { }


                trigger OnAfterGetRecord()
                var
                    item: record Item;
                begin
                    VendorItemCode := '';
                    if item.get("No.") then
                        VendorItemCode := item."Vendor Item No.";
                    If type = type::" " then
                        VendorItemCode := '>>>>>>>>>>'
                end;


            }
            dataitem(TempVATEntry; "VAT Entry")
            {
                UseTemporary = true;


                column(VAT_Prod__Posting_Group; "VAT Prod. Posting Group") { }
                column(AmountTVA; Amount) { }
                column(Base; Base) { }

            }

            trigger OnAfterGetRecord()
            var
                SalesishipLinesTotaux, SIL : record "Sales Shipment Line";
                CUTextMontant: Codeunit "Montant Toute Lettres";
                SE: codeunit SalesEvents;


            begin
                BuildTempVATEntriesFromSalesShipment();
                //  SalesishipLines.setrange("Document Type","Document Type");
                SalesishipLinesTotaux.SetRange("Document No.", "No.");
                // SalesishipLines.CalcSums("Line Amount","Line Discount Amount","Amount Including VAT",Amount,"VAT Base Amount");

                SalesishipLinesTotaux.FindFirst();
                repeat
                    Totalremise += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                      SalesishipLinesTotaux."Line Discount %" / 100;
                    TotalHT += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                      (1 - SalesishipLinesTotaux."Line Discount %" / 100);
                    TotalBrut += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price";
                    TotalTva += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                     (1 - SalesishipLinesTotaux."Line Discount %" / 100) * (SalesishipLinesTotaux."VAT %" / 100);
                    NetaPayer += SalesishipLinesTotaux."Quantity (Base)" * SalesishipLinesTotaux."Unit Price" *
                     (1 - SalesishipLinesTotaux."Line Discount %" / 100) * (1 + SalesishipLinesTotaux."VAT %" / 100);


                until SalesishipLinesTotaux.Next() = 0;
                /*  Totalremise := SalesishipLines."Line Discount Amount";
                 TotalHT:=SalesishipLines."VAT Base Amount";
                 TotalBrut:=TotalHT-Totalremise;
                 TotalTva := SalesishipLines."Amount Including VAT" - TotalHT ;
                 //Timbre := "Stamp Amount";
                 NetaPayer := SalesishipLines."Amount Including VAT"+timbre ; */
                CUTextMontant."Montant en texte"(txtMntTLettres, NetaPayer);

                /*    "No. Printed" += 1;
                  Modify(); */
                //SE.ArchiveDevis("No.");


                Clear(SIL);
                ;
                SIL.SetRange("Document No.", "No.");
                //SIL.SetRange(Type, SIL.Type::Item); 151225
                SIL.FindSet();
                j := SIL.count;

                repeat
                    "SalesShipmentLine".init;

                    "SalesShipmentLine" := SIL;
                    "SalesShipmentLine".Insert();

                    line := SIL."Line No.";
                until SIL.next = 0;



                // IF j MOD 30 <> 0 then 
                for temp_i := j MOD 34 to 22 do begin
                    line += 11;
                    "SalesShipmentLine".Init();
                    "SalesShipmentLine"."Document No." := "No.";
                    "SalesShipmentLine"."Line No." := line;
                    "SalesShipmentLine".Type := "SalesShipmentLine".Type::Item;
                    "SalesShipmentLine".insert(false);
                end;





            end;

            trigger OnPreDataItem()
            begin
                Companyinf.get();
                Companyinf.CalcFields(Picture);
            end;

        }

    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }

    procedure BuildTempVATEntriesFromSalesShipment()
    var
        SalesshipLine: Record "Sales Shipment Line";
        VATAmount: Decimal;
        lig: Integer;
        Customer: Record Customer;
        vatRate: Decimal;
        VAT_PostingGroup: Record "VAT Posting Setup";
    begin
        TempVATEntry.Reset();
        TempVATEntry.DeleteAll();


        SalesshipLine.SetRange("Document No.", SalesSHipmentHeader."No.");
        SalesshipLine.SetRange(Type, SalesshipLine.Type::Item);

        if SalesshipLine.FindSet() then
            repeat
                vatRate := SalesshipLine."VAT %";
                if vatRate = 0 then begin //cas d'exo ou en suspension 
                    Customer.get(SalesshipLine."Sell-to Customer No.");
                    VAT_PostingGroup.GET(Customer."VAT Bus. Posting Group", SalesshipLine."VAT Prod. Posting Group");
                    vatRate := VAT_PostingGroup."VAT %";
                end;

                VATAmount :=
                Round(
                    SalesshipLine."Item Charge Base Amount" * vatRate / 100,
                    0.001);




                lig += 1;
                TempVATEntry.Init();
                TempVATEntry."Entry No." := lig;
                TempVATEntry."Posting Date" := SalesshipLine."Posting Date";
                TempVATEntry."Document No." := SalesshipLine."No.";
                TempVATEntry."VAT Bus. Posting Group" := SalesshipLine."VAT Bus. Posting Group";
                TempVATEntry."VAT Prod. Posting Group" := SalesshipLine."VAT Prod. Posting Group";
                //      TempVATEntry. := SalesLine."VAT %";
                TempVATEntry.Base := SalesshipLine."Item Charge Base Amount";
                TempVATEntry.Amount := VATAmount;

                TempVATEntry.Insert();

            until SalesshipLine.Next() = 0;
    end;

    var
        VendorItemCode: Code[25];
        TotalBrut, Totalremise, TotalTva, Timbre, TotalHT, NetaPayer : decimal;
        i, temp_i, J, Line : integer;
        txtMntTLettres: text;
        Companyinf: Record "Company Information";

}
