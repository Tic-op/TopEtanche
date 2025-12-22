namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Inventory.Item;
using Pharmatec_Ticop.Pharmatec_Ticop;

report 50013 AvoirTop
{ ApplicationArea = all ;
    Caption = 'Avoir_Top';
    DefaultLayout = RDLC;
    RDLCLayout = 'Avoir_Top.rdl';
    dataset
    {
        dataitem(SalesCrMemoHeader;"Sales Cr.Memo Header")
        { 
          //  DataItemTableView = where ("Document Type"= const("Sales Document Type"::Quote));
            
            Column(No_;"No."){}
          Column(Posting_Date;"Posting Date"){}
          Column(Document_Date;"Document Date"){}
         // Column(Quote_Valid_Until_Date;"Quote Valid Until Date"){}
         // Column(Promised_Delivery_Date;"Promised Delivery Date"){}
        Column(Order_No_;SalesCrMemoHeader."Return Order No."){}

          Column (No_Client;"Sell-to Customer No."){}
          Column (Nom_Client;"Sell-to Customer Name"){}
          Column(Address_Client;"Sell-to Address"){}
          Column (MF_Client;"VAT Registration No.") {}
          Column(Tel_Client;"Sell-to Phone No."){}
          Column(Mail_Client;"Sell-to E-Mail"){}
          Column(TotalBrut;TotalBrut){}
          Column(Totalremise;Totalremise){}
          Column(TotalHT;TotalHT){}
          Column(totalTVA;TotalTva){}
          Column(Timbre;Timbre){}
          Column(Net_a_payer;NetaPayer){}
          column(txtMntTLettres; txtMntTLettres) {}
          //Debut Companyinf 

             column(CompanyPicture;Companyinf.Picture){}
                Column(CompanyAddress;Companyinf.Address){}
                Column(CompanyPhone_No_;Companyinf."Phone No."){}
                Column(CompanyFax_No_;Companyinf."Fax No."){}
                column(CompanyVAT_Registration_No_;Companyinf."VAT Registration No."){}
                Column(CompanyE_Mail;Companyinf."E-Mail"){}
                Column(CompanyHome_Page;Companyinf."Home Page"){}



          // End Companyinf

             dataitem("SalesCrMemoLine";"Sales Cr.Memo Line")
             {    DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesCrMemoHeader; 
                 UseTemporary = true;
             // DataItemTableView= where (Type=filter(<> '%1'),"Quantity (Base)" = filter(>0));

                column("Code";VendorItemCode) {}
                column(Description;Description){}
                column(Quantité__Base_;"Quantity (Base)"){}
                Column(PU_HT;"Unit Price"){}
                column(Remise_Ligne;"Line Discount %"){}
                Column(PU_TTC;"Unit Price"*(1-"Line Discount %"/100)*(1+"VAT %"/100)){}
                Column(MontantHT;"Line Amount"){}
                Column(VAT__;"VAT %") {}
                

                 trigger OnAfterGetRecord()
                 var item : record Item ;
                 begin 
                      VendorItemCode := '';
                    if item.get("No.") then 
                    VendorItemCode := item."Vendor Item No.";
                      If type = type::" " then 
                      VendorItemCode := '>>>>>>>>>>'
                 end;


             }
             
             trigger OnAfterGetRecord()
             var 
             SalesCrMemoLines,SIL : record "Sales Cr.Memo Line" ;
             CUTextMontant : Codeunit "Montant Toute Lettres";
             SE : codeunit SalesEvents ;
             
             
             begin 
            //  SalesCrMemoLines.setrange("Document Type","Document Type");
              SalesCrMemoLines.SetRange("Document No.","No.");
              SalesCrMemoLines.CalcSums("Line Amount","Line Discount Amount","Amount Including VAT",Amount,"VAT Base Amount");
              Totalremise := SalesCrMemoLines."Line Discount Amount";
              TotalHT:=SalesCrMemoLines."VAT Base Amount";
              TotalBrut:=TotalHT-Totalremise;
              TotalTva := SalesCrMemoLines."Amount Including VAT" - TotalHT ;
              Timbre := "Stamp Amount";
              NetaPayer := SalesCrMemoLines."Amount Including VAT"+timbre ;
              CUTextMontant."Montant en texte"(txtMntTLettres,NetaPayer);

              /*    "No. Printed" += 1;
                Modify(); */
                //SE.ArchiveDevis("No.");


                  Clear(SIL);
                ;
                SIL.SetRange("Document No.", "No.");
                //SIL.SetRange(Type, SIL.Type::Item); 151225
                SIL.FindSet();
                j := SIL.count;

                repeat
                    "SalesCrMemoLine".init;

                   "SalesCrMemoLine" := SIL;
                     "SalesCrMemoLine".Insert();

                    line := SIL."Line No.";
                until SIL.next = 0;



                // IF j MOD 30 <> 0 then 
                for temp_i := j MOD 34 to 22 do begin
                    line += 11;
                    "SalesCrMemoLine".Init();
                    "SalesCrMemoLine"."Document No." := "No.";
                   "SalesCrMemoLine"."Line No." := line;
                     "SalesCrMemoLine".Type :=  "SalesCrMemoLine".Type::Item;
                     "SalesCrMemoLine".insert(false);
                end;





             end;
             trigger OnPreDataItem() 
             begin 
                Companyinf.get();
                Companyinf.CalcFields(Picture);
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
    VendorItemCode : Code [25];
    TotalBrut,Totalremise,TotalTva,Timbre,TotalHT,NetaPayer :decimal ;
    i , temp_i,J ,Line : integer ;
    txtMntTLettres : text ;
    Companyinf : Record "Company Information" ;
   
}
