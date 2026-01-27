namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Transfer;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;
using Microsoft.Sales.Customer;

report 50049 "Transfer Report"
{
    ApplicationArea = All;
    Caption = 'Transfer Report';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Transfert.RDL';
    DefaultLayout = RDLC;
    Permissions = tabledata "Item Ledger Entry" = RImd,
                  tabledata "Transfer Header" = Rimd;

    dataset
    {
        dataitem(TransferHeader; "Transfer Header")
        {
            column(PostingDate; "Posting Date") { }
            column(No; "Last Shipment No.") { }

            column(TransfertoCode; "Transfer-to Code") { }
            column(TransferfromCode; "Transfer-from Code") { }
            column(TransfertoName; "Transfer-to Name") { }
            column(TransferfromName; "Transfer-from Name") { }

            column(MagasinDestination; MagasinDestination) { }
            column(MagasinSource; Magasinsource) { }
            column(NomDestination; NomDestination) { }
            column(NomSource; NomSource) { }

            column(TransportMethod; "Transport Method") { }

            column(CompanyAdress; CompanyAdress) { }
            column(Companyphone; Companyphone) { }
            column(CompanyVatnum; CompanyVatnum) { }
            column(picture; companyinfo.Picture) { }
            column(EMAIL; companyinfo."E-Mail") { }
            column(item_UP; item_UP) { }

            dataitem("Transfer Line"; "Transfer Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = TransferHeader;
                DataItemTableView = where("Outstanding Qty. (Base)" = const(0));
                UseTemporary = true;


                column(ILE_Qty; Abs(Quantity)) { }
                column(reference; reference) { }
                column(item_description; item_description) { }
                column(Unit_of_Measure; "Unit of Measure Code") { }

                column(Document_No_; "Document No.") { }
                column(item_vat; item_vat) { }

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
                TL: Record "Transfer Line";
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
                    "Transfer Line".init;


                    "Transfer Line" := TL;
                    "Transfer Line".Insert();

                    line := TL."Line No.";

                until TL.next = 0;


                for temp_i := j MOD 22 to 21 do begin
                    line += 11;
                    "Transfer Line".Init();
                    "Transfer Line"."Document No." := TransferHeader."No.";
                    "Transfer Line"."Line No." := line;
                    "Transfer Line".insert(false);
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
                group("Options du rapport")
                {

                }
            }
        }
    }

    var
        item_description: Text;
        companyinfo: Record "Company Information";
        titre: Text;
        Commentaire: Text;

        CompanyAdress: Text;
        Companyphone: Text;
        CompanyVatnum: Text;

        MagasinDestination: Text;
        Magasinsource: Text;
        NomDestination: Text;
        NomSource, ClientCity, ClientAdress2, ClientAdress : Text;

        TypeDocument: Option "Bon de livraison","Bon de sortie";

        ClientNo, item_vat : Code[20];
        ClientName: Text;
        item_UP: Decimal;
        reference: text;
}
