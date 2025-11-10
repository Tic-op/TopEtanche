namespace Top.Top;

using Microsoft.Inventory.Item;

tableextension 50001 ItemExt_Categories extends Item
{
    fields
    {
        field(50000;"Famille Category"; Code[20])
        {
            Caption = 'Famille';
            DataClassification = ToBeClassified;
             TableRelation = "Item Category"."Code" where("Parent Category" = const(''),Level= const(Famille));
             trigger onvalidate()
             begin 
                 if "Famille Category" <> xrec."Famille Category" then 
                 validate("Catégorie Category",'');
                 

             end;
        }
        field(50001; "Catégorie Category"; Code[20])
        {
            Caption = 'Catégorie';
            DataClassification = ToBeClassified;
             TableRelation = "Item Category"."Code" where("Parent Category" = field("Famille Category"),Level= const(Catégorie));

             trigger onvalidate()
             begin 
                 if "Catégorie Category" <> xrec."Catégorie Category" then 
                 validate("Produit Category",'');
                 

             end;
        }
        field(50002; "Produit Category"; Code[20])
        {
            Caption = 'Produit';
            DataClassification = ToBeClassified;
             TableRelation = "Item Category"."Code" where("Parent Category" = field("Catégorie Category"),Level= const(Produit));
                trigger onvalidate()
                
             begin 
                 if "Produit Category" <> xrec."Produit Category" then 
                 validate("Type category",'');
                 

             end;
        }
        field(50003; "Type category"; Code[20])
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
             TableRelation = "Item Category"."Code" where("Parent Category" = field("Produit Category"),Level= const("type"));
            trigger OnValidate() begin 
               validate("Item Category Code", "Type category") ;
               
            end;
        }
        field(50004; "Fiche matériaux"; Code[50])
        {
           TableRelation ="Fiche matériaux".Code;

        }
        Field(50005;"Valeur attribut";text[250])
        {
            
        }
    }
}
