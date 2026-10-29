report 50124 "GST Sales Invoice"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = "Gst Invoice";

    dataset
    {

        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            column(CompanyInfo; CompanyInfo.Picture) { }
            column(InvoiceNo_; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
            column(Sell_to_Customer_Name; "Sell-to Customer Name") { }
            column(Sell_to_Address; "Sell-to Address") { }
            column(Sell_to_City; "Sell-to City") { }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code") { }
            column(Posting_Date; "Posting Date") { }
            column(Sell_to_Post_Code; "Sell-to Post Code") { }
            column(Location_GST_Reg__No; "Location GST Reg. No.") { }
            column(External_Document_No; "External Document No.") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Due_Date; "Due Date") { }

            //
            column(Sell_to_E_Mail; "Sell-to E-Mail") { }
            // 
            column(CompanyGSTNo; CompanyInfo."GST Registration No.") { }
            column(CompanyName; CompanyName) { }

            column(CompanyEmail; CompanyInfo."E-Mail") { }
            column(CompanyContact; CompanyInfo."Phone No.") { }
            column(CompanyAddress; CompanyInfo.Address) { }

            column(CompanyAddress2; CompanyInfo."Address 2") { }
            column(CompanyCity; CompanyInfo.City) { }
            column(CompanyPostCode; CompanyInfo."Post Code") { }

            // shipping 
            column(Ship_to_Name; "Ship-to Name") { }
            column(Ship_to_Address; "Ship-to Address") { }
            column(Ship_to_Code; "Ship-to Code") { }
            column(Ship_to_City; "Ship-to City") { }
            //column() { }
            column(Ship_to_GST_Reg__No_; "Ship-to GST Reg. No.") { }
            column(Location_GST_Reg__No_; "Location GST Reg. No.") { }


            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"),
                                "Document No." = field("No.");
                column(No_; "No.") { }
                column(Description_of_Goods; Description) { }
                column(Quantity; Quantity) { }
                column(Rate; "Unit Price") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Amount; Amount) { }
                column(Taxable_Amount; "Line Amount") { }
                column(Line_Discount__; "Line Discount %") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(GST; "GST Group Code") { }
                column(Unit_of_Measure; "Unit of Measure") { }

            }
        }
    }
    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Document_no; Document_no)
                    {
                        ApplicationArea = All;
                        TableRelation = "Sales Header"."No." where("Document Type" = const(Invoice));

                    }
                }
            }
        }

    }

    rendering
    {
        layout("Gst Invoice")
        {
            Type = RDLC;
            LayoutFile = 'myinvoice.rdl';
        }
    }
    trigger OnInitReport()
    begin
        if CompanyInfo.get() then
            CompanyInfo.CalcFields(Picture);
    end;



    var
        CompanyInfo: Record "Company Information";

        VendorRec: Record Vendor;
        VendorEmail: Text[100];
        PaymentTermsDescription: Text[100];
        CompanyEmail: Text[100];
        CINNo: Text[50];
        Document_no: Code[70];
        Dgstledgentry: Record "Detailed GST Ledger Entry";
}