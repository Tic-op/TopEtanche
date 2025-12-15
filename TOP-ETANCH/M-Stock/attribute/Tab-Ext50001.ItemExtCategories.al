namespace Top.Top;

using Microsoft.Inventory.Item;
using Microsoft.Inventory.Item.Attribute;

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
         field(50088; "Matériau category"; Code[20])
        {
            Caption = 'Matériau';
            DataClassification = ToBeClassified;
             TableRelation = "Item Category"."Code" where("Parent Category" = field("Type category"),Level= const(Matériau));
            trigger OnValidate() begin 
               validate("Item Category Code", "Matériau category") ;
               
            end;
        }
        field(50004; "Fiche matériaux"; Code[50])
        {
           TableRelation ="Fiche matériaux".Code;

        }
        Field(50005;"Valeur attribut";text[250])
        {
            
        }
        Field(50106;"Valeur Attribut Numérique";decimal)
        {  DecimalPlaces = 0:2 ;

        }

      field(70000; DynAttr1; Text[250]) { DataClassification = ToBeClassified; }
        field(70001; DynAttr2; Text[250]) { DataClassification = ToBeClassified; }
        field(70002; DynAttr3; Text[250]) { DataClassification = ToBeClassified; }
        field(70003; DynAttr4; Text[250]) { DataClassification = ToBeClassified; }
        field(70004; DynAttr5; Text[250]) { DataClassification = ToBeClassified; }
        field(70005; DynAttr6; Text[250]) { DataClassification = ToBeClassified; }
        field(70006; DynAttr7; Text[250]) { DataClassification = ToBeClassified; }
        field(70007; DynAttr8; Text[250]) { DataClassification = ToBeClassified; }
        field(70008; DynAttr9; Text[250]) { DataClassification = ToBeClassified; }
        field(70009; DynAttr10; Text[250]) { DataClassification = ToBeClassified; }
    }
    keys {
/* 
        Key(Vendorrefkey; "Vendor Item No."){
        }
        key (Descriptionkey;Description){} */
        key(Attributekey;"Valeur Attribut Numérique","Valeur attribut"){}

    }
    Procedure assignattribute(attName :text[250];AttributeValue:text[250])
    var  
       IA : record "Item Attribute";
       IAV : Record "Item Attribute Value";
       IAVM : record "Item Attribute Value Mapping" ;
       tries : Integer ;
       

    
     begin 
        IA.setrange(Name,attName);
        IA.findfirst();
        

        Iav.setrange("Attribute Name",IA.name);
        Iav.setrange("Attribute ID",Ia.id);
        Iav.setrange(Value,AttributeValue);

        If iav.FindFirst() then //IAV Existant
        
         begin
           

         
           IAVM.init();
           Iavm.validate("Table ID",27);
           IAVM.validate("No.","No.");
           IAVM.validate("Item Attribute ID",IAV."Attribute ID");
           IAVM.Validate("Item Attribute Value ID",IAV.ID);
          if not IAVM.insert(true) then begin 
            IAVM.Validate("Item Attribute Value ID",IAV.ID);
       IAVM.modify(true);
          end
             
          end
          
          
          
          
          
       else
       
       
       
       //IAV Non existant 
       
        begin
            iav.reset();
        iav.init();
        iav.validate("Attribute ID",Ia.id);
      //  iav.validate("Attribute Name",ia.Name);
       // Iav.validate(Value,AttributeValue);
        tries := 0 ;
        if not iav.insert(true) then 
        repeat 
        iav.ID+=1;
        tries +=1 ;
        until ((iav.Insert(true))or (tries > 100000));
       if tries <= 100000 then begin 
            Iav.validate(Value,AttributeValue);
           IAV.Modify(true);
           IAVM.init();
           Iavm.validate("Table ID",27);
           IAVM.validate("No.","No.");
           IAVM.validate("Item Attribute ID",IAV."Attribute ID");
           IAVM.Validate("Item Attribute Value ID",IAV.ID);
          if not IAVM.insert(true) then begin 
            IAVM.Validate("Item Attribute Value ID",IAV.ID);
       IAVM.modify(true);
          end


       end
          
          






        end;


      //Commit();
       
       ///  insert the value then assign it in value mapping 


    end;




   
}