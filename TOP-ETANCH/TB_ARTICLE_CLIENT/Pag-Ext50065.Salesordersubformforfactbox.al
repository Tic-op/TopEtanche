namespace Top.Top;

using Microsoft.Sales.Document;

pageextension 50065 Salesordersubformforfactbox extends "Sales Order Subform"
{
    trigger OnAfterGetCurrRecord()
    var
    begin

        CurrPage.Update(false);
    end;
}
