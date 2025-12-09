table 50015 "Item Attributes Buffer"
{
    Caption = 'Item Attributes Buffer';
    DataClassification = ToBeClassified;
   //TableType = Temporary ;
    
    fields
    { field(1; ID; Integer)
        {
            Caption = 'ID';
           // NotBlank = true;
            TableRelation = "Item Attribute".ID;
            trigger OnValidate()
            var IA : record "item attribute";
            begin 
                IA.get(ID);
                Name := ia.Name;
                Type := IA.Type;
                "Unit of Measure" := IA."Unit of Measure" ;
          //      Modify();

            end;
        }
        field(2; Name; Text[250])
        {
            Caption = 'Name';
         //   NotBlank = true;

           
        }
      
        field(7; Type; Option)
        {
            Caption = 'Type';
            InitValue = Text;
            OptionCaption = 'Option,Text,Integer,Decimal,Date';
            OptionMembers = Option,Text,"Integer",Decimal,Date;

           
        }
        field(8; "Unit of Measure"; Text[30])
        {
            Caption = 'Unit of Measure';

         
        }
    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
}
