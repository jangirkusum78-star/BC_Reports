report 50109 "GST Purchase Order Report demo"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = "GST Purchase order report";

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = where("Document Type" = const(Order));
            column(CompanyInfo; CompanyInfo.Picture) { }
            column(No_; "No.") { }
            column(Order_Date; "Order Date") { }
            column(Buy_from_Vendor_No_; "Buy-from Vendor No.") { }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name") { }
            column(Buy_from_Address; "Buy-from Address") { }
            column(Buy_from_City; "Buy-from City") { }
            column(Buy_from_Post_Code; "Buy-from Post Code") { }
            column(Posting_Date; "Posting Date") { }
            column(Vendor_Invoice_No_; "Vendor Invoice No.") { }
            column(Document_Date; "Document Date") { }
            column(VAT_Registration_No_; "VAT Registration No.") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(VendorEmail; "VendorEmail") { }
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
            column(Buy_from_Contact_No_; "Buy-from Contact No.") { }
            column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
            column(Location_GST_Reg__No_; "Location GST Reg. No.") { }


            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"),
                                "Document No." = field("No.");
                column(No; "No.") { }
                column(Description; Description) { }
                column(Quantity; Quantity) { }
                column(UOM; "Unit of Measure") { }
                column(Unit_Cost; "Unit Cost") { }
                column(Amount; Amount) { }
                column(Line_Amount; "Line Amount") { }
                column(Line_Discount__; "Line Discount %") { }
                column(HSN_SAC_Code; "HSN/SAC Code") { }
                column(GST_Assessable_Value; "GST Assessable Value") { }
                trigger OnAfterGetRecord()
                begin
                    if "Buy-from Vendor No." <> ' ' then
                        if VendorRec.get("Buy-from Vendor No.") then
                            VendorEmail := VendorRec."E-Mail";
                end;

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
                group(Option)
                {
                    field(Document_no; Document_no)
                    {
                        ApplicationArea = All;
                        TableRelation = "Purchase Header"."No." where("Document Type" = const(Order));
                    }

                }
            }
        }

        // actions
        // {
        //     area(processing)
        //     {
        //         action(LayoutName)
        //         {

        //         }
        //     }
        // }
    }

    rendering
    {
        layout("GST Purchase order report")
        {
            Type = RDLC;
            LayoutFile = 'test_report.rdl';
        }
    }
    // trigger OnPreReport()
    // begin
    //     CompanyInfo.Get();
    // end;

    trigger OnInitReport()
    begin
        if CompanyInfo.get() then
            CompanyInfo.CalcFields(Picture);
    end;

    var
        VendorRec: Record Vendor;
        PaymentTermsRec: Record "Payment Terms";
        CompanyInfo: Record "Company Information";

        VendorEmail: Text[100];
        PaymentTermsDescription: Text[100];
        CompanyEmail: Text[100];
        CINNo: Text[50];
        Document_no: Code[70];
}