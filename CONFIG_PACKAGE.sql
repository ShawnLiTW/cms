CREATE OR REPLACE PACKAGE       "CONFIG_PACKAGE" AS 
/*----------------------------------------------------------------------------------------
-- Package Name - CONFIG_PACKAGE                                  
-- Database - Oracle 11g               
--                                    
-- Created By:  Lisa Situ
-- Created On:  Nov, 2017
-- Last Modified:  
--                                                                                     --
-- Description:                                                                        --
-- This Package contains definition of functions/procedures for configruable settings
-- in CMS app                                                                          --
--   --
--                                                                                     --
--- Modification history :
--                         Nov, 2017 Created
--                         Jan, 2018 Added GET_ITEM_REC TO SUPPORT MIGRATE RESTORATION FLAG 
--                                   FROM ITEM_TYPE TO RESTORATION_TYPE
--                         March 2018 Added Email Config Functions
-----------------------------------------------------------------------------------------*/

    FUNCTION contract_setting_enabled  (
        p_contract_type IN  contracts.contract_type%type
       ,p_setting IN def_contract_setting.attr_code%type
    ) RETURN NUMBER; 

    FUNCTION contract_setting_get  (
        p_contract_type IN contracts.contract_type%type
       ,p_contract_code IN contracts.contract_code%type 
       ,p_setting IN def_contract_setting.attr_code%type
    ) RETURN contract_settings.value%type; 
    FUNCTION wa_mgt_show_wo_list (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN; 

--DETERMINES IF UPLOAD PICTURE/SLIP IS SHOWING FOR AN SUBMITTED ITEM

    FUNCTION item_picture (
        p_restoration_type   IN VARCHAR2,
        p_item_type          IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER;


--DETERMINES IF RESTORATION DATE FIELD IS SHOWING WHEN UPLOADING ITEM PICTURES/SLIPS     

    FUNCTION restoration_date (
        p_contract_type      IN VARCHAR2,
        p_restoration_type   IN VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION wa_status (
        p_status          IN VARCHAR2,
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN;

    FUNCTION wa_action (
        p_action          IN VARCHAR2,
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN;

    FUNCTION contract_page (
        p_page            IN VARCHAR2,
        p_contract_type   IN contracts.contract_type%TYPE
    ) RETURN VARCHAR2; 

--DETERMINES IF CHARGE BACK FIELD IS NEEDED     

    FUNCTION charge_back (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN; 

--DETERMINS IF ESTIMATED VALUE FIELD IS NEEDED

    FUNCTION est_value (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION contract_type_config (
        p_contract_type   IN VARCHAR2,
        p_config          IN VARCHAR2--,
    --P_SETTING OUT NUMBER DEFAULT 0
    ) RETURN BOOLEAN;

    FUNCTION contract_type_config (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN;

    FUNCTION email_button (
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN;

    FUNCTION email_emergency (
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN;

    FUNCTION get_item_rec (
        p_work_order_item_id   IN work_order_tender_items.work_order_item_id%TYPE
    ) RETURN tender_items%rowtype;


    FUNCTION assignment_list (
        p_list_no in number,
        p_page_no in number,
        p_contract_type in varchar2
    )    RETURN NUMBER;


    FUNCTION wo_list (
        p_list_no in number,
        p_page_no in number,
        p_contract_type in varchar2
    )    RETURN NUMBER;

    FUNCTION action_list (
        p_list_no in number,
        p_page_no in number,
        p_action in varchar2,
        p_contract_type in varchar2
    )    RETURN NUMBER;

    function enable_pg145_cntratorlistreg
    return boolean;

  function finalize_button_switch(
          p_page_no in number)
    return boolean;

  FUNCTION pr_work_report_display  RETURN varchar2;

END config_package;
/


CREATE OR REPLACE PACKAGE BODY       "CONFIG_PACKAGE" AS
/*----------------------------------------------------------------------------------------
-- Package Name - CONFIG_PACKAGE                                  
-- Database - Oracle 11g               
--                                    
-- Created By:  Lisa Situ
-- Created On:  Nov, 2017
-- Last Modified:  
--                                                                                     --
-- Description:                                                                        --
-- This Package contains definition of functions/procedures for configruable settings
-- in CMS app                                                                          --
--   --
--                                                                                     --
--- Modification history :
--                         Nov, 2017 Created
--                         Jan, 2018 Added GET_ITEM_REC TO SUPPORT MIGRATE RESTORATION FLAG 
--                                   FROM ITEM_TYPE TO RESTORATION_TYPE
--                         March 2018 Added Email Config Functions
-----------------------------------------------------------------------------------------*/

    FUNCTION wa_mgt_show_wo_list (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN
        AS
    BEGIN
        CASE
            p_contract_type 
      --('CCTV','BOX AND ROD', 'SURVEY ABANDON','GENERAL REPAIRS')
            WHEN def_package.ct_cctv THEN
                RETURN true;
            WHEN def_package.ct_box_and_rod THEN
                RETURN true;
            WHEN def_package.ct_survey_abandon THEN
                RETURN true;
            WHEN def_package.ct_general_repairs THEN
                RETURN true;
            ELSE
                RETURN false;
        END CASE;
    END wa_mgt_show_wo_list;

    FUNCTION wa_status (
        p_status          IN VARCHAR2,
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN AS
        v_item_name       VARCHAR2(100);
        v_contract_type   contracts.contract_type%TYPE;
    BEGIN
        IF
            p_status IS NULL
        THEN
            RETURN false;
        END IF;
        IF
            p_contract_type IS NULL
        THEN
            v_item_name := 'P'
            || p_page_id
            || '_CONTRACT_TYPE';
            v_contract_type := v(v_item_name);
        ELSE
            v_contract_type := p_contract_type;
        END IF;

        CASE
            upper(p_status)
            WHEN 'PERMSTATUS' THEN
                CASE
                    p_page_id
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS')
                    WHEN 200 THEN
                        RETURN FALSE;
                    ELSE
                        RETURN TRUE;
                END CASE;
            WHEN 'OUTSTANDING' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS')
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN true;   
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'OVERDUE' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'GENERAL REPAIRS')
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'WO CLOSED' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'COMPLETED' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS')
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN true;
                    WHEN def_package.ct_perm_rest THEN
                         CASE  p_page_id 
                         WHEN 180 THEN
                           RETURN true;
                         ELSE 
                           RETURN false;
                        END CASE;     
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'COMPLETED PENDING APPROVAL' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD','GENERAL REPAIRS')
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'RESTORATION OUTSTANDING' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_general_repairs THEN
                        RETURN false;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'SEASONAL RESTORATION PENDING' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_general_repairs THEN
                        RETURN false;
                    ELSE
                        RETURN false;
                END CASE;
            ELSE
                RETURN false;
        END CASE;

    END wa_status;

    FUNCTION charge_back (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN
        AS
    BEGIN
        CASE
            p_contract_type
            WHEN def_package.ct_general_repairs THEN
                RETURN true;
            ELSE
                RETURN false;
        END CASE;
    END charge_back;

    FUNCTION est_value (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN
        AS
    BEGIN
        CASE
            p_contract_type
            WHEN def_package.ct_general_repairs THEN
                RETURN true;
            ELSE
                RETURN false;
        END CASE;
    END est_value;

    FUNCTION contract_type_config (
        p_contract_type   IN VARCHAR2,
        p_config          IN VARCHAR2--,
    --P_SETTING OUT NUMBER DEFAULT 0
    ) RETURN BOOLEAN AS
        v_count   NUMBER;
        v_query   VARCHAR2(4000);
    BEGIN
        v_query := 'SELECT count(1)  FROM REF_CONTRACT_TYPE WHERE CONTRACT_TYPE_CD = '
        || p_contract_type
        || ' AND '
        || p_config
        || ' = ''Y''';
        EXECUTE IMMEDIATE v_query INTO
            v_count;
        IF
            v_count > 0
        THEN
    --IF P_SETTING > 0 THEN
            RETURN true;
        ELSE
            RETURN false;
        END IF;
    END contract_type_config;

    FUNCTION wa_action (
        p_action          IN VARCHAR2,
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN AS
        v_item_name       VARCHAR2(100);
        v_contract_type   contracts.contract_type%TYPE;
    BEGIN
        IF
            p_action IS NULL
        THEN
            RETURN false;
        END IF;
        IF
            p_contract_type IS NULL
        THEN
            v_item_name := 'P'
            || p_page_id
            || '_CONTRACT_TYPE';
            v_contract_type := v(v_item_name);
        ELSE
            v_contract_type := p_contract_type;
        END IF;

        CASE
            upper(p_action)
             WHEN 'APPROVAL' THEN
                CASE v_contract_type
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN false;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN false;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN false;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN false;           
                    WHEN def_package.ct_cctv THEN
                        RETURN false;
                    WHEN def_package.ct_survey_abandon THEN
                        RETURN false;
                    ELSE
                        --apex_util.reset_authorizations;
                        RETURN true;
                END CASE;
            WHEN 'PENDING PICTURE' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS','RESTORATION')         
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN false;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN false;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'PENDING TEMP PICTURE' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS','RESTORATION')         
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN false;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN false;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'PENDING PERM PICTURE' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS','RESTORATION')         
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN false;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN false;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'PENDING SLIPS' THEN
                CASE
                    v_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS','RESTORATION','CCTV')         
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;
                    WHEN def_package.ct_temp_rest THEN
                        RETURN true;
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'DISPUTES' THEN
                RETURN true;                                 
            WHEN 'DOCUMENTS' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                 END CASE;
            WHEN 'CHARGE BACK' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'RESPONSE REQUIRED' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'EMAIL' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN true;          
          --WHEN DEF_PACKAGE.CT_TEMP_REST THEN RETURN TRUE;      
                    WHEN def_package.ct_cctv THEN
                        RETURN true;
                    WHEN def_package.ct_survey_abandon THEN
                        RETURN true;
                    ELSE
                        RETURN false;
                END CASE;
            WHEN 'EMAIL_EMERGENCY' THEN
                CASE
                    v_contract_type
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN true;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN true;            
          --WHEN DEF_PACKAGE.CT_FLAT_RATE THEN RETURN TRUE;          
                    WHEN def_package.ct_temp_rest THEN
                        RETURN true;
                    WHEN def_package.ct_cctv THEN
                        RETURN true;  
          --WHEN DEF_PACKAGE.CT_SURVEY_ABANDON THEN RETURN TRUE;  
                    ELSE
                        RETURN false;
                END CASE;
            ELSE
                RETURN false;
        END CASE;

    END wa_action;

    FUNCTION item_picture (
        p_restoration_type   IN VARCHAR2,
        p_item_type          IN VARCHAR2 DEFAULT NULL
    ) RETURN NUMBER AS
        v_count   NUMBER;
    BEGIN
        IF
            p_restoration_type IS NULL
        THEN  -- FOR OLDER VERSION OF CONTRACTS WHICH USE ITEM_TYPE AS RETORATION FLAG
            IF
                p_item_type = def_package.ct_restoration_item_type
            THEN
                RETURN 1;
            ELSE
                RETURN 0;
            END IF;
        ELSE
            SELECT
                COUNT(*)
            INTO
                v_count
            FROM
                ref_restoration_type
            WHERE
                id = p_restoration_type;

            IF
                v_count > 0
            THEN
                RETURN 1;
            ELSE
                RETURN 0;
            END IF;
        END IF;
    END item_picture;

    FUNCTION restoration_date (
        p_contract_type      IN VARCHAR2,
        p_restoration_type   IN VARCHAR2
    ) RETURN BOOLEAN AS
        v_date_required   NUMBER;
    BEGIN
        SELECT
            COUNT(1)
        INTO
            v_date_required
        FROM
            ref_restoration_type
        WHERE
            id = p_restoration_type
            AND   date_required = 'Y';

        CASE
            WHEN p_contract_type = def_package.ct_box_and_rod AND v_date_required > 0 THEN
                RETURN true;
            WHEN p_contract_type = def_package.ct_general_repairs AND v_date_required > 0 THEN
                RETURN true;
            WHEN p_contract_type = def_package.ct_flat_rate AND v_date_required > 0 THEN
                RETURN true;
            ELSE
                RETURN false;
        END CASE;

    END restoration_date;

    FUNCTION contract_type_config (
        p_contract_type IN VARCHAR2
    ) RETURN BOOLEAN
        AS
    BEGIN
        CASE
            p_contract_type
            WHEN def_package.ct_general_repairs THEN
                RETURN true;
            ELSE
                RETURN false;
        END CASE;
    END contract_type_config;

    FUNCTION get_item_rec (
        p_work_order_item_id   IN work_order_tender_items.work_order_item_id%TYPE
    ) RETURN tender_items%rowtype AS
        v_item_rec   tender_items%rowtype;
    BEGIN
        SELECT
            ti.*
        INTO
            v_item_rec
        FROM
            tender_items ti
            INNER JOIN work_order_tender_items woti ON ti.tender_item_id = woti.tender_item_id
        WHERE
            work_order_item_id = p_work_order_item_id;

        RETURN v_item_rec;
    EXCEPTION
        WHEN no_data_found THEN
            RETURN NULL;
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'CONFIG_PACKAGE.GET_ITEM_REC '
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            raise_application_error(-20001,'Error in CONFIG_PACKAGE.GET_ITEM_REC: '
            || sqlcode
            || ' - '
            || sqlerrm);
    END get_item_rec;

    FUNCTION contract_page (
        p_page            IN VARCHAR2,
        p_contract_type   IN contracts.contract_type%TYPE
    ) RETURN VARCHAR2
        AS
    BEGIN
        IF
            p_page IS NULL
        THEN
            RETURN NULL;
        END IF;
        IF
            p_contract_type IS NULL
        THEN
            RETURN NULL;
        END IF;
        CASE
            p_page
            WHEN 'WA' THEN
                CASE
                    p_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS','RESTORATION')   
                    WHEN def_package.ct_temp_rest THEN
                        RETURN 204;
                    WHEN def_package.ct_cctv THEN
                        RETURN 206;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN 236;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN 246;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN 256;
                    WHEN def_package.ct_survey_abandon THEN
                        RETURN 266;
                    ELSE
                        RETURN NULL;
                END CASE;
            WHEN 'WO' THEN
                CASE
                    p_contract_type
          --('CCTV','BOX AND ROD', 'FLAT RATE','GENERAL REPAIRS','RESTORATION')   
                    WHEN def_package.ct_temp_rest THEN
                        RETURN 204;
                    WHEN def_package.ct_cctv THEN
                        RETURN 208;
                    WHEN def_package.ct_box_and_rod THEN
                        RETURN 236;
                    WHEN def_package.ct_flat_rate THEN
                        RETURN 246;
                    WHEN def_package.ct_general_repairs THEN
                        RETURN 256;
                    WHEN def_package.ct_survey_abandon THEN
                        RETURN 266;
                    ELSE
                        RETURN NULL;
                END CASE;
            ELSE
                RETURN NULL;
        END CASE;

    END contract_page;

    FUNCTION email_button (
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN
        AS
    BEGIN
    -- TODO: Implementation required for FUNCTION CONFIG_PACKAGE.EMAIL_BUTTON
        RETURN NULL;
    END email_button;

    FUNCTION email_emergency (
        p_page_id         IN NUMBER,
        p_contract_type   IN VARCHAR2 DEFAULT NULL
    ) RETURN BOOLEAN
        AS
    BEGIN
    -- TODO: Implementation required for FUNCTION CONFIG_PACKAGE.EMAIL_EMERGENCY
        CASE
            p_contract_type
            WHEN def_package.ct_temp_rest THEN
                RETURN true;
            WHEN def_package.ct_cctv THEN
                RETURN true;
            WHEN def_package.ct_box_and_rod THEN
                RETURN true;          
          --WHEN DEF_PACKAGE.CT_FLAT_RATE THEN RETURN 246;                     
            WHEN def_package.ct_general_repairs THEN
                RETURN true;               
          --WHEN DEF_PACKAGE.CT_SURVEY_ABANDON THEN RETURN 266;         
            ELSE
                RETURN false;
        END CASE;
    END email_emergency;


  function assignment_list (
        p_list_no in number,
        p_page_no in number,
        p_contract_type in varchar2
    )    return number as
  begin
    case p_page_no
    when 200 then
        case p_contract_type 
        when 'CCTV' then
            case p_list_no 
            when 1 then return 0;
            when 2 then return 1;
            when 3 then return 0;
            end case;
        when 'BOX AND ROD' then
            case p_list_no 
            when 1 then return 0;
            when 2 then return 1;
            when 3 then return 0;
            end case;
        when 'SURVEY ABANDON' then
            case p_list_no 
            when 1 then return 0;
            when 2 then return 1;
            end case;

       --place holder for GR.
        when 'GENERAL REPAIRS' then
            case p_list_no 
            when 1 then return 1;
            when 2 then return 0;
            end case;
        else 
            null;
        end case;
     when 203 then
        case p_contract_type 
        when 'CCTV' then
            case p_list_no 
            when 1 then return 1;
            when 2 then return 0;
            when 3 then return 1;
            when 4 then return 0;
            end case;
        when 'BOX AND ROD' then
            case p_list_no 
            when 1 then return 1;
            when 2 then return 0;
            when 3 then return 1;
            when 4 then return 0;
            end case;   
        else 
            null;
        end case;   
     else 
        null;
     end case;
  end assignment_list;

  function wo_list (
        p_list_no in number,
        p_page_no in number,
        p_contract_type in varchar2
    )    return number as
  begin
    case p_page_no
    when 236 then
      case p_list_no
        when 1 then return 0;
        when 2 then return 1;       
        else
          null;
      end case;
    when 203 then
        case p_contract_type 
        when 'CCTV' then
            case p_list_no 
            when 1 then return 1;
            when 2 then return 0;            
            end case;
        when 'BOX AND ROD' then
            case p_list_no 
            when 1 then return 1;
            when 2 then return 0;            
            end case;
        when 'GENERAL REPAIRS' then
            case p_list_no 
            when 1 then return 0;
            when 2 then return 1;
            end case;
        else 
            null;
        end case;
     when 206 then
        case p_list_no
        when 1 then return 0;
        when 2 then return 1;       
        else
          null;
        end case;
     else 
        null;
     end case;
  end wo_list;

  FUNCTION contract_setting_enabled  (
        p_contract_type IN  contracts.contract_type%type
       ,p_setting IN def_contract_setting.attr_code%type
    ) RETURN NUMBER AS
  v_c NUMBER;
  BEGIN
    SELECT count(*) into v_c FROM DEF_CONTRACT_SETTING ds
    INNER JOIN DEF_CONTRACT_SETTING_MAPPING dm on ds.id=dm.contract_setting_id
    WHERE dm.contract_type = p_contract_type and ds.attr_code = p_setting;
    IF v_c = 0 THEN
        RETURN 0;
    ELSE
        RETURN 1;
    END IF;
  END contract_setting_enabled;

  FUNCTION contract_setting_get(
        p_contract_type IN contracts.contract_type%type
       ,p_contract_code IN contracts.contract_code%type 
       ,p_setting IN def_contract_setting.attr_code%type
    ) RETURN contract_settings.value%type AS
  v_value contract_settings.value%type;
  BEGIN
   SELECT cs.value into v_value FROM DEF_CONTRACT_SETTING ds
    INNER JOIN DEF_CONTRACT_SETTING_MAPPING dm on ds.id=dm.contract_setting_id
    INNER JOIN CONTRACT_SETTINGS cs on cs.setting_id = ds.id 
    WHERE dm.contract_type = p_contract_type and ds.attr_code = p_setting and cs.contract_code =p_contract_code;

    RETURN v_value;
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;

  END contract_setting_get;


  function enable_pg145_cntratorlistreg
    return boolean
    is
    begin

        return true;

    end enable_pg145_cntratorlistreg;

  function finalize_button_switch(
          p_page_no in number)
          return boolean
    is
    begin

        return false;

    end finalize_button_switch;

  FUNCTION pr_work_report_display  RETURN varchar2 AS
  BEGIN
    -- TODO: Implementation required for FUNCTION CONFIG_PACKAGE.pr_work_report_display
    RETURN 'Y';
  END pr_work_report_display;

  FUNCTION action_list (
        p_list_no in number,
        p_page_no in number,
        p_action in varchar2,
        p_contract_type in varchar2
    )    RETURN NUMBER AS
  BEGIN
    case p_page_no
    when 173 then
      case p_list_no
        when 1 then return 0;
        when 2 then return 1;  
        when 3 then return 0;  
      else
          null;
      end case;
    when 174 then
      case p_list_no
        when 1 then return 0;
        when 2 then return 1;  
        when 3 then return 0;  
      else
          null;
      end case;
     when 623 then
      case p_list_no
        when 1 then return 1;
        when 2 then return 0;  
        --when 3 then return 1;  
      else
          null;
      end case;
    else 
        null;
    end case;

  END action_list;

END config_package;
/
