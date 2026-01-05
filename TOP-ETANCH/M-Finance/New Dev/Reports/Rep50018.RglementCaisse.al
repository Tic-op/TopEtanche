namespace Top.Top;

using Microsoft.Bank.Payment;

report 50025 "Caisse journalière"
{
    ApplicationArea = All;
    Caption = 'Caisse journalière';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = RDLC;
    RDLCLayout = 'RglementCaisse.rdl';

    dataset
    {
        dataitem("Payment Line"; "Payment Line")
        {
            DataItemTableView = sorting("No.", "Line No.") where("Status No." = filter(0 | 10000));


            column(Payment_Class; PC."Type caisse")
            {

            }
            column(company; companyname) { }
            column(Status_No_; "Status Name")
            {

            }
            column(No_; "No.")
            {

            }
            column(External_Document_No_; "External Document No.")
            {

            }
            column(Due_Date; "Due Date")
            {

            }
            column("AccountNo"; "Account No.")
            {

            }
            column(Designation; Designation)
            { }
            column(Date; "Date recette")
            {

            }
            column(Nom; Nom)
            {

            }
            column(Amount; -Amount)
            {

            }
            column(BL_caisse; '')
            {

            }
            column(Facture_Caisse; "Facture Caisse")
            { }
            trigger OnPreDataItem()

            begin

                "Payment Line".SetCurrentKey("Account Type", "Account No.", "Copied To Line", "Payment in Progress");
                "Payment Line".SetRange("Account Type", "Account Type"::Customer);
                "Payment Line".SetCurrentKey("Posting Date", "Document No.");
                "Payment Line".SetRange("Posting Date", "Date recette");
                SetAutoCalcFields("Status Name");

            end;

            trigger OnAfterGetRecord()

            begin
                PC.get("Payment Class");
                if "Date recette" = 0D then
                    Error('La date de la recette doit être mentionnée');
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
                    field("Date recette"; "Date recette")
                    {
                        ApplicationArea = All;

                    }
                    field(Nom; Nom)
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
    trigger OnInitReport()
    begin
        "Date recette" := Today;
    end;


    var
        "Date recette": Date;
        Nom: Text[100];
        PC: Record "Payment Class";


}
