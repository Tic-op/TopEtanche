namespace Ticop.Ticop;

using Microsoft.CRM.Contact;
using Microsoft.CRM.BusinessRelation;
using Microsoft.Sales.Customer;

tableextension 70000 ContactExt extends Contact
{
    fields
    {
        field(50000; "Concurrent"; Boolean)
        {
            Caption = 'Concurrent';
            DataClassification = ToBeClassified;
        }

        /* field(50001; "Customer Posting Group"; Code[20])
        {
            Caption = 'Groupe Contact';
            TableRelation = "Customer Posting Group" where("Visible dans CRM" = const(true));

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin

                if Cust.Get(GetCustomerContact()) then begin
                    Cust."Customer Posting Group" := "Customer Posting Group";
                    Cust.Modify();
                end;



            end; */


        //}

        field(50003; "Nbre Personnes"; Integer)
        {
            Caption = 'Nbre Personnes';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count(Contact where(Type = filter(Person), "Company No." = field("Company No.")));
        }
        /*  modify(Name)
         {

             trigger OnAfterValidate()
             begin
                 GetCustomerPostingGroup();

             end;
         } */
        field(50104; "Approuver Vente"; Boolean)
        {
            trigger OnValidate()   /// By AM 02025
            begin
                if "Approuver Vente" then
                    TestField(Rec."Organizational Level Code");

            end;

        }
        field(50105; "No Organisation"; code[20])
        { }
        modify("Organizational Level Code")  /// By AM 02025
        {
            trigger OnAfterValidate()
            begin

                if "Organizational Level Code" <> xRec."Organizational Level Code" then begin
                    "Approuver Vente" := false;
                    Modify();
                end;

            end;
        }
        modify("Company No.")
        {
            trigger OnAfterValidate()
            begin
                UpdateCustomerNo();
            end;
        }


    }




    procedure GetCustomerContact(): code[25]
    var
        ContBusRel: Record "Contact Business Relation";
    begin


        ContBusRel.SetCurrentKey("Link to Table", "No.");
        // ContBusRel.Setrange("Link to Table", ContBusRel."Link to Table"::Customer ContBusRel."Link to Table"::Vendor);

        ContBusRel.SetFilter("Contact No.", Rec."No.");
        if ContBusRel.FindFirst() then
            EXIT(ContBusRel."No.");

        if "Company No." <> '' then begin
            ContBusRel.SetFilter("Contact No.", rec."Company No.");
            if ContBusRel.FindFirst() then
                EXIT(ContBusRel."No.");

        end;



    end;

    procedure UpdateCustomerNo()
    begin
        "No Organisation" := GetCustomerContact();
        modify(false);

    end;

    /*  procedure GetCustomerPostingGroup()
     var
         ContBusRel: Record "Contact Business Relation";
         Cust: record Customer;
     begin

         //error('Contactez TICOP svp');
         ContBusRel.SetCurrentKey("Link to Table", "No.");

         if Cust.get(GetCustomerContact()) then begin
             rec."Territory Code" := cust."Territory Code";
             Rec."Customer Posting Group" := Cust."Customer Posting Group";
             cust.Modify();
         end;



     end;
  */
    trigger onafterinsert()
    begin

        UpdateCustomerNo();
        //modify();

    end;
}
