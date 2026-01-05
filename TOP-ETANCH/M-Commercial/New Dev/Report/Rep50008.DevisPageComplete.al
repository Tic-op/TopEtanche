namespace Top.Top;

using Microsoft.Sales.Document;
using Microsoft.Finance.VAT.Setup;
using Microsoft.Sales.Customer;
using Microsoft.Finance.VAT.Ledger;
using Microsoft.Foundation.Company;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Inventory.Item;

report 50008 DevisPageComplete
{
    ApplicationArea = all;
    Caption = 'Devis';
    DefaultLayout = RDLC;
    RDLCLayout = 'Devis_Top.rdl';
    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const("Sales Document Type"::Quote));

            Column(No_; "No.") { }
            Column(Posting_Date; "Posting Date") { }
            Column(Document_Date; "Document Date") { }
            Column(Quote_Valid_Until_Date; "Quote Valid Until Date") { }
            Column(Promised_Delivery_Date; SalesHeader."Requested Delivery Date") { }

            Column(No_Client; "Sell-to Customer No.") { }
            Column(Nom_Client; "Sell-to Customer Name") { }
            Column(Address_Client; "Sell-to Address") { }
            Column(MF_Client; "VAT Registration No.") { }
            Column(Tel_Client; SalesHeader."Sell-to Phone No.") { }
            Column(Mail_Client; SalesHeader."Sell-to E-Mail") { }
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

            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesHeader;
                UseTemporary = true;
                //DataItemTableView= where (Type = const ("Sales Line Type"::Item));//,"Quantity (Base)" = filter(>0));

                column("Code"; VendorItemCode) { }
                column(Description; Description) { }
                column(Quantité__Base_; "Quantity (Base)") { }
                Column(PU_HT; "Unit Price") { }
                column(Remise_Ligne; "Line Discount %") { }
                Column(PU_TTC; "Unit Price" * (1 - "Line Discount %" / 100) * (1 + "VAT %" / 100)) { }
                Column(MontantHT; "Line Amount") { }
                Column(VAT__; "VAT %") { }


                trigger OnAfterGetRecord()
                var
                    item: record Item;
                begin
                    VendorItemCode := '';
                    if item.get("No.") then
                        VendorItemCode := item."Vendor Item No.";
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
                SalesLines, SIL : record "Sales Line";
                CUTextMontant: Codeunit "Montant Toute Lettres";
                SE: codeunit SalesEvents;


            begin

                BuildTempVATEntriesFromSalesOrder;


                SalesLines.setrange("Document Type", "Document Type");
                SalesLines.SetRange("Document No.", "No.");
                SalesLines.CalcSums("Line Amount", "Line Discount Amount", "Amount Including VAT", Amount);
                Totalremise := SalesLines."Line Discount Amount";
                TotalHT := SalesLines."Line Amount";
                TotalBrut := TotalHT - Totalremise;
                TotalTva := SalesLines."Amount Including VAT" - TotalHT;
                Timbre := "Stamp Amount";
                NetaPayer := SalesLines."Amount Including VAT" + timbre;
                CUTextMontant."Montant en texte"(txtMntTLettres, NetaPayer);

                "No. Printed" += 1;
                Modify();
                SE.ArchiveDevis("No.");


                Clear(SIL);
                ;
                SIL.SetRange("Document No.", "No.");
                // SIL.SetRange(Type, SIL.Type::Item); 
                SIL.FindSet();
                j := SIL.count;

                repeat
                    "Sales Line".init;

                    "Sales Line" := SIL;
                    "Sales Line".Insert();

                    line := SIL."Line No.";
                until SIL.next = 0;



                // IF j MOD 30 <> 0 then 
                for temp_i := j MOD 32 to 21 do begin
                    line += 11;
                    "Sales Line".Init();
                    "Sales Line"."Document No." := "No.";
                    "Sales Line"."Line No." := line;
                    "Sales Line".Type := "Sales Line".Type::Item;
                    "Sales Line".insert(false);
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
    procedure BuildTempVATEntriesFromSalesOrder()
    var
        SalesLine: Record "Sales Line";
        VATAmount: Decimal;
        lig: Integer;
        Customer: Record Customer;
        vatRate: Decimal;
        VAT_PostingGroup: Record "VAT Posting Setup";
    begin
        TempVATEntry.Reset();
        TempVATEntry.DeleteAll();


        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);

        if SalesLine.FindSet() then
            repeat
                vatRate := SalesLine."VAT %";
                if vatRate = 0 then begin //cas d'exo ou en suspension 
                    Customer.get(SalesLine."Sell-to Customer No.");
                    VAT_PostingGroup.GET(Customer."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group");
                    vatRate := VAT_PostingGroup."VAT %";
                end;

                VATAmount :=
                Round(
                    SalesLine."Line Amount" * vatRate / 100,
                    0.001);




                lig += 1;
                TempVATEntry.Init();
                TempVATEntry."Entry No." := lig;
                TempVATEntry."Posting Date" := SalesHeader."Posting Date";
                TempVATEntry."Document No." := SalesHeader."No.";
                TempVATEntry."VAT Bus. Posting Group" := SalesLine."VAT Bus. Posting Group";
                TempVATEntry."VAT Prod. Posting Group" := SalesLine."VAT Prod. Posting Group";
                //      TempVATEntry. := SalesLine."VAT %";
                TempVATEntry.Base := SalesLine."Line Amount";
                TempVATEntry.Amount := VATAmount;

                TempVATEntry.Insert();

            until SalesLine.Next() = 0;
    end;

    var
        VendorItemCode: Code[25];
        TotalBrut, Totalremise, TotalTva, Timbre, TotalHT, NetaPayer : decimal;
        i, temp_i, J, Line : integer;
        txtMntTLettres: text;
        Companyinf: Record "Company Information";
}
