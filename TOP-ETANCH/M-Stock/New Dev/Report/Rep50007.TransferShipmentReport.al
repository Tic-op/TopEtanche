namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Transfer;
using Microsoft.CRM.Contact;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

report 50051 "TransferShipReport Complete"
{
    ApplicationArea = All;
    Caption = 'Transfert magasin';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Transfert Shipment.RDL';
    DefaultLayout = RDLC;
    Permissions = tabledata "Item Ledger Entry" = RImd,
                  tabledata "Transfer shipment Header" = Rimd;

    dataset
    {
        dataitem(TransferHeader; "Transfer Shipment Header")
        {
            column(PostingDate; "Posting Date") { }
            column(No; "No.") { }

            column(TransfertoCode; "Transfer-to Code") { }
            column(TransferfromCode; "Transfer-from Code") { }
            column(TransfertoName; "Transfer-to Name") { }
            column(TransferfromName; "Transfer-from Name") { }

            column(MagasinDestination; MagasinDestination) { }
            column(MagasinSource; Magasinsource) { }
            column(NomDestination; NomDestination) { }
            column(NomSource; NomSource) { }

            column(Commentaire; Commentaire) { }
            column(CompanyAdress; CompanyAdress) { }
            column(Companyphone; Companyphone) { }
            column(CompanyVatnum; CompanyVatnum) { }
            column(picture; companyinfo.Picture) { }
            column(EMAIL; companyinfo."E-Mail") { }




            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = TransferHeader;
                UseTemporary = true;

                column(ILE_Qty; Abs(Quantity)) { }
                column(Item_No_; "Item No.") { }
                column(item_description; item_description) { }
                column(Document_No_; "Document No.") { }
                column(item_vat; item_vat) { }
                column(item_UP; item_UP) { }
                column(reference; reference) { }

                column(Unit_of_Measure; "Unit of Measure Code") { }

                trigger OnAfterGetRecord()
                var
                    item: Record Item;
                begin
                    reference := '';
                    item_description := '';
                    item_vat := '';
                    if item.Get("Item No.") then begin
                        item_description := item.Description;
                        item_vat := item."VAT Prod. Posting Group";
                        item_UP := item."Unit Price";
                        reference := item."Vendor Item No.";

                    end;


                end;
            }

            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
                TL: Record "Transfer shipment Line";
                j: Integer;
                line: Integer;
                temp_i: Integer;
            begin
                companyinfo.Get();
                companyinfo.CalcFields(Picture);

                CompanyAdress := companyinfo.Address;
                Companyphone := companyinfo."Phone No.";
                CompanyVatnum := companyinfo."VAT Registration No.";

                Magasinsource := Format("Transfer-from Code");
                MagasinDestination := Format("Transfer-to Code");
                NomSource := "Transfer-from Name";
                NomDestination := "Transfer-to Name";
                Clear(TL);
                ;
                TL.SetRange("Document No.", "No.");
                TL.FindSet();
                j := TL.count;

                repeat
                    "Transfer Shipment Line".init;


                    "Transfer Shipment Line" := TL;
                    "Transfer Shipment Line".Insert();

                    line := TL."Line No.";

                until TL.next = 0;


                for temp_i := j MOD 22 to 21 do begin
                    line += 11;
                    "Transfer Shipment Line".Init();
                    "Transfer Shipment Line"."Document No." := TransferHeader."No.";
                    "Transfer Shipment Line"."Line No." := line;
                    "Transfer Shipment Line".insert(false);
                end;


            end;

            trigger OnPostDataItem()
            var
                ILE: record "Item Ledger Entry";
            begin
                ILE.SetRange("Document No.", TransferHeader."No.");
                ILE.SetRange("Document Type", ILE."Document Type"::"Transfer Shipment", ILE."Document Type"::"Direct Transfer");

                if not ILE.FindFirst() then
                    error('il n''y a rien à imprimer %1 %2 %3', ILE."Order No.", ILE."Document Type", "No.");
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group("Options du rapport")
                {
                }
            }
        }
    }

    var
        item_description: Text;
        companyinfo: Record "Company Information";

        CompanyAdress: Text;
        Companyphone: Text;
        CompanyVatnum, ClientCity, ClientAdress2, ClientAdress : Text;

        MagasinDestination: Text;
        Magasinsource: Text;
        NomDestination: Text;
        NomSource: Text;

        Commentaire: Text;

        item_vat: Code[20];
        reference: text;
        item_UP: Decimal;
}
