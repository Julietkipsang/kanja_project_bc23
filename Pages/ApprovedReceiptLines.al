page 50011 " Approved Receipt lines List"
{
    // version TL2.0

    CardPageID = "Receipting card";
    PageType = List;
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Payment/Receipt Voucher";
    SourceTableView = WHERE(Status = FILTER(Released),
    Posted = CONST(false),
                            "Line type" = CONST(Receipt));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paying Code."; rec."Paying Code.")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt No';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Transaction Description';
                }
                field("Payment Date"; rec."Payment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Date';
                }
                field(Type; rec.Type)
                {
                    ApplicationArea = All;
                }
                field("Payment Mode"; Rec."Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Mode';
                }
                field("Paying Bank"; rec."Paying Bank")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Bank';
                }
                field("Paying/Receiving Bank Name"; Rec."Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Bank Name';
                }
                field("Global Dimension 1 Code"; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;
                }
                // field(Balance; Rec.Balance)
                // {
                //     ApplicationArea = All;
                // }
            }
        }
    }

    actions
    {
    }
}

