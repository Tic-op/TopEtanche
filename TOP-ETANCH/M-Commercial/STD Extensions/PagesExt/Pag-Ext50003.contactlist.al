namespace TopEtanch.TopEtanch;

using Microsoft.CRM.Contact;

pageextension 50003 "contact list" extends "Contact List"
{
    actions
    {

        addafter("C&ontact")
        {

            /*  action(update)
             {
                 Promoted = true;
                 PromotedCategory = Process;
                 PromotedOnly = true;
                 PromotedIsBig = true;
                 ApplicationArea = all;
                 Visible = true;
                 trigger OnAction()
                 var
                     contact: record contact;
                 begin
                     contact.findfirst;
                     repeat
                         contact.UpdateCustomerNo();

                     until contact.next() = 0;


                 end;
             } */
        }
    }
}
