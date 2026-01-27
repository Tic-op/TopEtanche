namespace Top.Top;


using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
using Microsoft.Sales.History;
using Microsoft.Bank.Payment;
using Microsoft.Sales.Receivables;

report 50018 "Relevé Client "
{
    ApplicationArea = All;
    Caption = 'Engagement Client ';
    UsageCategory = Documents;
    RDLCLayout = 'Relevé Client.rdl';
    DefaultLayout = RDLC;







    dataset
    {
        dataitem(Customer; Customer)
        {
            column(Titre; Titre)
            {
            }
            column(Extrait; Extrait)
            { }
            column(No; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Address; Address)
            {
            }
            column(Contact; Contact)
            {
            }
            column(PhoneNo; "Phone No.")
            {
            }
            column(CreditLimitLCY; "Credit Limit (LCY)")
            {
            }
            column(CreditAmount; "Credit Amount")
            {
            }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(companyName; companyinfo.Name) { }
            column(picture; companyinfo.Picture) { }

            dataitem(Customer_Ledger_Entries; "Cust. Ledger Entry")
            {
                DataItemLink = "Customer No." = FIELD("No.");
                DataItemLinkReference = Customer;
                DataItemTableView = where(Open = const(true));



                column(Posting_Date; "Posting Date") { }
                column(Document_No_; "Document No.") { }
                column(Description; Description + ' ' + "External Document No." + ' ' + bqClient) { }
                column(Original_Amt___LCY_; "Original Amt. (LCY)") { }
                column(Remaining_Amt___LCY_; "Remaining Amt. (LCY)") { }
                column(Customer_Posting_Group; "Customer Posting Group") { }
                trigger OnPreDataItem()
                begin

                    SetAutoCalcFields("Remaining Amt. (LCY)", "Original Amt. (LCY)");

                end;

                trigger OnAfterGetRecord()
                var
                    PL: Record "Payment Line";
                begin
                    PL.SetFilter("No.", "Document No.");
                    PL.SetRange("Account No.", "Customer No.");
                    PL.SetRange("External Document No.", "External Document No.");
                    if PL.FindFirst() then
                        bqClient := PL."Bank Account Name"
                    else
                        bqClient := '';

                end;
            }

            dataitem(Payment_Line; "Payment Line")
            {
                DataItemLinkReference = customer;
                DataItemLink = "Account No." = field("No.");
                CalcFields = Risque;
                DataItemTableView = where("Account Type" = const("Customer"), "Copied To No." = const(''), risque = filter(<> ''));
                column(No_; "No.") { }
                column(Amount; Abs(Amount)) { }
                column(Status_Name; "Status Name") { }
                column(Payment_Class; "Payment Class") { }




                column(Drawee_Reference; "External Document No.") { }
                column(Due_Date; "Due Date") { }
                column(Bank_Account_Name; "Bank Account Name") { }

                column(info; format(risque) + ' ' + "External Document No." + ' ' + FORMAT("Due Date") + ' ' + "Bank Account Name") { }
                trigger OnAfterGetRecord()
                begin
                    if "Due Date" <> 0D then
                        if (Risque = Risque::BQ) AND (Today - "Due Date" > 3) then
                            CurrReport.Skip();
                end;

                trigger OnPreDataItem()
                begin
                    if Extrait then
                        SetFilter("No.", 'NOT FOUND');
                end;
            }
            dataitem(Expedition; "Sales Shipment line")
            {
                DataItemLink = "Bill-to Customer No." = field("No.");
                DataItemLinkReference = Customer;
                DataItemTableView = where("Qty. Shipped Not Invoiced" = filter(<> 0));

                column(Qty__Shipped_Not_Invoiced; "Qty. Shipped Not Invoiced") { }
                column(ExpedUnit_Price; "Unit Price") { }
                column(restantBL; restantExpédition) { }
                trigger OnPreDataItem()
                begin
                    if Extrait then
                        SetFilter("No.", 'NOT FOUND');
                end;

                trigger OnAfterGetRecord()
                begin



                    "restantExpédition" := "Unit Price" * "Qty. Shipped Not Invoiced" * (1 - "Line Discount %" / 100) * (1 + "VAT %" / 100);
                end;



            }
            dataitem(retour; "Return Receipt Line")
            {

                DataItemLink = "Bill-to Customer No." = field("No.");
                DataItemLinkReference = Customer;
                DataItemTableView = where("Return Qty. Rcd. Not Invd." = filter(<> 0));


                column(Return_Qty__Rcd__Not_Invd_; "Return Qty. Rcd. Not Invd.") { }
                column(Retour_Unit_Price; "Unit Price") { }
                column(RestantRetour; RestantRetour) { }
                trigger OnPreDataItem()
                begin
                    if Extrait then
                        SetFilter("No.", 'NOT FOUND');
                end;

                trigger OnAfterGetRecord()
                begin

                    RestantRetour := "Unit Price" * "Return Qty. Rcd. Not Invd.";
                end;






            }


            trigger OnAfterGetRecord()
            begin

                companyinfo.get();
                companyinfo.CalcFields(Picture);
                if Extrait then
                    Titre := 'Extrait client'
                else
                    Titre := 'Engagement client';
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
                    field("Afficher extrait de compte"; Extrait)
                    {
                        ApplicationArea = All;
                    }
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

    var
        companyinfo: Record "Company Information";
        restantExpédition: decimal;
        restantRetour: decimal;
        enprogres: boolean;
        Extrait: boolean;
        Titre, bqClient : Text;

}
