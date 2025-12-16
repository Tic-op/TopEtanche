namespace Top.Top;

using Microsoft.Sales.History;
using Microsoft.Inventory.Item;
using Microsoft.Foundation.Company;
using Pharmatec_Ticop.Pharmatec_Ticop;

report 50009 FacturePageComplete
{ ApplicationArea = all ;
    Caption = 'Facture';
    DefaultLayout = RDLC;
    RDLCLayout = 'Facture_Top.rdl';
    dataset
    {
        dataitem(SalesInvoiceHeader;"Sales Invoice Header")
        { 
          //  DataItemTableView = where ("Document Type"= const("Sales Document Type"::Quote));
            
            Column(No_;"No."){}
          Column(Posting_Date;"Posting Date"){}
          Column(Document_Date;"Document Date"){}
         // Column(Quote_Valid_Until_Date;"Quote Valid Until Date"){}
         // Column(Promised_Delivery_Date;"Promised Delivery Date"){}
        Column(Order_No_;"Order No."){}

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

             dataitem("Salesinvoiceline";"Sales Invoice Line")
             {    DataItemLink = "Document No." = FIELD("No.");
                DataItemLinkReference = SalesInvoiceHeader; 
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
             SalesinvLines,SIL : record "Sales Invoice Line" ;
             CUTextMontant : Codeunit "Montant Toute Lettres";
             SE : codeunit SalesEvents ;
             
             
             begin 
            //  SalesinvLines.setrange("Document Type","Document Type");
              SalesinvLines.SetRange("Document No.","No.");
              SalesinvLines.CalcSums("Line Amount","Line Discount Amount","Amount Including VAT",Amount,"VAT Base Amount");
              Totalremise := SalesinvLines."Line Discount Amount";
              TotalHT:=SalesinvLines."VAT Base Amount";
              TotalBrut:=TotalHT-Totalremise;
              TotalTva := SalesinvLines."Amount Including VAT" - TotalHT ;
              Timbre := "Stamp Amount";
              NetaPayer := SalesinvLines."Amount Including VAT"+timbre ;
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
                    "Salesinvoiceline".init;

                   "Salesinvoiceline" := SIL;
                     "Salesinvoiceline".Insert();

                    line := SIL."Line No.";
                until SIL.next = 0;



                // IF j MOD 30 <> 0 then 
                for temp_i := j MOD 34 to 22 do begin
                    line += 11;
                    "Salesinvoiceline".Init();
                    "Salesinvoiceline"."Document No." := "No.";
                   "Salesinvoiceline"."Line No." := line;
                     "Salesinvoiceline".Type :=  "Salesinvoiceline".Type::Item;
                     "Salesinvoiceline".insert(false);
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
