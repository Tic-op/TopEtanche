namespace Top.Top;

using Microsoft.Inventory.Item.Attribute;

pageextension 50037 "Item category attributes" extends "Item Category Attributes"
{
    Layout {
       /*  addbefore("Attribute Name")
        {
            field("Type Attribut";Rec."Type Attribut"){
                ApplicationArea= all ;
            }
        } */
       /*   modify("Attribute Name"){
               trigger OnLookup(var Text: Text): Boolean
            var
                Itemselection: record "Item Attribute";
                lookuppage : page 7500 ;
                actionresult :Action ;

            begin
                if rec."Type Attribut" <> '' then
                    Itemselection.SetRange("Type Attribut", rec."Type Attribut");
               // if Page.RunModal(7500, Itemselection)= Action ::LookupOK then 
               lookuppage.SetTableView(Itemselection);
               lookuppage.LookupMode(true);

               actionresult := lookuppage.RunModal();
               if actionresult = Action::LookupOK  then begin 
                lookuppage.GetRecord(Itemselection);
               
               rec.validate("Attribute Name",Itemselection.Name);
              // rec."Attribute Name" := Itemselection.name;
               end;
                exit(true);


            end; */
        } 
    }

