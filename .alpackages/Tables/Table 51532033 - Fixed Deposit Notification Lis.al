table 51532033 "Fixed Deposit Notification Lis"
{

    fields
    {
        field(1; "User Type"; Option)
        {
            OptionCaption = 'User,Member';
            OptionMembers = User,Member;
        }
        field(2; "User Id"; Code[50])
        {
            TableRelation = IF ("User Type" = CONST(User)) "User Setup";
        }
        field(3; "Fixed Deposit Type"; Code[20])
        {

        }
        field(4; "Notification Type"; Option)
        {
            Description = 'Blank,Email,Notification,SMS';
            OptionCaption = ' ,Email,SMS';
            OptionMembers = " ",Email,Notification,SMS;
        }
        field(5; "Notification Period"; Integer)
        {
            Caption = 'Notification Period(Days)';
            Description = 'How many days before maturing';
        }
    }

    keys
    {
        key(Key1; "Fixed Deposit Type", "User Type", "User Id")
        {
        }
    }

    fieldgroups
    {
    }
}

