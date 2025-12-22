namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Foundation.Company;
using Microsoft.Sales.Customer;
using Pharmatec_Ticop.Pharmatec_Ticop;
using Microsoft.Inventory.Item;

report 50012 RetourTopE
{
    ApplicationArea = all ;
    Caption = 'Retour vente enregistrée';
    DefaultLayout = RDLC;
    RDLCLayout = 'Retour-Top-E.rdl';
    dataset
    {
        dataitem(ReturnReceiptHeader;"Return Receipt Header")
        { 
          //  DataItemTableView = where ("Document Type"= const("Sales Document Type"::Quote));
            
            Column(No_;"No."){}
          Column(Posting_Date;"Posting Date"){}
          Column(Document_Date;"Document Date"){}
         // Column(Quote_Valid_Until_Date;"Quote Valid Until Date"){}
         // Column(Promised_Delivery_Date;"Promised Delivery Date"){}
        Column(Order_No_;ReturnReceiptHeader."Return Order No."){}

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

             dataitem("ReturnReceiptLine";"Return Receipt Line")
             {    DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = ReturnReceiptHeader; 
                 UseTemporary = true;
             // DataItemTableView= where (Type=filter(<> '%1'),"Quantity (Base)" = filter(>0));

                column("Code";VendorItemCode) {}
                column(Description;Description){}
                column(Quantité__Base_;"Quantity (Base)"){}
                Column(PU_HT;"Unit Price"){}
                column(Remise_Ligne;"Line Discount %"){}
                Column(PU_TTC;"Unit Price"*(1-"Line Discount %"/100)*(1+"VAT %"/100)){}
                Column(MontantHT;"Quantity (Base)"*"Unit Price"*(1-"Line Discount %"/100)){}
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
             ReturnReceiptTotaux,SIL : record "Return Receipt Line" ;
             CUTextMontant : Codeunit "Montant Toute Lettres";
             SE : codeunit SalesEvents ;
             Cust: record Customer ;
             
             
             begin 

                Cust.get("Sell-to Customer No.");
                "Sell-to E-Mail" := Cust."E-Mail";
                "Sell-to Phone No." := Cust."Phone No.";
            //  SalesishipLines.setrange("Document Type","Document Type");
              ReturnReceiptTotaux.SetRange("Document No.","No.");
             // SalesishipLines.CalcSums("Line Amount","Line Discount Amount","Amount Including VAT",Amount,"VAT Base Amount");
            
             ReturnReceiptTotaux.FindFirst();
             repeat
             Totalremise += ReturnReceiptTotaux."Quantity (Base)"*ReturnReceiptTotaux."Unit Price"*
               ReturnReceiptTotaux."Line Discount %"/100;
             TotalHT+= ReturnReceiptTotaux."Quantity (Base)"*ReturnReceiptTotaux."Unit Price"*
               (1-ReturnReceiptTotaux."Line Discount %"/100);
              TotalBrut+=  ReturnReceiptTotaux."Quantity (Base)"*ReturnReceiptTotaux."Unit Price";
              TotalTva+=  ReturnReceiptTotaux."Quantity (Base)"*ReturnReceiptTotaux."Unit Price"*
               (1-ReturnReceiptTotaux."Line Discount %"/100)*(ReturnReceiptTotaux."VAT %"/100);
              NetaPayer+= ReturnReceiptTotaux."Quantity (Base)"*ReturnReceiptTotaux."Unit Price"*
               (1-ReturnReceiptTotaux."Line Discount %"/100)*(1+ReturnReceiptTotaux."VAT %"/100);


             until ReturnReceiptTotaux.Next()=0 ;
             /*  Totalremise := SalesishipLines."Line Discount Amount";
              TotalHT:=SalesishipLines."VAT Base Amount";
              TotalBrut:=TotalHT-Totalremise;
              TotalTva := SalesishipLines."Amount Including VAT" - TotalHT ;
              //Timbre := "Stamp Amount";
              NetaPayer := SalesishipLines."Amount Including VAT"+timbre ; */
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
                    ReturnReceiptLine.init;

                   ReturnReceiptLine := SIL;
                     ReturnReceiptLine.Insert();

                    line := SIL."Line No.";
                until SIL.next = 0;



                // IF j MOD 30 <> 0 then 
                for temp_i := j MOD 34 to 22 do begin
                    line += 11;
                    ReturnReceiptLine.Init();
                    ReturnReceiptLine."Document No." := "No.";
                   ReturnReceiptLine."Line No." := line;
                     ReturnReceiptLine.Type :=  ReturnReceiptLine.Type::Item;
                     ReturnReceiptLine.insert(false);
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
    "Sell-to Phone No.","Sell-to E-Mail" : Text[100];
  
}
