page 50055 "Posted Float Management List"
{
    PageType = List;
    // CardPageId = "Receipt From Bank Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Float Management";
    Editable = false;
    SourceTableView = sorting("Receipt No") order(descending) where(Posted = const(true));
    layout
    {
        area(Content)
        {
            repeater(General)
            {
                Editable = false;
                field("Receipt No"; Rec."Receipt No")
                {
                    ApplicationArea = All;

                }
                field("Transaction Description"; Rec."Transaction Description")
                {
                    ApplicationArea = All;

                }
                field("Associated Bank Account"; Rec."Associated Bank Account")
                {
                    ApplicationArea = All;

                }
                field("Received Amount"; Rec."Received Amount")
                {
                    ApplicationArea = All;

                }
                field("Sacco No"; Rec."Sacco No")
                {
                    ApplicationArea = All;


                }
                field("Sacco Code"; Rec."Sacco Code")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Sacco Name"; Rec."Sacco Name")
                {

                }
                field("Created By"; Rec."Created By")
                {
                    ApplicationArea = All;

                }
                field("Created Date"; Rec."Created Date")
                {
                    ApplicationArea = All;

                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = All;
                    Editable = false;

                }


            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Post Transcation")
            {
                Caption = 'Post Transcation';
                Image = ApplyEntries;
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;
                ToolTip = 'Post Transcation ';
                Visible = false;
                trigger OnAction()
                var
                    FloatManagement: Codeunit "FOSA Management";
                begin
                    if Rec.Posted = true then
                        Error('This Document has been Posted');
                    FloatManagement.Deletejournline();
                    FloatManagement.PostToAccount(Rec);
                    Rec.Posted := true;
                    rec."Posted By" := UserId;
                    if Rec.Modify(true) then
                        Message('Posted Successfully');
                end;
            }
        }
    }


}