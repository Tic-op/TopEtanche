namespace TopEtanch.TopEtanch;


using Microsoft.Inventory.Transfer;
using Microsoft.CRM.Contact;
using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Microsoft.Inventory.Ledger;

report 50050 "Transfer Shipment Report "
{
    ApplicationArea = All;
    Caption = 'Transfert Vente';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'Transfert_shipments.RDL';
    DefaultLayout = RDLC;
    Permissions = tabledata "Item Ledger Entry" = RImd,
                  tabledata "Transfer shipment Header" = Rimd;

    dataset
    {
        dataitem(TransferHeader; "Transfer Shipment Header")
        {
            column(PostingDate; "Posting Date") { }
            column(No; "No.") { }
            Column(reference; reference) { }

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

            column(TypeDocumentTxt; Format(TypeDocument)) { }
            column(Client_No_Selected; ClientNo) { }
            column(Client_Name_Selected; ClientName) { }
            column(ClientCity; ClientCity) { }
            column(ClientAdress; ClientAdress) { }
            column(ClientAdress2; ClientAdress2) { }


            dataitem("Transfer Shipment Line"; "Transfer Shipment Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = TransferHeader;

                column(ILE_Qty; Abs(Quantity)) { }
                column(Item_No_; "Item No.") { }
                column(item_description; item_description) { }
                column(Document_No_; "Document No.") { }
                column(item_vat; item_vat) { }
                column(item_UP; item_UP) { }

                column(Unit_of_Measure; "Unit of Measure Code") { }

                trigger OnAfterGetRecord()
                var
                    item: Record Item;
                begin
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

                if ClientNo <> '' then
                    if Cust.Get(ClientNo) then begin
                        ClientName := Cust.Name;
                        ClientAdress := cust.Address;
                        ClientAdress2 := Cust."Address 2";
                        ClientCity := cust.City;

                    end;
            end;

            trigger OnPostDataItem()
            var
                ILE: record "Item Ledger Entry";
            begin
                ILE.SetRange("Document No.", TransferHeader."No.");
                ILE.SetRange("Document Type", ILE."Document Type"::"Transfer Shipment");//, ILE."Document Type"::"Direct Transfer");

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
                    field(TypeDocument; TypeDocument)
                    {
                        ApplicationArea = All;
                        Caption = 'Type de document';
                    }

                    field(ClientNo; ClientNo)
                    {
                        ApplicationArea = All;
                        Caption = 'N° Client';
                        TableRelation = Customer."No.";
                        Visible = TypeDocument = TypeDocument::"Bon de livraison";
                        ShowMandatory = true;

                    }
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

        TypeDocument: Option "Bon de livraison","Bon de sortie";
        ClientNo, item_vat : Code[20];
        ClientName: Text;
        item_UP: Decimal;
        reference: Text;
}
