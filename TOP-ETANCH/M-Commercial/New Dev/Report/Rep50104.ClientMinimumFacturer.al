namespace TOPETANCH.TOPETANCH;

using Microsoft.Sales.Customer;
using Microsoft.Foundation.Company;
using DefaultPublisher.SalesManagement;

report 50104 "ClientMinimumàFacturer"
{
    Caption = 'Client Minimum à Facturer';
    ApplicationArea = All;
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = 'DetailsFactPlafond.rdl';
    DefaultLayout = RDLC;
    dataset
    {
        dataitem(Customer; Customer)
        {
            column(Name; Name) { }
            column(No_; "No.") { }
            column(Seuil; Seuil) { }
            column(Shipped_Not_Invoiced; "Shipped Not Invoiced") { }
            column(picture; companyInfo.Picture) { }
            column(CompanyName; companyInfo.Name) { }
            column(CompanyAdress; companyinfo.Address) { }
            column(CompanyCity; companyinfo.City) { }
            column(CompanyCodeP; companyinfo."Post Code") { }
            column(CompanyPhone; companyinfo."Phone No.") { }
            column(CompanyPhone2; companyinfo."Phone No. 2") { }
            column(CompanyEmail; companyinfo."E-Mail") { }
            column(CompanyWeb; companyinfo."Home Page") { }



            trigger OnAfterGetRecord()
            begin
                if "Type de facturation" <> "Type de facturation"::"Fact. Plafond"
                then
                    CurrReport.Skip();

                if "Shipped Not Invoiced" = 0 then
                    CurrReport.Skip();

                companyinfo.get();
                companyinfo.CalcFields(Picture);


            end;
        }


    }
    requestpage
    {

        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        companyinfo: Record "Company Information";
}
