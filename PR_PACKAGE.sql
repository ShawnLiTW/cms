CREATE OR REPLACE PACKAGE       "PR_PACKAGE" AS

    --base_depth CONSTANT NUMBER := 250;
    --extended_base_depth CONSTANT NUMBER := 200;

--generate WA-PR for WAs that has temporory restoration items submitted and approved
    FUNCTION pr_generate_wa (
        p_base_group_id        wo_groups.group_id%TYPE,
        p_work_order_item_id   work_order_tender_items.work_order_item_id%TYPE
    ) RETURN wo_groups.group_id%TYPE;

   --generate WA-PR for WAs from scratch
    FUNCTION pr_generate_wa_scratch (
        p_base_group_id wo_groups.group_id%TYPE,
        p_work_order_item_id work_order_tender_items.work_order_item_id%TYPE,
        p_address varchar2, 
        p_description varchar2, 
        p_addrkey number,
        p_permit_number  varchar2
    ) RETURN wo_groups.group_id%TYPE;
    FUNCTION get_wa_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2;

   FUNCTION get_wa_transition_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN NUMBER;

    FUNCTION get_wa_status (
        p_group_id wo_groups.group_id%TYPE,
        p_base_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2;

    function homepage_re_routing(
        p_username      varchar2
    ) return varchar2;

     function pre_chk_wa_pr_permit (
        p_group_id number
    ) return varchar2;

    function get_universal_id return number;

    function is_user_has_role(
        p_username      varchar2,
        p_rolename      varchar2
    ) return boolean;


    PROCEDURE save_wa_pr_profile (
        p_group_id      NUMBER,
        p_group_name    VARCHAR2,
        p_description   VARCHAR2,
        p_permit_number VARCHAR2 DEFAULT NULL,
        p_permit_switch BOOLEAN DEFAULT FALSE        
    );

    PROCEDURE cancel_wa_pr (
        p_group_id NUMBER
    );

    PROCEDURE set_wa_pr_status (
        p_group_id NUMBER,
        p_new_status varchar2,
        p_old_status varchar2 default null
    );

    PROCEDURE reverse_cancelled_wa_pr (
        p_group_id NUMBER
    );

    PROCEDURE include_wa_pr_tender_item (
        p_base_tender_item_id NUMBER
    );

    PROCEDURE revert_wa_pr_tender_item (
        p_base_tender_item_id NUMBER
    );

    PROCEDURE mark_wa_pr_tender_item_tbl;

    PROCEDURE override_polygon_area_manully;

    FUNCTION has_wa_pr_address_refreshed (
        p_wa_pr_number NUMBER,
        p_last_refresh_timestamp VARCHAR2,
        p_last_total_count number
    ) RETURN BOOLEAN;

    FUNCTION has_wa_pr_polygon_refreshed (
        p_wa_pr_number NUMBER,
        p_last_refresh_timestamp VARCHAR2,
        p_last_total_count number
    ) RETURN BOOLEAN;

    FUNCTION get_wa_item_ratio ( 
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2;

      function get_wa_permits (
        p_group_id wo_groups.group_id%type
        ) return varchar2;

     FUNCTION get_labour_name ( p_labour_id insp_labour.labour_id%TYPE) RETURN VARCHAR2;
    FUNCTION get_eqmt_name ( p_eqmt_id insp_eqmt.eqmt_id%TYPE) RETURN VARCHAR2;
    FUNCTION F_DATE(v_date IN VARCHAR2) RETURN NUMBER;
    FUNCTION get_duration (p_start_date date, p_start_time varchar2, p_end_date date, p_end_time varchar2) return varchar2;
    PROCEDURE update_labour_hours;
    PROCEDURE update_eqmt_hours;
    PROCEDURE update_construction_items;
    PROCEDURE update_backfill_items;
    PROCEDURE update_resurfacing_items;

    PROCEDURE update_contingency_items;

    PROCEDURE update_allowance_items;

    procedure get_addr_from_permitnum;

    procedure verify_wa_pr_attr_value;

    procedure set_wa_attr_review ( p_attr_id number, p_retro_cutoff_date varchar2 );
    procedure mark_wa_attr_reviewed ( p_group_id number );


    function is_app_user_internal_empl
    return boolean;

    function ret_app_user_contractor_id
    return number;

    type rec_contract is RECORD (
      contract_code  VARCHAR2(100)
    );

    type rec_contract_table IS TABLE OF rec_contract;



    function get_contract_code_table (
        p_username      varchar2 default v('APP_USER'),
        p_contract_type varchar2 default null
    )
    return rec_contract_table PIPELINED;

   function get_crew_id_table (
        p_username      varchar2 default v('APP_USER')
    )
    return rec_contract_table PIPELINED;    

    procedure setFilterOnIR(
        p_in_region_id      varchar2,
        p_in_report_colname varchar2,
        p_in_report_colvalu varchar2,
        p_in_operator_abbr  varchar2
    );

    procedure removeFilterOnIR(
        p_in_region_id      varchar2
    );


    procedure notifiedSetAttributes(
        p_group_id      varchar2,
        p_notified_date varchar2
    );


    procedure notifyClearedSetAttributes(
        p_group_id      varchar2
    );

    procedure setInspectionFinal_Last(
        p_inspection_id      varchar2,
        p_set_last           varchar2
    );

    procedure clearInspectionLast(
        p_inspection_id      varchar2
    );

    FUNCTION findLastInspID(
        p_inspection_id  in  number
    ) RETURN varchar2;



    FUNCTION isThisInspIDLastInsp(
        p_inspection_id  in  number
    ) RETURN boolean;


    procedure createNewSchedules(
        p_group_id        number,
        p_schedule_date   varchar2,
        p_phase_1_crew_id number,
        p_phase_2_crew_id number,
        p_phase_3_crew_id number,
        p_phase_4_crew_id number,
        p_output_msg      out varchar2
    );


    procedure cancelInspection(
        p_inspection_id      varchar2
    );

   function consolidateNotifiedAddr(
        p_group_id number
    ) return varchar2 RESULT_CACHE;

   FUNCTION is_number (p_string IN VARCHAR2)
       RETURN INT;

       FUNCTION get_wa_cut_types (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2
    RESULT_CACHE;


    procedure setInspectionStatus(
        p_inspection_id number,
        p_status        varchar2
    );

    procedure save_wa_daily_schedules(
        p_collection_name varchar2,
        p_schedule_date  date
    );

/*
    procedure save_wa_daily_schedules_wu(
        p_collection_name varchar2,
        p_schedule_date  date
    );
*/

    procedure save_wa_daily_schedules_1(
        p_collection_name varchar2,
        p_schedule_date  date
    );

    procedure insert_wa_daily_schedules(
        p_group_id number,
        p_schedule_date  date
    );

    procedure insert_insp_wa_daily_schedules(
        p_group_id number,
        p_schedule_date  date,
        p_contract_code varchar2,
        p_inspector_list number
    );

    FUNCTION get_wa_post_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2;

   /* 
    FUNCTION get_wa_post_status (
        p_group_id wo_groups.group_id%type,
        p_notified wo_groups.notified%type,
        p_status wo_groups.status%type,
        p_schedule_id number
    ) RETURN VARCHAR2;
   */

    function getTenderItemDocCount(
        p_tender_item_id varchar2       
    ) return number;


    procedure assignInspectorToSche(
        p_schedule_id  number,
        p_inspector_id number
    );

    FUNCTION inspection_report_overdue (
        p_schedule_date             IN DATE,
        p_afterhours                IN VARCHAR2,
        p_inspector_assigned_date   IN DATE
    ) RETURN VARCHAR2;

    FUNCTION pending_doc (
        p_inspection_id        IN NUMBER,
        p_inspection_status    IN VARCHAR2,
        p_doc_type             IN VARCHAR2 DEFAULT NULL,
        p_work_order_item_id   IN VARCHAR2 DEFAULT NULL,
        p_extra_id             IN NUMBER DEFAULT NULL,
        p_extra_status         IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    FUNCTION item_doc_pending_approval(
        p_inspection_id        IN NUMBER,
        p_inspection_status    IN VARCHAR2,
        p_doc_type             IN VARCHAR2 DEFAULT NULL,
        p_work_order_item_id   IN VARCHAR2 DEFAULT NULL,
        p_extra_id             IN NUMBER DEFAULT NULL,
        p_extra_status         IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    FUNCTION require_doc (
        p_work_order_item_id   IN VARCHAR2,
        p_doc_type IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    procedure setInspIndicators (
        p_inspection_id number,
        p_setvalue      varchar2
    );


    procedure submitInspection (
        p_inspection_id number,
        p_item_paid     varchar2 default null
    );

    --Suppose group_id is in the contract        
    PROCEDURE isScheduleExisting (
        p_schedule_date             IN DATE,
        p_contract_code             IN VARCHAR2 DEFAULT NULL,
        p_group_id                  IN NUMBER DEFAULT NULL,
        p_schedule_id               OUT NUMBER,
        p_wa_included               OUT VARCHAR2);


    PROCEDURE update_extra_labour;
    PROCEDURE update_extra_eqmt;
    PROCEDURE update_extra_materials;
    PROCEDURE update_extra_subcontracted;

    function isMemberBeingUsedByCrew (
        p_in_mem_id   varchar2,
        p_in_mem_type varchar2
    ) return varchar2;

    procedure getHelpInfo;


    function startDate_Cut_Category_WA (
        f_wa_num            number,
        f_cut_category_code varchar2
    ) return timestamp;



    FUNCTION get_wa_remain_cut_types (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2;


    function get_wa_post_status (
        p_group_id wo_groups.group_id%type,
        p_notified wo_groups.notified%type,
        p_status wo_groups.status%type,
        p_schedule_id number
    ) return varchar2; 

      --Used on page 310(Resufacing Region and Submit New Tender Item) and 634(Submit New Tender Item)
      procedure add_addtional_item_to_base (
        p_submission_seq number,
        p_contract_code varchar,
        p_approved varchar2 default null
        );



   procedure set_cut_cat_start_date_status(
        p_inspection_id number default null,
        p_group_id      number default null,
        p_category_code number default null
    );

    function is_old_pr(
        f_contract_code number default null,
        f_group_id      number default null,
        f_inspection_id number default null
    ) return varchar2;


     function get_wa_status_from_cat
 (
  p_status in varchar2,
  p_complete_status_approval varchar2,
  p_cut_types in varchar2,
  p_remaining_cut_types in varchar2,
  p_cut_cat_1_status in varchar2,
  p_cut_cat_2_status in varchar2,
  p_start_date_1 in DATE default null,
  p_start_date_2 in DATE default null,
  p_dispute_1_cnt in number  default null,
  p_upload_1_cnt in number  default null,
  p_verify_1_cnt in number  default null,
  p_dispute_2_cnt in number  default null,
  p_upload_2_cnt in number  default null,
  p_verify_2_cnt in number  default null,
  p_on_hold in varchar2 default null,
  p_cnt_upload in number default null,
  p_cnt_dispute in number default null
)  return varchar2;

function    get_cat_status
(
  p_cut_types           varchar2,
  p_remaining_cut_types varchar2,
  p_cat_start_date      date,
  p_cut_cat_code        varchar2,
  p_dispute_cnt          number default null,
  p_upload_cnt           number default null,
  p_verify_cnt           number default null,
  p_cut_cat_status      varchar2 default null
) return varchar2;

  function get_paired_work_tender_item(
  p_work_order_item_id_from work_order_tender_items.work_order_item_id%type,
  p_item_type_to varchar2 default 'top_base' --extra_depth, top_base
  ) return work_order_tender_items.work_order_item_id%type;

  function get_item_status(
  p_work_order_item_id work_order_tender_items.work_order_item_id%type 
  ) return varchar2;

  function is_inspect_item_allowed(
  p_work_order_item_id work_order_tender_items.work_order_item_id%type ,
  p_action varchar2 
  ) return varchar2;

  function get_alert_msg(
  p_status varchar2,
  p_action varchar2 
  ) return varchar2;

  function get_contract_code(manipulated_contract_name varchar2) return varchar2;
  function get_project_code(manipulated_contract_name varchar2) return varchar2;

  PROCEDURE sync_bte_items(
    p_work_order_item_id NUMBER);

  function get_cut_id(p_group_id IN number) return number;

  function show_add_cuts(p_group_id IN number) return boolean;

  procedure load_insp_crew(
        p_insp_id       number,
        p_crew_id       number default null,
        p_contractor_id number default null
    );

  FUNCTION GET_ACTIVITY_DESC(
        P_ACTCODE IN VARCHAR2,
        P_ACTGROUP IN VARCHAR2 
        ) RETURN VARCHAR2; 

  function isSche_in_GracePeriod(
        p_schedule_date             IN DATE,
        p_afterhours                IN VARCHAR2,
        p_inspector_assigned_date   IN DATE
    ) return varchar2;
    
  function get_app_username return varchar2;
  
  function init_status_value (
        f_contract_type varchar2,
        f_contract_code varchar2 default null
    ) return varchar2;  
END pr_package;
/


CREATE OR REPLACE PACKAGE BODY       "PR_PACKAGE" AS

--generate WA-PR for WAs that has temporory restoration items submitted and approved
    
    FUNCTION pr_create_wa (
        p_base_group_id        wo_groups.group_id%TYPE,
        p_work_order_item_id   work_order_tender_items.work_order_item_id%TYPE,
        p_group_id             wo_groups.group_id%TYPE
    ) RETURN wo_groups.group_id%TYPE AS
        v_wo_groups       wo_groups%rowtype;
        v_wo_groups_seq   NUMBER;
        v_ward            varchar2(20):=null; 
        v_postcode        varchar2(20):=null; 
    BEGIN
        IF
            p_group_id IS NOT NULL
        THEN
            INSERT INTO wo_pr_base_tender_items (
                group_id,
                base_group_id,
                work_order_item_id
            ) VALUES (
                p_group_id,
                p_base_group_id,
                p_work_order_item_id
            );

            COMMIT;
            RETURN p_group_id;
        ELSE
            SELECT
                *
            INTO
                v_wo_groups
            FROM
                wo_groups
            WHERE
                group_id = p_base_group_id;

            SELECT
                wo_groups_seq.NEXTVAL
            INTO
                v_wo_groups_seq
            FROM
                DUAL;

            SELECT
                block, postcode 
            INTO
                v_ward, v_postcode
            FROM
                vm_hansen_addr3
            WHERE addrkey = v_wo_groups.h_addrkey ;

          -- generate wa-pr

            INSERT INTO wo_groups (
                group_id,
                group_name,
                description,
                status,
                h_addrkey,
                h_ward,
                h_postal
            ) VALUES (
                v_wo_groups_seq,
                v_wo_groups.group_name
                || '(PR)',
                NULL,
                'NEW',
                decode(v_wo_groups.h_addrkey, null, 1, v_wo_groups.h_addrkey),
                v_ward,
                v_postcode
            );


          -- link base wa to the newly generate wa-pr 

            INSERT INTO wo_pr_groups_mapping (
                group_id,
                base_group_id
            ) VALUES (
                v_wo_groups_seq,
                p_base_group_id
            );

          -- copy base tender items to newly created wa-pr for user to mark as estimated/included

            INSERT INTO wo_pr_base_tender_items (
                group_id,
                base_group_id,
                work_order_item_id
            ) VALUES (
                v_wo_groups_seq,
                p_base_group_id,
                p_work_order_item_id
            );

            COMMIT;
            RETURN v_wo_groups_seq;
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'PR_CREATE_WA'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END pr_create_wa;

--generate WA-PR for WAs that has temporory restoration items submitted and approved

    FUNCTION pr_generate_wa (
        p_base_group_id        wo_groups.group_id%TYPE,
        p_work_order_item_id   work_order_tender_items.work_order_item_id%TYPE
    ) RETURN wo_groups.group_id%TYPE AS

        CURSOR cur_work_order_tender_items IS SELECT
            work_order_item_id
                                              FROM
            work_order_tender_items woti,
            tender_items ti
                                              WHERE
            woti.tender_item_id = ti.tender_item_id
            AND   woti.group_id = p_base_group_id
            AND   woti.work_order_item_id = p_work_order_item_id
            AND   woti.approved = 'Y'
            AND   ti.restoration_type = 1;

        CURSOR cur_does_item_exsit IS SELECT
            base_tender_item_id
                                      FROM
            wo_pr_base_tender_items wpbti
                                      WHERE
            wpbti.base_group_id = p_base_group_id
            AND   wpbti.work_order_item_id = p_work_order_item_id;

        CURSOR cur_wo_pr_groups_mapping IS SELECT
            group_id
                                           FROM
            wo_pr_groups_mapping
                                           WHERE
            base_group_id = p_base_group_id;

        v_group_id              NUMBER := NULL;
        v_work_order_item_id    NUMBER := NULL;
        v_base_tender_item_id   NUMBER := NULL;
    BEGIN
        OPEN cur_does_item_exsit;
        FETCH cur_does_item_exsit INTO v_base_tender_item_id;
        CLOSE cur_does_item_exsit;
        IF
            v_base_tender_item_id IS NOT NULL
        THEN
          --DBMS_OUTPUT.put_line('Item exsits in WA-PR, no need to create');
            RETURN NULL;
        ELSE
            OPEN cur_work_order_tender_items;
            FETCH cur_work_order_tender_items INTO v_work_order_item_id;
            CLOSE cur_work_order_tender_items;
            IF
                v_work_order_item_id IS NULL
            THEN
             --DBMS_OUTPUT.put_line('Item is either not APPROVED or TEMP, no need to create');
                RETURN NULL;
            END IF;
            OPEN cur_wo_pr_groups_mapping;
            FETCH cur_wo_pr_groups_mapping INTO v_group_id;
            CLOSE cur_wo_pr_groups_mapping;
            IF
                v_group_id IS NULL
            THEN
             --DBMS_OUTPUT.put_line('Will create MAPPING and Item');
                v_group_id := pr_create_wa(p_base_group_id,p_work_order_item_id,NULL);
            ELSE
             --DBMS_OUTPUT.put_line('Will only Append Item');
                v_group_id := pr_create_wa(p_base_group_id,p_work_order_item_id,v_group_id);
            END IF;

            RETURN v_group_id;
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'PR_GENERATE_WA'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END pr_generate_wa;

    FUNCTION pr_generate_wa_scratch (
        p_base_group_id        wo_groups.group_id%TYPE,
        p_work_order_item_id   work_order_tender_items.work_order_item_id%TYPE,
        p_address              VARCHAR2,
        p_description          VARCHAR2,
        p_addrkey              NUMBER,
        p_permit_number        varchar2
    ) RETURN wo_groups.group_id%TYPE AS
        v_wo_groups_seq   NUMBER;
        v_ward varchar2(20):=null;
        v_postcode varchar2(20):=null;
    BEGIN
        SELECT
            wo_groups_seq.NEXTVAL
        INTO
            v_wo_groups_seq
        FROM
            dual;

        SELECT
            block, postcode 
        INTO
            v_ward, v_postcode
        FROM
            vm_hansen_addr3
        WHERE addrkey = p_addrkey ;

        INSERT INTO wo_groups (
            group_id,
            group_name,
            description,
            status,
            h_addrkey,
            h_ward,
            h_postal
        ) VALUES (
            v_wo_groups_seq,
            p_address,
            p_description,
            'NEW',
            decode(p_addrkey, null, 1, p_addrkey),
            v_ward,
            v_postcode
        );

      --Insert Placeholder record

        INSERT INTO wo_pr_groups_mapping (
            group_id,
            base_group_id
        ) VALUES (
            v_wo_groups_seq,
            p_base_group_id
        );

      --Insert Placeholder record

        INSERT INTO wo_pr_base_tender_items (
            group_id,
            base_group_id,
            work_order_item_id,
            included
        ) VALUES (
            v_wo_groups_seq,
            p_base_group_id,
            p_work_order_item_id,
            'N'
        );

        INSERT INTO wo_pr_permit (
            group_id,
            permit_number,
            permit_type,
            verified
        ) VALUES (
            v_wo_groups_seq,
            p_permit_number,
            'RACS',
            ''
        );

        RETURN v_wo_groups_seq;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'PR_GENERATE_WA_SCRATCH'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END pr_generate_wa_scratch;

     FUNCTION get_wa_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2 AS

         CURSOR cur_item_counts(base_group_id wo_groups.group_id%TYPE) IS SELECT
            nvl(SUM(DECODE(wpbti.included,'Y',1,0) ),0),
            nvl(COUNT(woti.group_id),0)
            FROM
            (select * from work_order_tender_items  where group_id = base_group_id) woti 
            --work_order_tender_items woti
            INNER JOIN tender_items ti ON woti.tender_item_id = ti.tender_item_id AND ti.restoration_type = 1
            LEFT OUTER JOIN
            --INNER JOIN 
            (select * from wo_pr_base_tender_items wi where wi.group_id = p_group_id and wi.base_group_id = base_group_id) wpbti ON woti.group_id = wpbti.base_group_id
                                                          AND wpbti.base_group_id = base_group_id
                                                          AND woti.work_order_item_id = wpbti.work_order_item_id
            WHERE woti.group_id = base_group_id;


        v_cnt_included_item     NUMBER;
        v_cnt_total_temp_item   NUMBER;
        v_base_group_id wo_groups.group_id%type;
        v_status wo_groups.status%type;

    BEGIN
        select status into v_status from wo_groups where group_id = p_group_id;
        if v_status like 'CANCEL%' then
            return 'CANCEL';
        end if;
        select base_group_id into v_base_group_id from wo_pr_groups_mapping where group_id = p_group_id;  

        OPEN cur_item_counts (v_base_group_id);


        FETCH cur_item_counts INTO v_cnt_included_item,v_cnt_total_temp_item;
        CLOSE cur_item_counts;

        IF v_cnt_included_item = 0 THEN
            RETURN 'NEW';
        ELSIF v_cnt_included_item = v_cnt_total_temp_item THEN
            RETURN 'ESTIMATED';
        ELSE
            RETURN 'IN PROGRESS';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_STATUS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END;


   -- if return 0, then it is cancelled transition wa-pr
   FUNCTION get_wa_transition_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN NUMBER AS

    V_STATUS VARCHAR2(20) := null; 
    BEGIN
        select STATUS into v_STATUS from WO_GROUPS where group_id = p_group_id;  
        if v_status like 'CANCEL_' then
            return 0;
        end if;
        return 1;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_TRANSITION_STATUS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END;


   /*FUNCTION get_wa_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2 AS

    V_STATUS VARCHAR2(20) := null; 
    BEGIN
        select STATUS into v_STATUS from VW_WA_PR_ALL where group_id = p_group_id;  
        return v_status;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_STATUS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END;*/


    /*FUNCTION get_wa_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2 AS

        CURSOR cur_wo_groups IS 
          SELECT
            status,
            transition_status
          FROM wo_groups
          WHERE group_id = p_group_id;

        v_status  VARCHAR2(10);
        v_transition_status VARCHAR2(10);
    BEGIN
        OPEN cur_wo_groups;
        FETCH cur_wo_groups INTO v_status, v_transition_status;
        CLOSE cur_wo_groups;


        IF v_status='NEW' AND v_transition_status='TW' THEN
            RETURN 'NEW';
        ELSIF (v_status LIKE 'CANCEL%' AND (v_status<>'CANCEL' OR v_status<>'CANCEL0')) OR v_transition_status='TS' THEN
            RETURN 'ESTIMATED';
        ELSE
            RETURN 'IN PROGRESS';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_STATUS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END;*/


------------------------------------------------
-- cancel_WA_PR
------------------------------------------------  

    PROCEDURE cancel_wa_pr (
        p_group_id NUMBER
    )
    AS
    BEGIN
        UPDATE wo_groups
            SET
                status = 'CANCEL'
        WHERE
            group_id = p_group_id AND status='NEW';

        /*UPDATE wo_groups
            SET
                transition_status = 'TS'
        WHERE
            group_id = p_group_id AND status='NEW' and transition_status='TS';*/


    END cancel_wa_pr;

------------------------------------------------
-- update_WA_PR_status
------------------------------------------------  

    PROCEDURE set_wa_pr_status (
        p_group_id NUMBER,
        p_new_status varchar2,
        p_old_status varchar2 default null
    )
    AS
    BEGIN
        if p_new_status = 'DISPUTE' then

            UPDATE wo_groups
              SET status = 'COMPLETED', COMPLETE_STATUS_APPROVED = 'N'
              WHERE group_id = p_group_id;

        elsif p_new_status = 'ONHOLD' then

            UPDATE wo_groups
              SET on_hold = 'Y'
              WHERE group_id = p_group_id;

        elsif p_new_status = 'CLEARONHOLD' then
            UPDATE wo_groups
              SET on_hold = ''
              WHERE group_id = p_group_id;

        elsif p_new_status = 'COMPLETE' and p_old_status is null then

          UPDATE wo_groups
          SET status = 'COMPLETED', COMPLETE_STATUS_APPROVED = 'Y',
          COMPLETE_APPROVAL_DATE = systimestamp
          WHERE group_id =  p_group_id;

        elsif p_new_status = 'COMPLETE' and p_old_status = 'OLD_PR'  then

          UPDATE wo_groups
          SET status = 'COMPLETED', COMPLETE_STATUS_APPROVED = null
          WHERE group_id = p_group_id;

        elsif p_new_status in ('NOACTION','COMPLETEONLY') then

          UPDATE wo_groups
          SET status = 'COMPLETED', COMPLETE_STATUS_APPROVED = null
          WHERE group_id = p_group_id;

        end if;     

        UPDATE wo_groups
          SET COMPLETE_UPDATE_HIST = COMPLETE_UPDATE_HIST || '; ' || v('APP_USER') || ' ' || p_new_status || ':' || p_old_status || ' on ' || systimestamp
          WHERE group_id = p_group_id;

    END set_wa_pr_status;

------------------------------------------------
-- reverse_cancelled_WA_PR
------------------------------------------------  

    PROCEDURE reverse_cancelled_wa_pr (
        p_group_id NUMBER
    )
    AS
    BEGIN
        UPDATE wo_groups
        SET
            status = 'NEW'
        WHERE
            group_id = p_group_id AND status='CANCEL';

        IF pr_package.get_wa_transition_status(p_group_id)=0 THEN
            UPDATE wo_groups
            SET
                transition_status = 'TW', status='NEW'
            WHERE group_id = p_group_id and transition_status='TS';
        END IF;

        /* ORA-04091 error throws for this statement. Mutating table
        UPDATE wo_groups
        SET
            transition_status = 'TW', status='NEW'
        WHERE 
            group_id = p_group_id AND pr_package.get_wa_transition_status(p_group_id)=0 and transition_status='TS';*/

    END reverse_cancelled_wa_pr;

------------------------------------------------
-- save_WA_PR_Attrbute
------------------------------------------------  

    PROCEDURE save_wa_pr_profile (
        p_group_id      NUMBER,
        p_group_name    VARCHAR2,
        p_description   VARCHAR2,
        p_permit_number VARCHAR2 DEFAULT NULL,
        p_permit_switch BOOLEAN DEFAULT FALSE
    )
        AS
    BEGIN
        UPDATE wo_groups
            SET
                group_name = p_group_name,
                description = p_description
        WHERE
            group_id = p_group_id;
        
        IF p_permit_switch THEN
            UPDATE wo_pr_permit SET permit_number=p_permit_number WHERE group_id=p_group_id;
        END IF;
 
    END save_wa_pr_profile;

------------------------------------------------
-- include_WA_PR_TENDER_ITEM
------------------------------------------------    

    PROCEDURE include_wa_pr_tender_item (
        p_base_tender_item_id NUMBER
    )
        AS
    BEGIN
        UPDATE wo_pr_base_tender_items
            SET
                included = 'Y'
        WHERE
            base_tender_item_id = p_base_tender_item_id;

    END include_wa_pr_tender_item;

 ------------------------------------------------
-- revert_WA_PR_TENDER_ITEM
------------------------------------------------     

    PROCEDURE revert_wa_pr_tender_item (
        p_base_tender_item_id NUMBER
    )
        AS
    BEGIN
        UPDATE wo_pr_base_tender_items
            SET
                included = 'N'
        WHERE
            base_tender_item_id = p_base_tender_item_id;

    END revert_wa_pr_tender_item;

------------------------------------------------
-- mark_wa_pr_tender_item_tbl
------------------------------------------------     

    PROCEDURE mark_wa_pr_tender_item_tbl AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        IF
            v_x1 = 'mark'
        THEN
            include_wa_pr_tender_item(p_base_tender_item_id => v_x2);
        ELSIF v_x1 = 'unmark' THEN
            revert_wa_pr_tender_item(p_base_tender_item_id => v_x2);
        END IF;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END mark_wa_pr_tender_item_tbl;

------------------------------------------------
-- override_polygon_area_manully
------------------------------------------------      

    PROCEDURE override_polygon_area_manully AS

        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        UPDATE wo_pr_polygon
            SET
                override_area = v_x3
        WHERE
            group_id = v_x1
            AND   polygon_id = v_x2;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END override_polygon_area_manully;

------------------------------------------------
-- has_wa_pr_address_refreshed
------------------------------------------------        
    function has_wa_pr_address_refreshed (
        p_wa_pr_number           number,
        p_last_refresh_timestamp varchar2,
        p_last_total_count       number
    ) return boolean
    as
        v_retval boolean := false;
        v_cnt    int;
    begin

        if trim(p_last_refresh_timestamp) is null then
            return false;
        end if;

        select count(*) into v_cnt
        from wo_pr_address 
        where group_id = p_wa_pr_number;

        if p_last_total_count <> v_cnt then
            return false;
        end if;

        select count(*) into v_cnt
        from wo_pr_address 
        where group_id = p_wa_pr_number
        and (
            ------------------------------------------------------------------------------------------------------------
            -- Just compare on HH24:MI level, cannot on HH:MI:SS level because there may be clock diffference between
            -- database server and user local machine time which is read from javascript
            -------------------------------------------------------------------------------------------------------------
            TO_DATE( to_char(created_date, 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' ) >= TO_DATE( to_char( TO_DATE( p_last_refresh_timestamp, 'dd/MM/yyyy HH24:MI:SS' ), 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' )
            or 
            TO_DATE( to_char(updated_date, 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' ) >= TO_DATE( to_char( TO_DATE( p_last_refresh_timestamp, 'dd/MM/yyyy HH24:MI:SS' ), 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' )
        );


        if v_cnt = 0 then
            v_retval := true;
        end if;

        return v_retval;


    end has_wa_pr_address_refreshed;

------------------------------------------------
-- has_wa_pr_polygon_refreshed
------------------------------------------------        
    function has_wa_pr_polygon_refreshed (
        p_wa_pr_number           number,
        p_last_refresh_timestamp varchar2,
        p_last_total_count       number
    ) return boolean
    as
        v_retval boolean := false;
        v_cnt  int;
    begin

        if trim(p_last_refresh_timestamp) is null then
            return false;
        end if;

        select count(*) into v_cnt
        from wo_pr_polygon 
        where group_id = p_wa_pr_number;

        if p_last_total_count <> v_cnt then
            return false;
        end if;

        select count(*) into v_cnt
        from wo_pr_polygon
        where group_id = p_wa_pr_number
        and (
            ------------------------------------------------------------------------------------------------------------
            -- Just compare on HH24:MI level, cannot on HH:MI:SS level because there may be clock diffference between
            -- database server and user local machine time which is read from javascript
            -------------------------------------------------------------------------------------------------------------
            TO_DATE( to_char(created_date, 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' ) >= TO_DATE( to_char( TO_DATE( p_last_refresh_timestamp, 'dd/MM/yyyy HH24:MI:SS' ), 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' )
            or 
            TO_DATE( to_char(updated_date, 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' ) >= TO_DATE( to_char( TO_DATE( p_last_refresh_timestamp, 'dd/MM/yyyy HH24:MI:SS' ), 'dd/MM/yyyy HH24:MI'), 'dd/MM/yyyy HH24:MI' )
        );

        if v_cnt = 0 then
            v_retval := true;
        end if;

        return v_retval;
     --   return false;

    end has_wa_pr_polygon_refreshed;


    FUNCTION get_wa_item_ratio ( p_group_id wo_groups.group_id%TYPE) RETURN VARCHAR2 AS
      CURSOR cur_item_ratio IS
        SELECT to_char(nvl(sum(decode(wpbti.included, 'Y', 1, 0)),0)) || ' / ' || to_char(nvl(count(woti.group_id),0))
          FROM wo_pr_groups_mapping wpgm
               inner join work_order_tender_items woti on woti.group_id=wpgm.base_group_id and  wpgm.group_id = p_group_id 
               inner join tender_items ti on woti.tender_item_id=ti.tender_item_id and ti.restoration_type=1 
               left outer join wo_pr_base_tender_items wpbti on wpbti.group_id = wpgm.group_id 
               and woti.work_order_item_id=wpbti.work_order_item_id;

        v_ratio varchar2(20) := NULL;  
    BEGIN
        OPEN cur_item_ratio;
        FETCH cur_item_ratio INTO v_ratio;
        CLOSE cur_item_ratio;
        RETURN v_ratio;
        EXCEPTION
          WHEN others THEN
            apex_error.add_error(p_message => 'GET_WA_ITEM_RATIO'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);    
            RETURN NULL;
    END get_wa_item_ratio;

  function get_wa_status (
        p_group_id wo_groups.group_id%type,
        p_base_group_id wo_groups.group_id%type
    ) return varchar2 as
  v_cnt_included_item number;
  v_cnt_total_temp_item number;
  begin
    select count(*) into v_cnt_included_item from WO_PR_BASE_TENDER_ITEMS where included = 'Y' and group_id = p_group_id;
    select count(*) into v_cnt_total_temp_item from work_order_tender_items woti inner join tender_items ti on woti.tender_item_id = ti.tender_item_id
    where group_id = p_base_group_id and ti.restoration_type = 1;

       IF
            v_cnt_included_item = 0
        THEN
            RETURN 'NEW';
        ELSIF v_cnt_included_item = v_cnt_total_temp_item THEN
            RETURN 'ESTIMATED';
        ELSE
            RETURN 'IN PROGRESS';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_STATUS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;    
  end get_wa_status;

  function get_wa_permits (
        p_group_id wo_groups.group_id%type
        ) return varchar2 as
  v_wa_permits varchar2(200);
  cursor c_wa_permits is
    select permit_number
    from WO_PR_PERMIT
    where group_id=p_group_id and
          permit_number is not null
    order by permit_number;
  begin
    for c in c_wa_permits loop
      v_wa_permits := nvl(v_wa_permits, '') || nvl(c.permit_number, '') || ',';
    end loop;
      v_wa_permits := substr(v_wa_permits, 1, length(v_wa_permits)-1);
    RETURN v_wa_permits;
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_PERMITS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;    
  end get_wa_permits;

  ------------------------------------------------
-- homepage_re_routing
-- Return page alias
------------------------------------------------  
    function homepage_re_routing(
        p_username      varchar2
    ) return varchar2
    as
        retval varchar2(100) := null;
        ret_default_home varchar2(100);
        v_cnt int;

    begin

 /*   
        if is_user_has_role( p_username, 'CMS_CA' ) = true then 
            retval := '1';
        elsif is_user_has_role( p_username, 'CMS_CT' ) = true then 
            retval := '200';
        else
            retval := '1';
        end if;

        return retval;

 */  
        select HOMEPAGE into ret_default_home from def_group_default_home where group_code = 'DEFAULT_HOMEPAGE';

        -- check if user has default group setting

        select count(*) into v_cnt 
        from def_user_default_grp_mapping a
        inner join users
        on a.user_id = users.user_id

        where upper( users.username ) = upper( p_username );

        if v_cnt > 0 then


            begin

                select homepage into retval 
                from def_user_default_grp_mapping a
                inner join def_group_default_home b
                on a.default_group_code = b.group_code
                inner join users
                on a.user_id = users.user_id

                where upper( users.username ) = upper( p_username );

                return retval;

            exception 
                when no_data_found
                  then return ret_default_home;

            end;

        end if;

        -- then check user's all groups, including group hier, with priority setting

        select count(*) into v_cnt 
        from table( DEF_SECURITY_ADMIN.get_user_all_group_codes_table( p_username ) ) b
        inner join users
        on b.user_id = users.user_id

        where upper( users.username ) = upper( p_username );

        if v_cnt = 0 then
           return ret_default_home;
        end if;


        -- seek group code with lowest priority number

        begin

            select homepage into retval
            from
            (
                select 
                    homepage 
                from table( DEF_SECURITY_ADMIN.get_user_all_group_codes_table( p_username ) ) b

                inner join DEF_GROUP_DEFAULT_PRIORITY c
                on b.group_code = c.group_code

                inner join def_group_default_home b
                on b.group_code = b.group_code

                inner join users
                on b.user_id = users.user_id

                where upper( users.username ) = upper( p_username )
                order by default_priority
            ) a
            where rownum < 2;

            return retval;

        exception 
            when no_data_found
              then return ret_default_home;


        end;


    end homepage_re_routing;

------------------------------------------------
-- is_user_has_role
-- role is group
------------------------------------------------     
    function is_user_has_role(
        p_username      varchar2,
        p_rolename      varchar2
    ) return boolean
    as
        cnt int;
    begin

        /*
        select count(*) into cnt 
        from user_roles 
        inner join users 
        on user_roles.user_id = users.user_id
        where users.username = p_username
        and user_roles.role_cd = p_rolename;
        */

        -- first check user's default group
        select count(*) into cnt 
        from def_user_default_grp_mapping a
        inner join def_groups b
        on a.default_group_code = b.code
        inner join users c
        on a.user_id = c.user_id
        where upper(c.username) = upper(p_username)
        and upper(b.name) = upper(p_rolename);

        if cnt > 0 then 
            return true;
        else

            -- check security tables
            select count(*) into cnt             
            from table( DEF_SECURITY_ADMIN.get_user_all_group_codes_table( p_username ) ) a 
            inner join def_groups b
            on a.group_code = b.code
            where upper(b.name) = upper(p_rolename);

            if cnt > 0 then 
                return true;
            else
                return false;
            end if;

        end if;



    end is_user_has_role;

------------------------------------------------
-- get_universal_id
-- return 32-byte number
------------------------------------------------          
    function get_universal_id return number
    is
        retval number;
    begin
        select to_number(sys_guid(),'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX') into retval from dual; 

        return retval;

    end get_universal_id;


  function pre_chk_wa_pr_permit (
        p_group_id number
    ) return varchar2
    as
        v_cnt       int;
        v_verified  varchar2(10);

        -- By default the permit is not verified
        v_retval varchar2(10) := 'N';
    begin

        select count(*) into v_cnt from wo_pr_permit where group_id = p_group_id;

        if v_cnt = 0 then

            insert into wo_pr_permit ( group_id, permit_number, permit_type )
                values ( p_group_id, '', 'RACS' );

        else

            select verified into v_verified from wo_pr_permit where group_id = p_group_id
            -- Assumption only one found
            and rownum < 2; 

            if v_verified = 'Y' then
                v_retval := 'Y';
            end if;

        end if;

        --DEC 27, 2018
    /*
        IF def_security_admin.is_appuser_has_access('CMS', 'cms_permit_bypass', lower(v('APP_USER'))) OR lower(v('APP_USER')) in ('dberg',
        'kmuruga','hrahman','falamgi','wsun','xli5','pfung',
        'asaeed',
        'vramach',
'abrikis',
'ayang2',
'byap',
'salam',
'rthuray',
'bsinnad',
'rdulay',
'acalvo',
'jmaddal',
'scabral',
'efalcet',
'malam3',
'cdilkun',
'vpapa',
'ralam',
'nomrani',
'vpapa',
'aimanov',
'mchen5',
'aribeir',
'amoosai',
'nomrani',
'malam3',
'npareva',
'rmacleo',
'srahman2',
'amohamm7',
'jwang3')
*/

IF def_security_admin.is_appuser_has_access(
            p_app_code  => 'CMS',
            p_priv_name => 'cms_permit_bypass',
            p_username  => lower(v('APP_USER'))
    ) 
    OR lower(v('APP_USER')) in ('dberg',
        'kmuruga','hrahman','falamgi','wsun','xli5','pfung',
        'asaeed',
        'vramach',
'abrikis',
'ayang2',
'byap',
'salam',
'rthuray',
'bsinnad',
'rdulay',
'acalvo',
'jmaddal',
'scabral',
'efalcet',
'malam3',
'cdilkun',
'vpapa',
'ralam',
'nomrani',
'vpapa',
'aimanov',
'mchen5',
'aribeir',
'amoosai',
'nomrani',
'malam3',
'npareva',
'rmacleo',
'srahman2',
'amohamm7',
'jwang3')        
            
THEN  
             return 'Y';
        ELSE 
            return v_retval;
        END IF;


    end pre_chk_wa_pr_permit;

    FUNCTION get_labour_name ( p_labour_id insp_labour.labour_id%TYPE) RETURN VARCHAR2 AS
        v_name varchar2(255) := NULL;  
    BEGIN
        SELECT labour_name INTO v_name FROM DEF_LABOUR WHERE id=p_labour_id;
        RETURN v_name;
        EXCEPTION
          WHEN others THEN
            apex_error.add_error(p_message => 'GET_LABOUR_NAME'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);    
            RETURN NULL;
    END;

    FUNCTION get_eqmt_name ( p_eqmt_id insp_eqmt.eqmt_id%TYPE) RETURN VARCHAR2 AS
        v_name varchar2(255) := NULL;  
    BEGIN
        SELECT eqmt_name INTO v_name FROM DEF_EQMT WHERE id=p_eqmt_id;
        RETURN v_name;
        EXCEPTION
          WHEN others THEN
            apex_error.add_error(p_message => 'GET_EQMT_NAME'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);    
            RETURN NULL;
    END;

    FUNCTION F_DATE(v_date IN VARCHAR2) RETURN NUMBER IS
        v_date1 DATE;
    BEGIN
        select to_date(v_date, 'DD-MON-YYYY') into v_date1 from dual;
            RETURN 1;
        Exception 
            WHEN Others THEN
                RETURN 0;
    END;

    FUNCTION get_duration (p_start_date date, p_start_time varchar2, p_end_date date, p_end_time varchar2) return varchar2 AS
        v_minute number;
    BEGIN
        IF p_start_date IS NOT NULL AND F_DATE(p_start_date)=1 AND
           p_start_time IS NOT NULL AND
           p_end_date IS NOT NULL AND F_DATE(p_end_date)=1 AND
           p_end_time IS NOT NULL THEN
            v_minute := round((to_date(to_char(trunc(p_end_date),'YYYYMMDD') || ' ' ||trim(p_end_time), 'YYYYMMDD HH12:MIAM') - to_date(to_char(trunc(p_start_date),'YYYYMMDD') || ' ' ||trim(p_start_time), 'YYYYMMDD HH12:MIAM') ) * 24 * 60);
            IF v_minute>0 THEN
                RETURN TO_CHAR ( FLOOR (v_minute / 60)) || ':' || TO_CHAR ( MOD (v_minute, 60), 'FM00');
            ELSE
                RETURN NULL;
            END IF;
        ELSE
            RETURN NULL;
        END IF;            
        EXCEPTION
          WHEN others THEN
            apex_error.add_error(p_message => 'GET_DURATION'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);    
            RETURN NULL;
    END;

  PROCEDURE update_labour_hours AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        UPDATE INSP_LABOUR SET HRS=to_number(v_x2) WHERE ID=v_x1;
        --COMMIT;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_labour_hours;

  PROCEDURE update_eqmt_hours AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        UPDATE INSP_EQMT SET HRS=to_number(v_x2) WHERE ID=v_x1;
        --COMMIT;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_eqmt_hours;

 ---------------------------------------------
 -- update_contingency_items
 ---------------------------------------------
    PROCEDURE update_contingency_items AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(3000);
        v_x4       VARCHAR2(3000);
        v_x5       VARCHAR2(30);
        v_retval   VARCHAR2(30);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        v_x5 := apex_application.g_x05;

        UPDATE work_order_tender_items 
            SET quantity=v_x2, approval_comments=v_x3 
        WHERE work_order_item_id =v_x1;


        /*INSERT INTO WO_SB_APPROVAL_HISTORY(ACTION, ACTION_COMMENTS, WORK_ORDER_ITEM_ID, GROUP_ID) 
          VALUES (  v_x5, 
                    'Qty: ' || v_x2 || '; Comments: ' || v_x3, 
                    v_x1, 
                    v_x4
                );      


        COMMIT;*/

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_contingency_items;


  PROCEDURE update_construction_items AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(2000);
        v_x4       VARCHAR2(10);  -- Action: APPROVE or REJECT
        v_retval   VARCHAR2(300);
        v_pre_approval_comments VARCHAR2(2000);
        v_group_id NUMBER;
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
       SELECT group_id, approval_comments INTO v_group_id, v_pre_approval_comments FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_x1;
        UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=v_x2, APPROVAL_COMMENTS=v_x3 WHERE WORK_ORDER_ITEM_ID=v_x1;
        --IF NVL(v_pre_approval_comments, '')<>NVL(v_x3, '') THEN
        /*IF v_x4 in ('APPROVE', 'REJECT') THEN
            INSERT INTO WO_SB_APPROVAL_HISTORY(ACTION, ACTION_COMMENTS, WORK_ORDER_ITEM_ID, GROUP_ID) 
              VALUES (v_x4, v_x3, v_x1, v_group_id);      
        --ELSE
        --    UPDATE WORK_ORDER_TENDER_ITEMS SET APPROVAL_COMMENTS=null WHERE WORK_ORDER_ITEM_ID=v_x1;
        END IF;
        --COMMIT;*/

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_construction_items;

  PROCEDURE update_backfill_items AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(2000);
        v_retval   VARCHAR2(300);
        v_pre_approval_comments VARCHAR2(2000);
        v_group_id NUMBER;
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        SELECT group_id, approval_comments INTO v_group_id, v_pre_approval_comments FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_x1;
        UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=v_x2, APPROVAL_COMMENTS=v_x3 WHERE WORK_ORDER_ITEM_ID=v_x1;
        /*IF NVL(v_pre_approval_comments, '')<>NVL(v_x3, '') THEN
            INSERT INTO WO_SB_APPROVAL_HISTORY(ACTION, ACTION_COMMENTS, WORK_ORDER_ITEM_ID, GROUP_ID) 
              VALUES ('REJECT', v_x3, v_x1, v_group_id);            
        END IF;
        COMMIT;*/

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_backfill_items;

  PROCEDURE update_resurfacing_items AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_x4       VARCHAR2(300);
        v_x5       VARCHAR2(300);
        v_x6       VARCHAR2(2000);
        v_x7       VARCHAR2(10);  -- Action: APPROVE or REJECT or SUBMIT
        v_retval   VARCHAR2(300) := null;
        v_pre_approval_comments VARCHAR2(2000);
        v_group_id NUMBER;
        v_inspection_id number;
        v_inspection_id1 number;
        v_work_order_item_id number;
        v_tender_item_id number;
        v_parent_tender_item_id number;
        v_parent_work_order_item_id number;
        v_length NUMBER;
        v_width NUMBER;
        v_depth NUMBER;
        v_quantity NUMBER;
        v_cnt NUMBER;
        v_add_on_id NUMBER;
        v_standard_depth NUMBER;
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        v_x5 := apex_application.g_x05;
        v_x6 := apex_application.g_x06;
        v_x7 := apex_application.g_x07;

        SELECT group_id, inspection_id, parent_work_order_item_id, approval_comments, tender_item_id INTO v_group_id, v_inspection_id, v_parent_work_order_item_id, v_pre_approval_comments, v_parent_tender_item_id FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_x1;

        IF v_parent_work_order_item_id is not null and v_parent_work_order_item_id<>v_x1 and v_x7='SUBMIT' THEN
            return;
        END IF;

        UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=v_x2, LENGTH=v_x3, WIDTH=v_x4, DEPTH=v_x5, APPROVAL_COMMENTS=v_x6 WHERE WORK_ORDER_ITEM_ID=v_x1;

        --Process extended base and top coat if it is a bottom cut
        IF v_parent_work_order_item_id IS NOT NULL AND v_parent_work_order_item_id=v_x1 THEN
           --Process the extended base item
           SELECT nvl(standard_depth,0) INTO v_standard_depth FROM TENDER_ITEMS WHERE tender_item_id=v_parent_tender_item_id; 
           SELECT MIN(add_on_id) INTO v_add_on_id FROM TENDER_ITEM_ADDONS WHERE tender_item_id=v_parent_tender_item_id and extended_base_flag='Y';
           SELECT count(1) INTO v_cnt FROM WORK_ORDER_TENDER_ITEMS WHERE tender_item_id=v_add_on_id AND PARENT_WORK_ORDER_ITEM_ID=v_x1 AND PARENT_WORK_ORDER_ITEM_ID<>WORK_ORDER_ITEM_ID;

          --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          IF v_cnt=1 THEN
            SELECT work_order_item_id, length, width, depth, quantity INTO v_work_order_item_id, v_length, v_width, v_depth, v_quantity FROM WORK_ORDER_TENDER_ITEMS WHERE tender_item_id=v_add_on_id AND PARENT_WORK_ORDER_ITEM_ID=v_x1 AND PARENT_WORK_ORDER_ITEM_ID<>WORK_ORDER_ITEM_ID;
            IF (NVL(v_quantity,0)<>NVL(to_number(v_x2),0) OR NVL(v_length,0)<>NVL(to_number(v_x3),0) OR NVL(v_width,0)<>NVL(to_number(v_x4),0) OR NVL(v_depth,0)<>NVL(to_number(v_x5),0)) THEN
                IF (to_number(v_x5)-v_standard_depth)>0 THEN
                    --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=least(to_number(v_x5)-base_depth, extended_base_depth), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                    --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5)-v_standard_depth, quantity=round(to_number(v_x3)*to_number(v_x4)*(to_number(v_x5)-v_standard_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                    update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5)-v_standard_depth, quantity=round(to_number(v_x2)*(to_number(v_x5)-v_standard_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                ELSE
                    DELETE FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                END IF;
            END IF;
          ELSE
            --UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_x1;
            IF (to_number(v_x5)-v_standard_depth)>0 THEN
              insert into work_order_tender_items(tender_item_id, quantity,length, width, depth, group_id, inspection_id, parent_work_order_item_id, add_on_to) 
              values (v_add_on_id, round(to_number(v_x2)*(to_number(v_x5)-v_standard_depth)/1000,2), v_x3, v_x4, (to_number(v_x5)-v_standard_depth), v_group_id, v_inspection_id, v_x1, v_x1);
            END IF;
          END IF;

          --process the top coat(if in the same inspection, otherwise don't change if it is approved, show the reminder)
          SELECT max(work_order_item_id), max(inspection_id) INTO v_work_order_item_id, v_inspection_id1 FROM WORK_ORDER_TENDER_ITEMS woti, TENDER_ITEMS ti WHERE woti.tender_item_id=ti.tender_item_id AND ti.supplement is null and ti.cref_tender_item_id=v_parent_tender_item_id AND woti.PARENT_WORK_ORDER_ITEM_ID=v_x1 AND woti.PARENT_WORK_ORDER_ITEM_ID<>woti.WORK_ORDER_ITEM_ID;
          if v_inspection_id1 is not null and v_inspection_id=v_inspection_id1 then
            --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
            update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=to_number(v_x2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          else
            --v_retval := 'Top Coat in another inspection and it is NOT changed!';
            --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
            update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=to_number(v_x2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          end if;
        END IF;

        --APEX_UTIL.PAUSE(5);
        --v_retval := v_x1;
        htp.p(v_retval);
        --APEX_UTIL.PAUSE(5);
        --htp.p(v_x1);        
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_resurfacing_items;

  --Sync top/base/extra after resubmit if changed L/W/D on page 215(popup window of 31025)
  /*PROCEDURE sync_tbe_items(
    p_work_order_item_id NUMBER) AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_x4       VARCHAR2(300);
        v_x5       VARCHAR2(300);
        v_x6       VARCHAR2(2000);
        v_x7       VARCHAR2(10);  -- Action: APPROVE or REJECT or SUBMIT
        v_retval   VARCHAR2(300) := null;
        v_pre_approval_comments VARCHAR2(2000);
        v_group_id NUMBER;
        v_inspection_id number;
        v_inspection_id1 number;
        v_work_order_item_id number;
        v_tender_item_id number;
        v_parent_tender_item_id number;
        v_parent_work_order_item_id number;
        v_length NUMBER;
        v_width NUMBER;
        v_depth NUMBER;
        v_cnt NUMBER;
        v_add_on_id NUMBER;
        v_standard_depth NUMBER;
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        v_x5 := apex_application.g_x05;
        v_x6 := apex_application.g_x06;
        v_x7 := apex_application.g_x07;

        SELECT group_id, inspection_id, parent_work_order_item_id, approval_comments, tender_item_id INTO v_group_id, v_inspection_id, v_parent_work_order_item_id, v_pre_approval_comments, v_parent_tender_item_id FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_x1;

        IF v_parent_work_order_item_id is not null and v_parent_work_order_item_id<>v_x1 THEN
            return;
        END IF;

        UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=v_x2, LENGTH=v_x3, WIDTH=v_x4, DEPTH=v_x5, APPROVAL_COMMENTS=v_x6 WHERE WORK_ORDER_ITEM_ID=v_x1;

        --Process extended base and top coat if it is a bottom cut
        IF v_parent_work_order_item_id IS NOT NULL AND v_parent_work_order_item_id=v_x1 THEN
           --Process the extended base item
           SELECT nvl(standard_depth,0) INTO v_standard_depth FROM TENDER_ITEMS WHERE tender_item_id=v_parent_tender_item_id; 
           SELECT MIN(add_on_id) INTO v_add_on_id FROM TENDER_ITEM_ADDONS WHERE tender_item_id=v_parent_tender_item_id;
           SELECT count(1) INTO v_cnt FROM WORK_ORDER_TENDER_ITEMS WHERE tender_item_id=v_add_on_id AND PARENT_WORK_ORDER_ITEM_ID=v_x1 AND PARENT_WORK_ORDER_ITEM_ID<>WORK_ORDER_ITEM_ID;

          --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          IF v_cnt=1 THEN
            SELECT work_order_item_id, length, width, depth INTO v_work_order_item_id, v_length, v_width, v_depth FROM WORK_ORDER_TENDER_ITEMS WHERE tender_item_id=v_add_on_id AND PARENT_WORK_ORDER_ITEM_ID=v_x1 AND PARENT_WORK_ORDER_ITEM_ID<>WORK_ORDER_ITEM_ID;
            IF  (NVL(v_length,0)<>NVL(to_number(v_x3),0) OR NVL(v_width,0)<>NVL(to_number(v_x4),0) OR NVL(v_depth,0)<>NVL(to_number(v_x5),0)) THEN
                IF (to_number(v_x5)-v_standard_depth)>0 THEN
                    --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=least(to_number(v_x5)-base_depth, extended_base_depth), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                    update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5)-v_standard_depth, quantity=round(to_number(v_x3)*to_number(v_x4)*(to_number(v_x5)-v_standard_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                ELSE
                    DELETE FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                END IF;
            END IF;
          ELSE
            --UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_x1;
            IF (to_number(v_x5)-v_standard_depth)>0 THEN
              insert into work_order_tender_items(tender_item_id, quantity,length, width, depth, group_id, inspection_id, parent_work_order_item_id) 
              values (v_add_on_id, round(to_number(v_x3)*to_number(v_x4)*(to_number(v_x5)-v_standard_depth)/1000,2), v_x3, v_x4, (to_number(v_x5)-v_standard_depth), v_group_id, v_inspection_id, v_x1);
            END IF;
          END IF;

          --process the top coat(if in the same inspection, otherwise don't change if it is approved, show the reminder)
          SELECT max(work_order_item_id), max(inspection_id) INTO v_work_order_item_id, v_inspection_id1 FROM WORK_ORDER_TENDER_ITEMS woti, TENDER_ITEMS ti WHERE woti.tender_item_id=ti.tender_item_id AND ti.supplement is null and ti.cref_tender_item_id=v_parent_tender_item_id AND woti.PARENT_WORK_ORDER_ITEM_ID=v_x1 AND woti.PARENT_WORK_ORDER_ITEM_ID<>woti.WORK_ORDER_ITEM_ID;
          if v_inspection_id1 is not null and v_inspection_id=v_inspection_id1 then
            update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          else
            --v_retval := 'Top Coat in another inspection and it is NOT changed!';
            update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          end if;
        END IF;

        --APEX_UTIL.PAUSE(5);
        --v_retval := v_x1;
        htp.p(v_retval);
        --APEX_UTIL.PAUSE(5);
        --htp.p(v_x1);        
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END sync_tbe_items;*/

/*  PROCEDURE update_resurfacing_items_backup AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_x4       VARCHAR2(300);
        v_x5       VARCHAR2(300);
        v_x6       VARCHAR2(2000);
        v_x7       VARCHAR2(10);  -- Action: APPROVE or REJECT or SUBMIT
        v_retval   VARCHAR2(300) := null;
        v_pre_approval_comments VARCHAR2(2000);
        v_group_id NUMBER;
        v_inspection_id number;
        v_inspection_id1 number;
        v_work_order_item_id number;
        v_tender_item_id number;
        v_parent_work_order_item_id number;
        v_length NUMBER;
        v_width NUMBER;
        v_depth NUMBER;
        v_cnt NUMBER;
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        v_x5 := apex_application.g_x05;
        v_x6 := apex_application.g_x06;
        v_x7 := apex_application.g_x07;
        SELECT group_id, inspection_id, parent_work_order_item_id, approval_comments INTO v_group_id, v_inspection_id, v_parent_work_order_item_id, v_pre_approval_comments FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_x1;
        IF v_parent_work_order_item_id is not null and v_parent_work_order_item_id<>v_x1 THEN
            return;
        END IF;
        UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=v_x2, LENGTH=v_x3, WIDTH=v_x4, DEPTH=v_x5, APPROVAL_COMMENTS=v_x6 WHERE WORK_ORDER_ITEM_ID=v_x1 RETURNING PARENT_WORK_ORDER_ITEM_ID INTO v_parent_work_order_item_id;
        IF v_parent_work_order_item_id is not null and v_parent_work_order_item_id=v_x1 THEN
           --Process the extended base item
           SELECT count(1) INTO v_cnt FROM WORK_ORDER_TENDER_ITEMS woti, TENDER_ITEMS ti WHERE woti.tender_item_id=ti.tender_item_id AND ti.supplement='Y' and ti.cref_tender_item_id=-1 AND woti.PARENT_WORK_ORDER_ITEM_ID=v_x1 AND woti.PARENT_WORK_ORDER_ITEM_ID<>woti.WORK_ORDER_ITEM_ID;
          --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          IF v_cnt>0 THEN
                SELECT woti.work_order_item_id, woti.length, woti.width, woti.depth INTO v_work_order_item_id, v_length, v_width, v_depth FROM WORK_ORDER_TENDER_ITEMS woti, TENDER_ITEMS ti WHERE woti.tender_item_id=ti.tender_item_id AND ti.supplement='Y' and ti.cref_tender_item_id=-1 AND woti.PARENT_WORK_ORDER_ITEM_ID=v_x1 AND woti.PARENT_WORK_ORDER_ITEM_ID<>woti.WORK_ORDER_ITEM_ID;            IF  (NVL(v_length,0)<>NVL(to_number(v_x3),0) OR NVL(v_width,0)<>NVL(to_number(v_x4),0) OR NVL(v_depth,0)<>NVL(to_number(v_x5),0)) THEN
                IF (to_number(v_x5)-base_depth)>0 THEN
                    update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=least(to_number(v_x5)-base_depth, extended_base_depth), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                ELSE
                    DELETE FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
                END IF;
            END IF;
          ELSE
            SELECT ti.tender_item_id INTO v_tender_item_id FROM TENDER_ITEMS ti WHERE ti.supplement='Y' AND CREF_TENDER_ITEM_ID=-1;
            UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_x1;

            IF (to_number(v_x5)-base_depth)>0 THEN
              insert into work_order_tender_items(tender_item_id, quantity,length, width, depth, group_id, inspection_id, parent_work_order_item_id) 
              values (v_tender_item_id, round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2), v_x3, v_x4, least(to_number(v_x5)-base_depth, extended_base_depth), v_group_id, v_inspection_id, v_x1);
            END IF;
          END IF;

          --process the top coat(if in the same inspection, otherwise don't change if it is approved, show the reminder)
          SELECT max(work_order_item_id), max(inspection_id) INTO v_work_order_item_id, v_inspection_id1 FROM WORK_ORDER_TENDER_ITEMS woti, TENDER_ITEMS ti WHERE woti.tender_item_id=ti.tender_item_id AND ti.supplement is null and ti.cref_tender_item_id<>-1 AND woti.PARENT_WORK_ORDER_ITEM_ID=v_x1 AND woti.PARENT_WORK_ORDER_ITEM_ID<>woti.WORK_ORDER_ITEM_ID;
          if v_inspection_id1 is not null and v_inspection_id=v_inspection_id1 then
            update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          else
            --v_retval := 'Top Coat in another inspection and it is NOT changed!';
            update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=null, quantity=round(to_number(v_x3)*to_number(v_x4),2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
          end if;
        END IF;

        --APEX_UTIL.PAUSE(5);
        --v_retval := v_x1;
        htp.p(v_retval);
        --APEX_UTIL.PAUSE(5);
        --htp.p(v_x1);        
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
   END update_resurfacing_items_backup;
 */


   PROCEDURE update_allowance_items AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(4000);
        v_x4       VARCHAR2(200);
        v_retval   VARCHAR2(300);
        v_pre_approval_comments VARCHAR2(2000);
        v_group_id NUMBER;

    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;  
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;

        SELECT group_id, approval_comments INTO v_group_id, v_pre_approval_comments FROM WORK_ORDER_TENDER_ITEMS WHERE WORK_ORDER_ITEM_ID=v_x1;

        UPDATE WORK_ORDER_TENDER_ITEMS SET QUANTITY=v_x2, APPROVAL_COMMENTS=v_x3 WHERE WORK_ORDER_ITEM_ID=v_x1;

        /*INSERT INTO WO_SB_APPROVAL_HISTORY(ACTION, ACTION_COMMENTS, WORK_ORDER_ITEM_ID, GROUP_ID) 
              VALUES (v_x4, v_pre_approval_comments, v_x1, v_group_id);*/      

        v_retval := 'OK';
        htp.p(v_retval);


    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_allowance_items;

------------------------------------------------
-- get_addr_from_permitnum
------------------------------------------------       
    procedure get_addr_from_permitnum
    is

        v_retval   clob;        
        v_group_id    varchar2(200);  
        v_permitnum   varchar2(200);  
        v_tw_address  varchar2(2000); 
        v_ts_address  varchar2(2000);

        v_ret_status  varchar2(2000);

    begin

        v_permitnum := apex_application.g_x01;
        v_group_id  := apex_application.g_x02;

        begin

            select 
                case
                    when instr( location_description, '[' ) > 1
                    then trim( substr(location_description,1, instr( location_description, '[' ) - 1 ) )
                    else location_description
                  end ts_loc
            into v_ts_address
            from ts_permit where permit = v_permitnum;

            v_ts_address := REPLACE(REPLACE(REGEXP_REPLACE(v_ts_address, '([/\|"])', '\\\1', 1, 0), chr(9), '\t'), chr(10), '\n') ;

            v_retval := '[{"address":"' || v_ts_address || '","suggestion":"cancel"}]';
            htp.p(v_retval);           
            return;

        exception
            when no_data_found then

                begin

                    select 
                        case
                            when instr( location_description, '[' ) > 1
                            then trim( substr(location_description,1, instr( location_description, '[' ) - 1 ) )
                            else location_description
                          end tw_loc
                    into v_tw_address
                    from tw_permit where permit = v_permitnum;

               --     v_tw_address := 'NULL';
                    v_tw_address := REPLACE(REPLACE(REGEXP_REPLACE(v_tw_address, '([/\|"])', '\\\1', 1, 0), chr(9), '\t'), chr(10), '\n') ;

                    v_retval := '[{"address":"' || v_tw_address || '","suggestion":"allow_proceed"}]';
                    htp.p(v_retval);           
                    return;

                 exception
                    when no_data_found then

                        v_retval := '[{"address":"NULL","suggestion":"more_info"}]';       
                        htp.p(v_retval);           
                        return;

                end;
        end;       


    exception
        when others then

        v_retval := '[{"address":"NULL","suggestion":"internal_error"}]';       
        htp.p(v_retval);           
        return;

    end get_addr_from_permitnum;

------------------------------------------------
-- verify_wa_pr_attr_value
------------------------------------------------       
    procedure verify_wa_pr_attr_value
    is

        v_retval   clob;        
        v_attr_id     varchar2(200);  
        v_attr_value  varchar2(200); 

        v_val_type    varchar2(200);  
        v_label       varchar2(200);
        v_num_val     NUMBER;

        l_vc_arr1      APEX_APPLICATION_GLOBAL.VC_ARR2;
        l_vc_arr2      APEX_APPLICATION_GLOBAL.VC_ARR2;

    begin

        v_attr_id    := apex_application.g_x01;
        v_attr_value := apex_application.g_x02;

        l_vc_arr1  := APEX_UTIL.STRING_TO_TABLE( v_attr_id );
        l_vc_arr2  := APEX_UTIL.STRING_TO_TABLE( v_attr_value );

        FOR z IN 1..l_vc_arr1.count LOOP

            if l_vc_arr1(z) is not null then

                select value_type, attr_label into v_val_type, v_label from def_pr_attr where id = l_vc_arr1(z);

                if v_val_type = 'NUMERIC' then

                   v_num_val := TO_NUMBER( l_vc_arr2(z) );

                end if;     

            end if;            

        END LOOP;


        v_retval := '[{"response":"OK"}]';

        htp.p(v_retval);

        return;

    exception
        when VALUE_ERROR then
            v_retval := '[{"response":"The value for the attribute [ ' || v_label || ' ] must be numeric value"}]';
            htp.p(v_retval);

            return;

        when others then

            v_retval := '[{"response":"Internal error"}]';
            htp.p(v_retval);

            return;

    end verify_wa_pr_attr_value;


------------------------------------------------
-- set_wa_attr_review
------------------------------------------------       
    procedure set_wa_attr_review( 
        p_attr_id            number,
        p_retro_cutoff_date varchar2
    )
    is      
    begin

        update def_pr_attr 
           set LAST_REVIEW_REQ_DATE   = systimestamp,
               LAST_REVIEW_REQ_BY     = COALESCE(v('APP_USER'), user),
               LAST_REVIEW_RETRO_DATE = p_retro_cutoff_date

        where ID = p_attr_id;

        /*
        if p_retro_cutoff_date is not null then

            update wo_groups 
               set ATTR_REVIEWED = 'N'
            where CONTRACT_CODE is null
            and CREATED_DATE >= TO_DATE( p_retro_cutoff_date, 'dd-MON-yyyy' ) 
            and group_id = 8274;

        else

            update wo_groups 
               set ATTR_REVIEWED = 'N'
            where CONTRACT_CODE is null
            and group_id = 8274;

        end if;
        */

        return;


    end set_wa_attr_review;

------------------------------------------------
-- mark_wa_attr_reviewed
------------------------------------------------       
    procedure mark_wa_attr_reviewed( 
        p_group_id number
    )
    is      
    begin

        -- case for re-reviewed
        update wo_groups 
           set LAST_REVIEWED_DATE   = systimestamp,
               LAST_REVIEWED_BY     = COALESCE(v('APP_USER'), user),
               ATTR_REVIEWED        = 'Y'
        where group_ID = p_group_id and REVIEWED_BY is not null;

        -- case for first reviewed
        update wo_groups 
           set REVIEWED_DATE   = systimestamp,
               REVIEWED_BY     = COALESCE(v('APP_USER'), user),
               LAST_REVIEWED_DATE   = systimestamp,
               LAST_REVIEWED_BY     = COALESCE(v('APP_USER'), user),
               ATTR_REVIEWED   = 'Y'
        where group_ID = p_group_id and REVIEWED_BY is null;

        -- reset re-review flag in attr tbl
        -- Jan. 07, 2019
        -- This need to be removed?? 
        /*
        update wo_pr_attr
           set RETROACTIVE   = NULL,
               RETROACTIVE_DATE = NULL
        where group_ID = p_group_id;
         */

        return;


    end mark_wa_attr_reviewed;

------------------------------------------------
-- is_app_user_contractor
------------------------------------------------      
    function is_app_user_internal_empl
    return boolean
    is
        v_cnt int;
        v_ret boolean := false;
    begin

        select count(*) into v_cnt from users where username = v('APP_USER') and user_type = 'I' and upper(ldap_ou) = 'STAFF';

        if v_cnt > 0 then 
            v_ret := true;
        else
            v_ret := false;          
        end if;

     --   return v_ret;
        return true;

    end is_app_user_internal_empl;

------------------------------------------------
-- ret_app_user_contractor_id
------------------------------------------------      
    function ret_app_user_contractor_id
    return number
    is
        v_id number := null;
    begin

        select CONTRACTOR_ID into v_id from users where upper(username) = upper( v('APP_USER') )
        and (

            upper(user_type) = 'E'
            or
            upper(ldap_ou) = 'NON-STAFF'
            or
            upper(role_cd) = 'CT'

        );


      --  return v_id;
        return 25;

    exception
        when others then
          --  return null;
            return 25;

    end ret_app_user_contractor_id;

------------------------------------------------
-- get_contract_code_table
------------------------------------------------        
    function get_contract_code_table (
        p_username      varchar2 default v('APP_USER'),
        p_contract_type varchar2 default null
    )
    return rec_contract_table PIPELINED
    is
        row_rec     rec_contract;
    begin

        for rec in (

            select a.contract_code
            from user_contracts a

            inner join users b
            on a.user_id = b.user_id

            inner join contracts c
            on a.contract_code = c.contract_code

            where upper( b.username ) = upper( p_username )
               and 
               (
                   p_contract_type is null
                   or
                   upper( c.contract_type ) = upper( p_contract_type )
               )
               and c.status = 'A'

            order by contract_code


        ) loop

                    SELECT rec.contract_code
                        INTO row_rec.contract_code FROM DUAL;

                    PIPE ROW (row_rec);

        end loop;

        return;

    end get_contract_code_table;

------------------------------------------------
-- get contractor's crew_id
------------------------------------------------        
    function get_crew_id_table (
        p_username      varchar2 default v('APP_USER')
    )
    return rec_contract_table PIPELINED
    is
        row_rec     rec_contract;
    begin

        for rec in (
            select dc.id
            from def_crew dc
            inner join users u
            on dc.contractor_id = u.contractor_id
            where upper( u.username ) = upper( p_username )
            and dc.status = 'A'
            order by dc.crew_name
        ) loop

                    SELECT rec.id
                        INTO row_rec.contract_code FROM DUAL;

                    PIPE ROW (row_rec);

        end loop;

        return;

    end get_crew_id_table;

-------------------------------------------------------------
-- function setFilterOnIR
-------------------------------------------------------------  
 procedure setFilterOnIR(
        p_in_region_id      varchar2,
        p_in_report_colname varchar2,
        p_in_report_colvalu varchar2,
        p_in_operator_abbr  varchar2
    )
    is    
        l_region_id apex_application_page_regions.region_id%type;
    begin

        select region_id into l_region_id
        from apex_application_page_regions
        where application_id = v('APP_ID')
        and page_id = v('APP_PAGE_ID')
        and upper(static_id) = upper( p_in_region_id );


        if p_in_report_colvalu is null then

            APEX_IR.ADD_FILTER(
                p_page_id       => v('APP_PAGE_ID'),
                p_region_id     => l_region_id,
                p_report_column => upper( p_in_report_colname ),
                p_filter_value  => NULL, 
                p_operator_abbr => 'N',
                p_report_id     => NULL);

        else

            APEX_IR.ADD_FILTER(
                p_page_id       => v('APP_PAGE_ID'),
                p_region_id     => l_region_id,
                p_report_column => upper( p_in_report_colname ),
                p_filter_value  => p_in_report_colvalu, 
                p_operator_abbr => upper( p_in_operator_abbr ),
                p_report_id     => NULL);

        end if;


    end setFilterOnIR;


-------------------------------------------------------------
-- function removeFilterOnIR
-------------------------------------------------------------  
 procedure removeFilterOnIR(
        p_in_region_id      varchar2
    )
    is    
        l_region_id apex_application_page_regions.region_id%type;
    begin

        select region_id into l_region_id
        from apex_application_page_regions
        where application_id = v('APP_ID')
        and page_id = v('APP_PAGE_ID')
        and upper(static_id) = upper( p_in_region_id );

       apex_ir.reset_report(
            p_page_id => v('APP_PAGE_ID')
          , p_region_id => l_region_id
          , p_report_id => NULL
        );

    end removeFilterOnIR;

------------------------------------------------
-- insp_general_info_sync_from
-- 
------------------------------------------------  
/*    FUNCTION insp_general_info_sync_from(
        p_wa_schedule_id  in  number,
        p_exist_ind in out varchar2,
        p_start_date in out date,
        p_start_time in out varchar2,
        p_end_date in out date,
        p_end_time in out varchar2,
        p_temperature in out varchar2,
        p_weather in out varchar2
    ) RETURN varchar2 as
  cursor c_con1 is
    select schedule_id, schedule_date, inspector, afterhours
      from wa_daily_schedules
      where id=p_wa_schedule_id;

  cursor c_con2(p_schedule_id number, p_inspector number, p_afterhours varchar2) is
    select min(inspection_id) inspection_id
      from wa_daily_schedules
      where schedule_id=p_schedule_id and
            inspector=p_inspector and
            afterhours=p_afterhours and
            inspection_id is not null;

  cursor c_insp(p_inspection_id number) is
    select * 
    from insp_inspections
    where inspection_id=p_inspection_id;

begin


  for c1 in c_con1 loop
    for c2 in c_con2(c1.schedule_id, c1.inspector, c1.afterhours) loop
      for c in c_insp(c2.inspection_id) loop
        P_EXIST_IND := 'Y';
        P_START_DATE := c.start_date;
        P_START_TIME := c.start_time;
        P_END_DATE := c.end_date;
        P_END_TIME := c.end_time;
        P_TEMPERATURE := c.temperature;
        P_WEATHER := c.WEATHER;
      end loop;
    end loop;
    IF P_EXIST_IND='N' AND P_START_DATE IS NULL THEN
      P_START_DATE := c1.schedule_date; 
    END IF;
  end loop;
  return null;

end insp_general_info_sync_from;
  */

------------------------------------------------
-- insp_general_info_sync_to
-- 
------------------------------------------------  
/*    FUNCTION insp_general_info_sync_to(
        p_inspection_id  in  number,
        p_start_date in date,
        p_start_time in varchar2,
        p_end_date in date,
        p_end_time in varchar2,
        p_temperature in varchar2,
        p_weather in varchar2
    ) RETURN varchar2 as
  cursor c_con1 is
    select schedule_id,inspector,afterhours
      from wa_daily_schedules
      where inspection_id=p_inspection_id;

  cursor c_con2(p_schedule_id number, p_inspector number, p_afterhours varchar2) is
    select inspection_id
      from wa_daily_schedules
      where schedule_id=p_schedule_id and
            inspector=p_inspector and
            inspection_id is not null and
            inspection_id<>p_inspection_id and
            afterhours=p_afterhours;

  cursor c_insp(p_inspection_id number) is
    select * 
    from insp_inspections
    where inspection_id=p_inspection_id 
      for update;

begin


  for c1 in c_con1 loop
    for c2 in c_con2(c1.schedule_id, c1.inspector, c1.afterhours) loop
      for c in c_insp(c2.inspection_id) loop
        if ( P_START_DATE  <> c.start_date or
(P_START_DATE  is null and c.start_date is not NULL) or
(P_START_DATE  is not null and c.start_date is NULL) ) then
        update insp_inspections 
          set start_date=P_START_DATE
          where current of c_insp;
          end if;

        if ( P_START_TIME  <> c.start_time or
(P_START_TIME  is null and c.start_time is not NULL) or
(P_START_TIME  is not null and c.start_time is NULL) ) then
        update insp_inspections 
          set start_time=P_START_TIME
          where current of c_insp;
          end if;

        if ( P_END_DATE  <> c.end_date or
(P_END_DATE  is null and c.end_date is not NULL) or
(P_END_DATE  is not null and c.end_date is NULL) ) then
        update insp_inspections 
          set end_date=P_END_DATE
          where current of c_insp;
          end if;

        if ( P_END_TIME  <> c.end_time or
(P_END_TIME  is null and c.end_time is not NULL) or
(P_END_TIME  is not null and c.end_time is NULL) ) then
        update insp_inspections 
          set end_time=P_END_TIME
          where current of c_insp;
          end if;

        if ( P_TEMPERATURE  <> c.temperature or
(P_TEMPERATURE  is null and c.temperature is not NULL) or
(P_TEMPERATURE  is not null and c.temperature is NULL) ) then
        update insp_inspections 
          set temperature=P_TEMPERATURE
          where current of c_insp;
          end if;

        if ( P_WEATHER  <> c.weather or
(P_WEATHER  is null and c.weather is not NULL) or
(P_WEATHER  is not null and c.weather is NULL) ) then
        update insp_inspections 
          set weather=P_WEATHER
          where current of c_insp;
         end if;

        end loop;
    end loop;
  end loop;
  return null;

end insp_general_info_sync_to;
*/
/*
    FUNCTION insp_populate_crew_members(
        p_inspection_id  in  number
    ) RETURN varchar2 IS
      v_member_type varchar2(20);
      v_crew_id number;
      v_id number;

      cursor c_insp_crew_members(p_crew_id number, p_member_type varchar2)is
        select *
        from insp_crew_members
        where crew_id=p_crew_id and
        member_type=p_member_type;

      cursor c_def_labour(p_id number) is
        select *
        from def_labour
        where id=p_id and
              status='A';

      cursor c_def_eqmt(p_id number) is
        select *
        from def_eqmt
        where id=p_id and
              status='A';

    begin
      select crew_id into v_crew_id from wa_daily_schedules where inspection_id=p_inspection_id;
      v_member_type := 'labour';
      for c in c_insp_crew_members(v_crew_id, v_member_type) loop
        for c1 in c_def_labour(c.member_id) loop
          insert into insp_labour(INSPECTION_ID,LABOUR_NAME,LABOUR_ID, CREW_ID) values (p_inspection_id, c1.labour_name, c1.id, v_crew_id);
        end loop;
      end loop;
      v_member_type := 'equipment';
      for c in c_insp_crew_members(v_crew_id, v_member_type) loop
        for c1 in c_def_eqmt(c.member_id) loop
          insert into insp_eqmt(INSPECTION_ID,EQMT_NAME,EQMT_ID, CREW_ID) values (p_inspection_id, c1.eqmt_name, c1.id, v_crew_id);
        end loop;
      end loop;
      return null;
    end insp_populate_crew_members;
    */

------------------------------------------------
-- notifiedSetAttributes
------------------------------------------------  
    procedure notifiedSetAttributes(
        p_group_id      varchar2,
        p_notified_date varchar2
    )
    is
    begin

        update wo_groups 

            set notified        = 'Y', 
                notified_date   = to_date( p_notified_date, 'YYYY-MM-DD' ),
                NOTIFY_SET_DATE = sysdate,
                NOTIFIED_BY     = v('APP_USER')

        where group_id = p_group_id;

    end notifiedSetAttributes;

------------------------------------------------
-- notifyClearedSetAttributes
------------------------------------------------  
    procedure notifyClearedSetAttributes(
        p_group_id      varchar2
    )
    is
    begin

        update wo_groups set notified = null, notified_date = null
        where group_id = p_group_id;

    end notifyClearedSetAttributes;


------------------------------------------------
-- scanScheduleSendNotifications
------------------------------------------------     
/*    procedure scanScheduleSendNotifications
    is
        v_emailsubject   varchar2(400);
        v_receivers      varchar2(400);
        v_cc             varchar2(400) := null;
        v_emailbody      varchar2(4000);
        v_default_sender varchar2(400) := 'cms@toronto.ca';

        CRLF             VARCHAR2( 2 ):= CHR( 13 ) || CHR( 10 );

    begin   

        for rec in (

            select 

                group_name, 
                schedule_date,
                first_name || ' ' || last_name || ' [ ' || username || ' ]' contractor_name,
                email contractor_email,
                phase_code,
                sche.project_code

            from wa_daily_schedules sche
            inner join wo_groups wo
            on sche.group_id = wo.group_id  
            inner join users
            on users.user_id = sche.contractor_id

            where crew_id is null and to_date( SCHEDULE_DATE ) = to_date( sysdate + 1 )

        ) loop

            v_emailsubject  := 'Do Not Reply - You have one shcedule still have no crew assigned for assignment [ ' || rec.group_name || ' ]';

            v_emailbody     := 'Hello ' || rec.contractor_name || CRLF || CRLF
                            || 'Please note you have one shcedule which is in phase [ ' || rec.phase_code || ' ], still have no crew assigned for assignment [ ' || rec.group_name || ' ]' || CRLF || CRLF
                            || 'Project code: ' || rec.project_code || CRLF || CRLF
                            || 'This is an automated email.  Please do not reply to this message. ' || CRLF || CRLF
                            || 'Thanks.' || CRLF || CRLF
                            || 'CMS Application' || AF_ASSIGNMENT_PCK.getDBServerName()
                            ;

            v_receivers     := rec.contractor_email;

            if v('APP_USER') is null then

                AF_ASSIGNMENT_PCK.tmp_create_apex_session(
                    p_app_id      => 150,
                    p_app_user    => 'cms',
                    p_app_page_id => 1
                );

            end if;

            AF_ASSIGNMENT_PCK.send_useremail(
                p_sender       => v_default_sender,
                p_recipients   => v_receivers,
                p_cc           => v_cc,
                p_replyto      => v_default_sender,
                p_subject      => v_emailsubject,
                p_message      => v_emailbody,
                P_is_body_html => false
            );

        end loop;

    end scanScheduleSendNotifications;

 */   

------------------------------------------------
-- setInspectionComplete
------------------------------------------------ 
    procedure setInspectionFinal_Last(
        p_inspection_id      varchar2,
        p_set_last           varchar2
    )
    is
        v_is_paid_item varchar2(10);

    begin

  --  raise_application_error( -20000, p_set_last );


    /*

        if upper(p_set_last) = 'YES' then
  --   raise_application_error( -20000, p_inspection_id );

            update insp_inspections set last_insp_ind = 'N' 
                where group_id = ( select group_id from insp_inspections where inspection_id = p_inspection_id );

            update insp_inspections set last_insp_ind = 'Y' where inspection_id = p_inspection_id;

            update wo_groups set LAST_INSP_ID       = p_inspection_id,               
                                 LAST_INSP_SET_DATE = sysdate,
                                 LAST_INSP_SET_BY   = v('APP_USER')
                where group_id = ( select group_id from insp_inspections where inspection_id = p_inspection_id );

        end if;
      */

      null;

    end setInspectionFinal_Last;

------------------------------------------------
-- submitInspection
------------------------------------------------    
    procedure submitInspection (
        p_inspection_id number,
        p_item_paid     varchar2 default null
    )
    is
        v_is_paid_item varchar2(10);
        v_insp_date date;
        v_group_id  int;
    begin


    --   raise_application_error( -20000, 'called');

        setInspIndicators (
            p_inspection_id => p_inspection_id,
            p_setvalue      => 'Y'
        );

        if p_item_paid is not null then
            v_is_paid_item := p_item_paid;
        else
            select ITEMS_IND, start_date into v_is_paid_item, v_insp_date from insp_inspections where inspection_id = p_inspection_id;
        end if;

        if v_is_paid_item  is not null and v_is_paid_item = 'Y' then

           setInspectionStatus(
                p_inspection_id => p_inspection_id,
                p_status        => 'SUBMITTED'
            );

          update work_order_tender_items set approval_comments=NULL, work_date = v_insp_date where inspection_id = p_inspection_id and extra_id is null;
       else

            setInspectionStatus(
                p_inspection_id => p_inspection_id,
                p_status        => 'APPROVED'
            );


       end if;


       -- added by Shawn on Feb. 26, 2020

       set_cut_cat_start_date_status(
            p_inspection_id => p_inspection_id
        );




    end submitInspection;

------------------------------------------------
-- setInspIndicators
------------------------------------------------ 
    procedure setInspIndicators (
        p_inspection_id number,
        p_setvalue      varchar2
    )
    is
        v_items_ind varchar2(1);
    begin

        update insp_inspections 
                set LABOUR_IND = p_setvalue, 
                    EQMT_IND = p_setvalue, 
                    CONSTRUCTION_IND = p_setvalue, 
                    BACKFILL_IND = p_setvalue, 
                    ALLOWANCE_IND = p_setvalue, 
                    RESURFACING_IND = p_setvalue
                where inspection_id = p_inspection_id;
        /*select items_ind into v_items_ind from insp_inspections  where inspection_id = p_inspection_id;
        if v_items_ind = 'N' and p_setvalue = 'N' then
          update insp_inspections 
                set LABOUR_IND = null, 
                    EQMT_IND = null,  
                    CONSTRUCTION_IND = null, 
                    BACKFILL_IND = null, 
                    ALLOWANCE_IND = null, 
                    RESURFACING_IND = null
                where inspection_id = p_inspection_id;

        else
          update insp_inspections 
                set LABOUR_IND = p_setvalue, 
                    EQMT_IND = p_setvalue, 
                    CONSTRUCTION_IND = p_setvalue, 
                    BACKFILL_IND = p_setvalue, 
                    ALLOWANCE_IND = p_setvalue, 
                    RESURFACING_IND = p_setvalue
                where inspection_id = p_inspection_id;
        end if;
        exception when no_data_found then
            return ;*/

    end setInspIndicators;

------------------------------------------------
-- clearInspectionLast
------------------------------------------------ 
    procedure clearInspectionLast(
        p_inspection_id      varchar2
    )
    is
    begin

        update insp_inspections set last_insp_ind = 'N' where inspection_id = p_inspection_id;

        update wo_groups set LAST_INSP_ID       = null,               
                             LAST_INSP_SET_DATE = sysdate,
                             LAST_INSP_SET_BY   = v('APP_USER')
            where group_id = ( select group_id from insp_inspections where inspection_id = p_inspection_id );

    end clearInspectionLast;

------------------------------------------------
-- cancelInspection
------------------------------------------------ 
    procedure cancelInspection(
        p_inspection_id      varchar2
    )
    is
    begin


        setInspIndicators (
            p_inspection_id => p_inspection_id,
            p_setvalue      => 'Y'
        );

        setInspectionStatus(
            p_inspection_id => p_inspection_id,
            p_status        => 'CANCELLED'
        );

    end cancelInspection;

------------------------------------------------
-- findCompleteInspID
------------------------------------------------ 

    FUNCTION findLastInspID(
        p_inspection_id  in  number
    ) RETURN varchar2      
    is
        v_ret_var varchar2(300);
    begin

        select inspection_id into v_ret_var from insp_inspections
        where last_insp_ind = 'Y' and inspection_id <> p_inspection_id
        and group_id = ( select group_id from insp_inspections where inspection_id = p_inspection_id );

        return v_ret_var;

    exception
        when others then
          return null;

    end findLastInspID;

------------------------------------------------
-- isThisInspIDLastInsp
------------------------------------------------ 

    FUNCTION isThisInspIDLastInsp(
        p_inspection_id  in  number
    ) RETURN boolean      
    is
        v_cnt number;
    begin

    /*
        select count(*) into v_cnt from insp_inspections
        where last_insp_ind = 'Y' and inspection_id = p_inspection_id
        and group_id = ( select group_id from insp_inspections where inspection_id = p_inspection_id );

        if v_cnt = 0 then
            return false;
        else
            return true;
        end if;
      */

      return false;

    end isThisInspIDLastInsp;


------------------------------------------------
-- createNewSchedules
------------------------------------------------    
    procedure createNewSchedules(
        p_group_id        number,
        p_schedule_date   varchar2,
        p_phase_1_crew_id number,
        p_phase_2_crew_id number,
        p_phase_3_crew_id number,
        p_phase_4_crew_id number,
        p_output_msg      out varchar2
    )
    is
        v_cnt           int;
        v_schedule_id   number;
        v_contract_code number;

        v_wa_included   VARCHAR2(20);
    begin

        isScheduleExisting (

            p_schedule_date   => p_schedule_date,
            p_contract_code   => NULL,
            p_group_id        => p_group_id,
            p_schedule_id     => v_schedule_id, -- OUT NUMBER
            p_wa_included     => v_wa_included  -- OUT VARCHAR2

        );

        if v_wa_included = 'Y' then
        --    raise_application_error( -20000, 'This assignment is current having schedule for the date' );
        /*     apex_error.add_error(p_message => 'createNewSchedules'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

        */     

            p_output_msg := 'This assignment is already included in daily schedule on the date';
            return;
        else
            p_output_msg :=  null;
        end if;


        if v_schedule_id is null then
            select WA_DAILY_SCHEDULE_SCH_ID_SEQ.nextval into v_schedule_id from sys.dual;
        end if;

        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, status) 
             values (p_group_id, p_phase_1_crew_id, 'PREP', p_schedule_date, v_schedule_id, 'NEW');

        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, status) 
             values (p_group_id, p_phase_2_crew_id, 'CONCRETE', p_schedule_date, v_schedule_id, 'NEW');

        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, status) 
             values (p_group_id, p_phase_3_crew_id, 'ASPHALT', p_schedule_date, v_schedule_id, 'NEW');

        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, status) 
             values (p_group_id, p_phase_4_crew_id, 'FINISH', p_schedule_date, v_schedule_id, 'NEW');

    end createNewSchedules;

------------------------------------------------
-- consolidateNotifiedAddr
------------------------------------------------  
    function consolidateNotifiedAddr(
        p_group_id number
    ) return varchar2
    RESULT_CACHE
    is

        v_retvar                 varchar2(3000) := null;
        last_street_name         varchar2(300)  := null;
        last_street_num          varchar2(300)  := null;
        last_address             varchar2(300)  := null;
        last_time_store_num_only boolean        := false;
    begin

    /*
        select  
            listagg(address, ', ') WITHIN GROUP (ORDER BY address)
        into v_retvar
        from wo_pr_address
        where group_id = p_group_id
        group by group_id;

        return v_retvar;
      */

        for rec in (

            select  address,
                    case when instr( address, ' ') > 1 
                         then
                            case when pr_package.is_number( substr( address, 1, instr( address, ' ') - 1 ) ) = 1
                                     then substr( address, 1, instr( address, ' ') - 1 )
                                 else ''
                            end
                         else ''
                    end street_num,
                    case when instr( address, ' ') > 1  
                         then
                            case when pr_package.is_number( substr( address, 1, instr( address, ' ') - 1 ) ) = 1
                                     then substr( address, instr( address, ' ') + 1, length( address )  )
                                 else address
                            end         
                         else address
                    end street_name

            from wo_pr_address
            where group_id = p_group_id
           order by street_name, street_num

        ) loop 

            if last_street_name is not null then

                if last_address <> rec.address then

                    if last_street_name <> rec.street_name then

                        if last_time_store_num_only = true then
                         --   v_retvar := v_retvar || ' ' || last_street_name || '] [' || rec.street_num;
                            v_retvar := v_retvar || ' ' || last_street_name || '; ' || rec.street_num;

                        else
                            v_retvar := v_retvar || '; ' || rec.street_num;
                        --    v_retvar := v_retvar || ' [' || rec.street_num;
                            last_time_store_num_only := true;
                        end if;

                    else

                       if last_time_store_num_only = true then
                           v_retvar := v_retvar || ', ' || rec.street_num;
                       else
                         --   v_retvar := v_retvar || '] [' || last_street_num;
                            v_retvar := v_retvar || '; ' || last_street_num;
                            last_time_store_num_only := true;
                       end if;

                    end if;

                end if;

            else
                last_time_store_num_only := true;
            --    v_retvar := '[' || rec.street_num;
                v_retvar := rec.street_num;
            end if;

            last_street_num  := rec.street_num;
            last_street_name := rec.street_name; 
            last_address     := rec.address;

        end loop;

        -- process final one
        if last_street_name is not null then

            if last_time_store_num_only = true then
              --  v_retvar := v_retvar || ' ' || last_street_name || ']';
                v_retvar := v_retvar || ' ' || last_street_name;

            else
              --  v_retvar := v_retvar || '] [' || last_address || ']'; 
                v_retvar := v_retvar || '; ' || last_address;   
            end if;

        else
            v_retvar := '';
        end if;      


        return v_retvar;

    end consolidateNotifiedAddr;

------------------------------------------------
-- is_number
------------------------------------------------      
    FUNCTION is_number (p_string IN VARCHAR2)
       RETURN INT
    IS
       v_new_num NUMBER;
    BEGIN
       v_new_num := TO_NUMBER(p_string);
       RETURN 1;
    EXCEPTION
    WHEN VALUE_ERROR THEN
       RETURN 0;
    END is_number;

------------------------------------------------
-- get_wa_cut_types
------------------------------------------------      
    FUNCTION get_wa_cut_types (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2
    RESULT_CACHE IS
      v_cut_types varchar2(2000) := null;
    BEGIN
        select regexp_replace( LISTAGG( resttype_code, ',' ) WITHIN GROUP (ORDER BY resttype_code),'([^,]+)(,\1)*(,|$)', '\1\3') cut_types into v_cut_types
        from wo_pr_polygon
        where group_id=p_group_id;
        return v_cut_types;
    END get_wa_cut_types;



------------------------------------------------
-- setInspectionStatus
------------------------------------------------     

    procedure setInspectionStatus(
        p_inspection_id number,
        p_status        varchar2
    )
    is
    begin

       update insp_inspections set STATUS = p_status, STATUS_BY = v('APP_USER'),  STATUS_DATE = sysdate
           where inspection_id = p_inspection_id;

       update insp_inspections set STATUS_HISTORY =  substr( p_status || ' by ' || v('APP_USER') || ' at ' || sysdate || CHR( 13 ) || CHR( 10 ) || STATUS_HISTORY, 1, 1000 )
            where inspection_id = p_inspection_id;

        -- reset non-extra work order item approve column
        if p_status = 'VERIFIED' then
        /*
            merge into work_order_tender_items a
            using tender_items b
            on ( a.tender_item_id = b.tender_item_id )
            when matched then
                 update  set a.approved = null
            where a.extra_id is null and b.category not in ( 'ALLOWANCE' )
            and a.inspection_id = p_inspection_id
            and a.approved = 'N';
          */       
            update work_order_tender_items set approved = null 
            where extra_id is null
            and inspection_id = p_inspection_id
            and approved = 'N';

        end if;

    end setInspectionStatus;


PROCEDURE save_wa_daily_schedules ( p_collection_name VARCHAR2,p_schedule_date DATE ) IS

    CURSOR cur_collection IS
        SELECT
            c001,
            c002,
            c003,
            c004,
            c006,
            n001
        FROM
            apex_collections
        WHERE
            collection_name = p_collection_name;

    CURSOR cur_ref_perm_phases ( p_seq NUMBER ) IS
        SELECT
            phase_code
        FROM
            ref_perm_phases
        WHERE
            seq = p_seq;

    v_phase_code    VARCHAR2(20);
    v_schedule_id   NUMBER;
    v_afterhours    VARCHAR2(1);
    v_wa_included   VARCHAR2(1);
BEGIN
    FOR c IN cur_collection LOOP
        isScheduleExisting(p_schedule_date, null, c.n001,v_schedule_id, v_wa_included);
        EXIT;
    END LOOP;    
    IF v_schedule_id IS NULL THEN
        SELECT
            wa_daily_schedule_sch_id_seq.NEXTVAL
        INTO
            v_schedule_id
        FROM
            sys.dual;

        FOR c IN cur_collection LOOP
            FOR c1 IN cur_ref_perm_phases(1) LOOP
                v_phase_code := c1.phase_code;
            END LOOP;

            IF c.c006 IS NOT NULL AND c.c006 = 'Y' THEN
                v_afterhours := 'Y';
            ELSE
                v_afterhours := 'N';
            END IF;

            INSERT INTO wa_daily_schedules (
                group_id,
                crew_id,
                phase_code,
                schedule_date,
                schedule_id,
                afterhours,
                status
            ) VALUES (
                c.n001,
                c.c001,
                v_phase_code,
                p_schedule_date,
                v_schedule_id,
                v_afterhours,
                'NEW'
            );


            FOR c1 IN cur_ref_perm_phases(2) LOOP
                v_phase_code := c1.phase_code;
            END LOOP;
            INSERT INTO wa_daily_schedules (
                group_id,
                crew_id,
                phase_code,
                schedule_date,
                schedule_id,
                afterhours,
                status
            ) VALUES (
                c.n001,
                c.c002,
                v_phase_code,
                p_schedule_date,
                v_schedule_id,
                v_afterhours,
                'NEW'
            );

            FOR c1 IN cur_ref_perm_phases(3) LOOP
                v_phase_code := c1.phase_code;
            END LOOP;
            INSERT INTO wa_daily_schedules (
                group_id,
                crew_id,
                phase_code,
                schedule_date,
                schedule_id,
                afterhours,
                status
            ) VALUES (
                c.n001,
                c.c003,
                v_phase_code,
                p_schedule_date,
                v_schedule_id,
                v_afterhours,
                'NEW'
            );

            FOR c1 IN cur_ref_perm_phases(4) LOOP
                v_phase_code := c1.phase_code;
            END LOOP;
            INSERT INTO wa_daily_schedules (
                group_id,
                crew_id,
                phase_code,
                schedule_date,
                schedule_id,
                afterhours,
                status
            ) VALUES (
                c.n001,
                c.c004,
                v_phase_code,
                p_schedule_date,
                v_schedule_id,
                v_afterhours,
                'NEW'
            );


        END LOOP;
    ELSE
        apex_error.add_error(p_message => 'Schedule already exists on the day!',p_display_location => apex_error.c_inline_in_notification);
    END IF;
    apex_collection.delete_collection(p_collection_name);
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'SAVE_WA_DAILY_SCHEDULES'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);
END save_wa_daily_schedules;



PROCEDURE save_wa_daily_schedules_1 ( p_collection_name VARCHAR2,p_schedule_date DATE ) IS

    CURSOR cur_collection IS
        SELECT
            c001,
            c006,
            n001
        FROM
            apex_collections
        WHERE
            collection_name = p_collection_name;

    CURSOR cur_ref_perm_phases ( p_seq NUMBER ) IS
        SELECT
            phase_code
        FROM
            ref_perm_phases
        WHERE
            seq = p_seq;

    v_phase_code    VARCHAR2(20);
    v_schedule_id   NUMBER;
    v_afterhours    VARCHAR2(1);
    v_wa_included   VARCHAR2(1);
BEGIN
    FOR c IN cur_collection LOOP
        isScheduleExisting(p_schedule_date, null, c.n001,v_schedule_id, v_wa_included);
        EXIT;
    END LOOP;    
    IF v_schedule_id IS NULL THEN
        SELECT
            wa_daily_schedule_sch_id_seq.NEXTVAL
        INTO
            v_schedule_id
        FROM
            sys.dual;

        FOR c IN cur_collection LOOP
            FOR c1 IN cur_ref_perm_phases(1) LOOP
                v_phase_code := c1.phase_code;
            END LOOP;

            IF c.c006 IS NOT NULL AND c.c006 = 'Y' THEN
                v_afterhours := 'Y';
            ELSE
                v_afterhours := 'N';
            END IF;

            INSERT INTO wa_daily_schedules (
                group_id,
                crew_id,
                phase_code,
                schedule_date,
                schedule_id,
                afterhours,
                status
            ) VALUES (
                c.n001,
                c.c001,
                v_phase_code,
                p_schedule_date,
                v_schedule_id,
                v_afterhours,
                'NEW'
            );


        END LOOP;
    ELSE
        apex_error.add_error(p_message => 'Schedule already exists on the day!',p_display_location => apex_error.c_inline_in_notification);
    END IF;
    apex_collection.delete_collection(p_collection_name);
    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'SAVE_WA_DAILY_SCHEDULES_1'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);
END save_wa_daily_schedules_1;

procedure insert_wa_daily_schedules(
        p_group_id number,
        p_schedule_date  date
    )
is
    cursor cur_ref_perm_phases(p_seq number) is
    select phase_code
    from ref_perm_phases
    where seq=p_seq;
    v_phase_code varchar2(20);
    v_contract_code number;
    v_schedule_id number;
begin
    select contract_code into v_contract_code from wo_groups where group_id=P_GROUP_ID;

    select min(schedule_id) into v_schedule_id from wa_daily_schedules where schedule_date=P_SCHEDULE_DATE and group_id in (select group_id from wo_groups where contract_code=v_contract_code);
    if v_schedule_id is null then  
        select WA_DAILY_SCHEDULE_SCH_ID_SEQ.nextval into v_schedule_id from sys.dual; 
    end if;
    for c1 in cur_ref_perm_phases(1) loop
        v_phase_code := c1.phase_code;
    end loop;
    insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');

    for c1 in cur_ref_perm_phases(2) loop
        v_phase_code := c1.phase_code;
    end loop;
    insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');
    for c1 in cur_ref_perm_phases(3) loop
        v_phase_code := c1.phase_code;
    end loop;
    insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');
    for c1 in cur_ref_perm_phases(4) loop
        v_phase_code := c1.phase_code;
    end loop;
    insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');

end insert_wa_daily_schedules;

procedure insert_insp_wa_daily_schedules(
        p_group_id number,
        p_schedule_date  date,
        p_contract_code varchar2,
        p_inspector_list number
    )
is
    cursor cur_ref_perm_phases(p_seq number) is
    select phase_code
    from ref_perm_phases
    where seq=p_seq;
    v_phase_code varchar2(20);
    v_contract_code number;
    v_contract_type varchar2(100);
    v_project_code varchar2(20);
    v_schedule_id number;
    v_user_id number;
    v_user_name varchar2(100);
    v_wa_schedule_id number;
    v_cnt number;
    v_ret Number;
begin
    --select contract_code into v_contract_code from wo_groups where group_id=P_GROUP_ID;
    select contract_type, project_code into v_contract_type, v_project_code from contracts where contract_code=p_contract_code;
    if p_inspector_list is null then
      SELECT user_id, case 
    when first_name is not null 
      then first_name || ' ' || last_name
      else username
  end INTO v_user_id, v_user_name FROM USERS WHERE upper(username)=upper(v('APP_USER'));
    else
      v_user_id := p_inspector_list;
      SELECT case 
    when first_name is not null 
      then first_name || ' ' || last_name
      else username
  end INTO v_user_name FROM USERS WHERE user_id=p_inspector_list;
    end if;


    select min(schedule_id) into v_schedule_id from wa_daily_schedules where schedule_date=P_SCHEDULE_DATE and group_id in (select group_id from wo_groups where contract_code=p_contract_code);
    if v_schedule_id is null then  
        select WA_DAILY_SCHEDULE_SCH_ID_SEQ.nextval into v_schedule_id from sys.dual; 
    end if;
    /*for c1 in cur_ref_perm_phases(1) loop
        v_phase_code := c1.phase_code;
    end loop;*/

            INSERT INTO wa_daily_schedules (
                group_id,
                crew_id,
                phase_code,
                schedule_date,
                schedule_id,
                afterhours,
                status,
                inspector,
                inspector_assigned_by,
                inspector_assigned_date
            ) VALUES (
                p_group_id,
                null,
                null,
                p_schedule_date,
                v_schedule_id,
                'N',
                'NEW',
                v_user_id,
                v('APP_USER'),
                sysdate
            ) returning id into v_wa_schedule_id;
            v_ret := insp.createinspection(  p_inspection_id => null,
                                    p_group_id => p_group_id,
                                    p_wa_schedule_id => v_wa_schedule_id,
                                    p_assigned_inspector => v_user_id,
                                    p_start_date => p_schedule_date,
                                    p_end_date => p_schedule_date
                                    );
      if p_inspector_list is not null then
        select count(1) into v_cnt from insp_daily_schedules where contract_code=p_contract_code and schedule_date=p_schedule_date and inspector_id=p_inspector_list;
        if v_cnt=0 then
            insp.insert_insp_daily_schedules(
                P_CONTRACT_CODE, 
                V_PROJECT_CODE, 
                P_SCHEDULE_DATE,
                P_INSPECTOR_LIST,
                V_USER_NAME,
                upper(v('APP_USER')));
        end if;
      end if;

    /*if v_contract_type='PERM RESTORATION' then
        for c1 in cur_ref_perm_phases(2) loop
            v_phase_code := c1.phase_code;
        end loop;
        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');
        for c1 in cur_ref_perm_phases(3) loop
            v_phase_code := c1.phase_code;
        end loop;
        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');
        for c1 in cur_ref_perm_phases(4) loop
            v_phase_code := c1.phase_code;
        end loop;
        insert into wa_daily_schedules(group_id, crew_id, phase_code, schedule_date, schedule_id, afterhours, status) values (P_GROUP_ID, null, v_phase_code, P_SCHEDULE_DATE, v_schedule_id, 'N', 'NEW');
    end if;*/

end insert_insp_wa_daily_schedules;

FUNCTION get_wa_post_status (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2 AS
    v_status varchar2(20);
    v_po_status varchar2(20);
    v_notified varchar2(1);
    v_cnt number;
    v_cnt1 number;
    BEGIN
        /*select status into v_status from wo_groups where group_id = p_group_id;
        select count(*) into v_cnt  from wa_daily_schedules where group_id = p_group_id;
        select count(*) into v_cnt1 from insp_inspections where last_insp_ind='Y' and group_id = p_group_id;
        if v_status='COMPLETED' then
            return 'COMPLETED';
        end if;
        if v_status='NEW' and v_cnt1>0 then
            return 'COMPLETED';
        end if;
        if v_status='NEW' and v_cnt=0 then
            return 'OUTSTANDING';
        end if;
        if v_status='NEW' and v_cnt>0 and v_cnt1=0 then
            return 'IN PROGRESS';
        end if;
        return null;*/
        select status, notified into v_status , v_notified from wo_groups where group_id = p_group_id;

        case v_status 
            when 'COMPLETED' then
                v_po_status := v_status;
            when 'NEW'  then
                 select count(*) into v_cnt  from wa_daily_schedules where group_id = p_group_id;
                 if v_cnt > 0  then
                    v_po_status :='IN PROGRESS';
                 else
                    if v_notified = 'Y' then
                        v_po_status := 'NOTIFIED';
                    else
                        v_po_status := 'OUTSTANDING';
                    end if;
                end if;
            else
                v_po_status := null;
        end case;

        return v_po_status;



    EXCEPTION
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'GET_WA_POST_STATUS'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN NULL;
    END get_wa_post_status;



    function getTenderItemDocCount(
        p_tender_item_id varchar2       
    ) return number 
    IS
        v_cnt number :=0;
    BEGIN
      SELECT count(*) INTO v_cnt FROM DEF_TENDER_ITEM_DOC WHERE tender_item_id=p_tender_item_id;
      RETURN v_cnt;
    END;

------------------------------------------------
-- assignInspectorToSche
------------------------------------------------      
    procedure assignInspectorToSche(
        p_schedule_id  number,
        p_inspector_id number
    )
    is

        cnt             number;
        v_inspection_id number;
        V_SCHEDULE_DATE date;
        v_group_id      number;
        V_afterhours    varchar2(10);
        v_ret           varchar2(20);

    begin

        update wa_daily_schedules 
            set inspector               = p_inspector_id,
                INSPECTOR_ASSIGNED_BY   = v('APP_USER'),
                INSPECTOR_ASSIGNED_DATE = systimestamp

            where id = p_schedule_id;

        -- Create inspection if there is none, or update inspctor ID
        select count(*) into cnt from insp_inspections where WA_SCHEDULE_ID = p_schedule_id;

        if cnt > 0 then
            update insp_inspections set ASSIGNED_INSPECTOR = p_inspector_id where WA_SCHEDULE_ID = p_schedule_id;
        else

            select "insp_inspection_SEQ".nextval into V_INSPECTION_ID from dual; 

            select SCHEDULE_DATE, group_id, afterhours into V_SCHEDULE_DATE, v_group_id, V_afterhours from wa_daily_schedules where id = p_schedule_id;

            if  upper( V_afterhours ) = 'N' then 

                Insert into insp_inspections(
                    inspection_id, group_id, wa_schedule_id, start_date, end_date, assigned_inspector
                    )
                values (v_inspection_id, v_group_id, p_schedule_id, V_SCHEDULE_DATE, V_SCHEDULE_DATE, p_inspector_id);

            else

                Insert into insp_inspections(
                    inspection_id, group_id, wa_schedule_id, start_date, end_date, assigned_inspector
                    )
                values (v_inspection_id, v_group_id, p_schedule_id, V_SCHEDULE_DATE, V_SCHEDULE_DATE + 1, p_inspector_id);

            end if;

            pr_package.setInspectionStatus(
                            p_inspection_id => V_INSPECTION_ID,
                            p_status        => 'SCHEDULED'
                        );

            update wa_daily_schedules set inspection_id = V_INSPECTION_ID where id = p_schedule_id;

            --populate labour and equipment from the crew 
            v_ret := insp.insp_populate_crew_members(V_INSPECTION_ID);

        end if;


    end assignInspectorToSche;

    FUNCTION inspection_report_overdue (
    p_schedule_date             IN DATE,
    p_afterhours                IN VARCHAR2,
    p_inspector_assigned_date   IN DATE
    ) RETURN VARCHAR2 IS
    v_status   VARCHAR2(20);
BEGIN
    IF p_schedule_date is null or p_inspector_assigned_date is null THEN
        return 'N';
    END IF;


    IF
        ( p_inspector_assigned_date + 1 < SYSDATE AND trunc(p_inspector_assigned_date,'DD') = trunc(p_schedule_date,'DD') )
    THEN
        RETURN 'Y';
    END IF;

    IF
        ( ( p_afterhours = 'Y' AND p_schedule_date + 2 < SYSDATE ) OR ( p_afterhours <> 'Y' AND p_schedule_date + 1 < SYSDATE ) )
    THEN
        RETURN 'Y';
    END IF;



    RETURN 'N';
END inspection_report_overdue;

FUNCTION require_doc (
    p_work_order_item_id   IN VARCHAR2,
    p_doc_type IN VARCHAR2 DEFAULT NULL
) RETURN VARCHAR2 IS
v_count NUMBER;    
BEGIN

    select count(*) into v_count from work_order_tender_items woti
                inner join def_tender_item_doc tid on woti.tender_item_id = tid.tender_item_id and (tid.doc_type = p_doc_type or p_doc_type is null)
                where work_order_item_id = p_work_order_item_id and (tid.doc_type = p_doc_type or p_doc_type is null);

    if v_count > 0 then
        return 'Y';
    else 
        return 'N';
    end if;

END require_doc;

FUNCTION pending_doc (
    p_inspection_id        IN NUMBER,
    p_inspection_status    IN VARCHAR2,
    p_doc_type             IN VARCHAR2 DEFAULT NULL,
    p_work_order_item_id   IN VARCHAR2 DEFAULT NULL,
    p_extra_id             IN NUMBER DEFAULT NULL,
    p_extra_status         IN VARCHAR2 DEFAULT NULL

) RETURN VARCHAR2 IS
    v_status   VARCHAR2(20);
    v_extra_status   VARCHAR2(20);

    v_cnt int;

BEGIN


    IF p_inspection_status is null THEN
        SELECT 
         insp.getConsolidatedInspStatus(

            p_inspection_id => ii.inspection_id,
            p_start_date    => ii.start_date,
            p_status        => ii.status, 
            p_afterhours    => wds.afterhours

        )  INTO v_status FROM insp_inspections ii inner join wa_daily_schedules wds on ii.inspection_id = wds.inspection_id
           WHERE ii.inspection_id = p_inspection_id;
    ELSE
        v_status := p_inspection_status;
    END IF;


    IF p_extra_id is not null THEN
        IF p_extra_status is null THEN
            SELECT 
            insp.getConsolidatedEWStatus (
                 p_extra_work_id => ie.id,
                 p_start_date => ie.start_date,
                 p_status => ie.status, 
                 p_afterhours => wds.afterhours)
            INTO v_status FROM insp_extra ie inner  join wa_daily_schedules wds on ie.inspection_id = wds.inspection_id 
            WHERE ie.inspection_id = p_inspection_id and ie.id = p_extra_id;
        ELSE
            v_status := p_extra_status;
        END IF;
    END IF;

    IF v_status <> 'VERIFIED' AND v_extra_status <> 'VERIFIED' THEN
        RETURN 'N';
    END IF;



    FOR rec in (select woti.work_order_item_id, doc_id from work_order_tender_items woti
                inner join def_tender_item_doc tid on woti.tender_item_id = tid.tender_item_id 

                left outer join wo_docs wd on wd.work_order_item_id = woti.work_order_item_id and wd.content_type = tid.doc_type 
                    and (wd.content_type =  p_doc_type  or p_doc_type is null) and (tid.doc_type = p_doc_type or p_doc_type is null)
                where woti.inspection_id = p_inspection_id 
                      and ( (p_extra_id is null and woti.extra_id is null) or (p_extra_id is not null and woti.extra_id = p_extra_id))                      
                      and (p_work_order_item_id is null or woti.work_order_item_id = p_work_order_item_id)                       
                      and (p_doc_type is null or tid.doc_type = p_doc_type) 
                )      
    loop
        if rec.doc_id is null then
            return 'Y';
        end if;
        if rec.doc_id is not null and dcs_wpm_general_pck.is_item_doc_approved(rec.work_order_item_id,p_doc_type) = 'N' then
            return 'Y';
        end if;
    end loop;


    return 'N';
END pending_doc;

  FUNCTION item_doc_pending_approval (
        p_inspection_id        IN NUMBER,
        p_inspection_status    IN VARCHAR2,
        p_doc_type             IN VARCHAR2 DEFAULT NULL,
        p_work_order_item_id   IN VARCHAR2 DEFAULT NULL,
        p_extra_id             IN NUMBER DEFAULT NULL,
        p_extra_status         IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2 AS
    v_status   VARCHAR2(20);
    v_extra_status   VARCHAR2(20);

    v_cnt int;

BEGIN

    IF p_inspection_status is null THEN
        SELECT 
         insp.getConsolidatedInspStatus(

            p_inspection_id => ii.inspection_id,
            p_start_date    => ii.start_date,
            p_status        => ii.status, 
            p_afterhours    => wds.afterhours

        )  INTO v_status FROM insp_inspections ii inner join wa_daily_schedules wds on ii.inspection_id = wds.inspection_id
           WHERE ii.inspection_id = p_inspection_id;
    ELSE
        v_status := p_inspection_status;
    END IF;


    IF p_extra_id is not null THEN
        IF p_extra_status is null THEN
            SELECT 
            insp.getConsolidatedEWStatus (
                 p_extra_work_id => ie.id,
                 p_start_date => ie.start_date,
                 p_status => ie.status, 
                 p_afterhours => wds.afterhours)
            INTO v_status FROM insp_extra ie inner  join wa_daily_schedules wds on ie.inspection_id = wds.inspection_id 
            WHERE ie.inspection_id = p_inspection_id and ie.id = p_extra_id;
        ELSE
            v_status := p_extra_status;
        END IF;
    END IF;

    IF v_status <> 'VERIFIED' AND v_extra_status <> 'VERIFIED' THEN
        RETURN 'N';
    END IF;



    FOR rec in (select woti.work_order_item_id, doc_id, tid.doc_type from work_order_tender_items woti
                inner join def_tender_item_doc tid on woti.tender_item_id = tid.tender_item_id 

                inner join wo_docs wd on wd.work_order_item_id = woti.work_order_item_id and wd.content_type = tid.doc_type 
                    and (wd.content_type =  p_doc_type  or p_doc_type is null) and (tid.doc_type = p_doc_type or p_doc_type is null)
                where woti.inspection_id = p_inspection_id 
                      and ( (p_extra_id is null and woti.extra_id is null) or (p_extra_id is not null and woti.extra_id = p_extra_id))                      
                      and (p_work_order_item_id is null or woti.work_order_item_id = p_work_order_item_id)                       
                      and (p_doc_type is null or tid.doc_type = p_doc_type) 
                )      
    loop
        if rec.doc_id is not null and dcs_wpm_general_pck.is_item_doc_approved(rec.work_order_item_id,rec.doc_type) is null then
            return 'Y';
        end if;
    end loop;

    return 'N';
  END item_doc_pending_approval;

    PROCEDURE isScheduleExisting (
        p_schedule_date             IN DATE,
        p_contract_code             IN VARCHAR2 DEFAULT NULL,
        p_group_id                  IN NUMBER DEFAULT NULL,
        p_schedule_id               OUT NUMBER,
        p_wa_included               OUT VARCHAR2
    ) IS
        v_cnt NUMBER := 0;
    BEGIN
        p_wa_included := 'N';
        p_schedule_id := NULL;
        IF p_contract_code IS NOT NULL OR p_group_id IS NOT NULL THEN
            SELECT DISTINCT schedule_id 
            INTO p_schedule_id 
            FROM WA_DAILY_SCHEDULES wds 
            INNER JOIN WO_GROUPS wg 
            ON wds.GROUP_ID=wg.GROUP_ID 
            WHERE ((p_contract_code IS NOT NULL AND wg.CONTRACT_CODE=p_contract_code) OR 
                   (p_group_id IS NOT NULL AND wg.group_id IN (select group_id from wo_groups where contract_code = ( select contract_code from wo_groups where group_id = p_group_id ))))
                AND trunc(wds.SCHEDULE_DATE)=trunc(p_SCHEDULE_DATE);
        END IF;
        IF p_group_id IS NOT NULL AND p_schedule_id IS NOT NULL THEN
            SELECT count(*) INTO v_cnt FROM WA_DAILY_SCHEDULES WHERE schedule_id=p_schedule_id AND group_id=p_group_id; 
        END IF;
        IF v_cnt>0 THEN 
            p_wa_included := 'Y';
        ELSE
            p_wa_included := 'N';
        END IF;
        EXCEPTION
           WHEN no_data_found THEN
                NULL;
           WHEN OTHERS THEN
            apex_error.add_error(p_message => 'isScheduleExisting' || CHR(10)
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);
    END;



 PROCEDURE update_extra_labour AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        UPDATE INSP_EXTRA_LABOUR SET HRS=v_x2, CLASSIFICATION=v_x3 WHERE ID=v_x1;
        COMMIT;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_extra_labour;

  PROCEDURE update_extra_eqmt AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_x4       VARCHAR2(300);
        v_x5       VARCHAR2(300);
        v_x6       VARCHAR2(300);
        v_x7       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        v_x5 := apex_application.g_x05;
        v_x6 := apex_application.g_x06;
        v_x7 := apex_application.g_x07;
        UPDATE INSP_EXTRA_EQMT SET WORKED_HRS=v_x2, STANDBY_HRS=v_x3, TOTAL_HRS=v_x4, OPS127_NO=v_x5, DESCRIPTION=v_x6, OWNERSHIP=v_x7 WHERE ID=v_x1;
        COMMIT;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_extra_eqmt;

 PROCEDURE update_extra_materials AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_x4       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        UPDATE INSP_EXTRA_MATERIALS SET QTY=v_x2, TYPE=v_x3, UNIT=v_x4 WHERE ID=v_x1;
        COMMIT;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_extra_materials;

 PROCEDURE update_extra_subcontracted AS
        v_x1       VARCHAR2(300);
        v_x2       VARCHAR2(300);
        v_x3       VARCHAR2(300);
        v_x4       VARCHAR2(300);
        v_retval   VARCHAR2(300);
    BEGIN
        v_x1 := apex_application.g_x01;
        v_x2 := apex_application.g_x02;
        v_x3 := apex_application.g_x03;
        v_x4 := apex_application.g_x04;
        UPDATE INSP_EXTRA_SUBCONTRACTED SET HRS=v_x2, SUBCONTRACTOR=v_x3, DESCRIPTION=v_x4 WHERE ID=v_x1;
        COMMIT;

        v_retval := 'OK';
        htp.p(v_retval);
    EXCEPTION
        WHEN OTHERS THEN
            v_retval := sqlerrm;
            htp.p(v_retval);
    END update_extra_subcontracted;


    function isMemberBeingUsedByCrew (
        p_in_mem_id   varchar2,
        p_in_mem_type varchar2
    ) return varchar2
    is

        v_crew_name varchar2(200) := null;

    begin

        select CREW_NAME into v_crew_name 
        from insp_crew_members 
        inner join def_crew
        on insp_crew_members.crew_id = def_crew.id
        where MEMBER_TYPE = p_in_mem_type 
        and MEMBER_ID = p_in_mem_id
        and rownum < 2;



        return v_crew_name;

    exception
        when no_data_found then
          return null;


    end isMemberBeingUsedByCrew;


-------------------------------------------------------------
-- function getHelpInfo
-------------------------------------------------------------     
    procedure getHelpInfo
    is
        v_retval   varchar2(2000);
        v_retval_1 varchar2(2000);

        v_hlp_key varchar2(100);

        v_title varchar2(100);
        v_desc  varchar2(4000);

        subloop_cnt int := 0;

    begin

        v_hlp_key := apex_application.g_x01;

        select name, description into v_title, v_desc from sys_help where help_key = v_hlp_key and seq = -1;


        v_title := REPLACE(REPLACE(REGEXP_REPLACE(v_title, '([/\|"])', '\\\1', 1, 0), chr(9), '\t'), chr(10), '\n') ;
        v_desc  := REPLACE(REPLACE(REGEXP_REPLACE(v_desc, '([/\|"])', '\\\1', 1, 0), chr(9), '\t'), chr(10), '\n') ;

        v_retval := '[';
        v_retval := v_retval || '{"title":"' || v_title || '","desc":"' || v_desc || '",';
        v_retval := v_retval || '"sub_key":[';

        for rec in (

            select name, description from sys_help where help_key = v_hlp_key and seq <> -1 order by seq desc

        ) loop

            subloop_cnt := subloop_cnt + 1;

            v_title := REPLACE(REPLACE(REGEXP_REPLACE(rec.name, '([/\|"])', '\\\1', 1, 0), chr(9), '\t'), chr(10), '\n') ;
            v_desc  := REPLACE(REPLACE(REGEXP_REPLACE(rec.description, '([/\|"])', '\\\1', 1, 0), chr(9), '\t'), chr(10), '\n') ;

            v_retval_1 := '{"title":"' || v_title || '","desc":"' || v_desc || '"}'; 


            IF subloop_cnt = 1 THEN
                v_retval := v_retval || v_retval_1;  
            else
                v_retval := v_retval || ',' || v_retval_1;
            end if;

        end loop;

        v_retval := v_retval || ']}';
        v_retval := v_retval || ']';

        /*
        Use in Debug 
        v_retval := '[';

        v_retval := v_retval || '{"title":"v_title","desc":"v_desc",';

        v_retval := v_retval || '"sub_key":[';
        v_retval := v_retval || '{"title":"v_title1","desc":"v_desc1"}';
        v_retval := v_retval || ']}';

        v_retval := v_retval || ']';
        */

        htp.p(v_retval);  

        return;

    exception
        when others then

          v_retval := '[{"title":"' || v_hlp_key || '"}]';
          htp.p(v_retval);  

          return;

    end getHelpInfo;




-------------------------------------------------------------   
    function startDate_Cut_Category_WA (
        f_wa_num            number,
        f_cut_category_code varchar2
    ) return timestamp
    is
        v_ret   TIMESTAMP;
        v_ret_1 TIMESTAMP;
    begin

        -- find out the minimum work_date in work order item

        begin

            select
                min( item.work_date )
                into v_ret

            from work_order_tender_items item
            inner join tender_items 
            on item.tender_item_id = tender_items.tender_item_id
            inner join ref_pr_resttype
            on tender_items.RESTTYPE_CODE = ref_pr_resttype.RESTTYPE_CODE
            inner join ref_cut_category
            on ref_cut_category.CODE = ref_pr_resttype.CATEGORY_CODE

            where item.group_id = f_wa_num
            and ref_cut_category.code = f_cut_category_code
            -- Added on Mar 25, 2020
            and instr( lower(tender_items.cut_stage), 'start' ) > 0

            ;

        exception
            when no_data_found then
                v_ret := null;
        end;

        -- find out the minimum start_date in any inspection for work order item
        begin

            select
                min( insp_inspections.START_DATE )
                into v_ret_1

            from work_order_tender_items item
            inner join tender_items 
            on item.tender_item_id = tender_items.tender_item_id
            inner join ref_pr_resttype
            on tender_items.RESTTYPE_CODE = ref_pr_resttype.RESTTYPE_CODE
            inner join ref_cut_category
            on ref_cut_category.CODE = ref_pr_resttype.CATEGORY_CODE

            inner join insp_inspections
            on insp_inspections.group_id = item.group_id
            and item.inspection_id = insp_inspections.inspection_id

            where item.group_id = f_wa_num
            and ref_cut_category.code = f_cut_category_code
            -- Added on Mar 25, 2020
            and instr( lower(tender_items.cut_stage), 'start' ) > 0

            ;

        exception
            when no_data_found then
                v_ret_1 := null;
        end;

        if v_ret is null and v_ret_1 is null then
            return null;
        elsif v_ret is null then
            return v_ret_1;
        elsif v_ret_1 is null then
            return v_ret;
        elsif v_ret >= v_ret_1 then
            return v_ret_1;
        else
            return v_ret;
        end if;

    end startDate_Cut_Category_WA;



------------------------------------------------
-- get_wa_cut_types
------------------------------------------------      
    FUNCTION get_wa_remain_cut_types (
        p_group_id wo_groups.group_id%TYPE
    ) RETURN VARCHAR2
    IS
      v_cut_types varchar2(2000) := null;
    BEGIN
        select regexp_replace( LISTAGG( wo_pr_polygon.resttype_code, ',' ) WITHIN GROUP (ORDER BY wo_pr_polygon.resttype_code),'([^,]+)(,\1)*(,|$)', '\1\3') cut_types into v_cut_types
        from wo_pr_polygon
        left join 
        (
            select distinct resttype_code 
            from work_order_tender_items 
            inner join tender_items
            on tender_items.tender_item_id = work_order_tender_items.tender_item_id
            where group_id = p_group_id
        ) items
        on wo_pr_polygon.resttype_code = items.resttype_code
        where wo_pr_polygon.group_id=p_group_id
        and items.resttype_code is null;

        return v_cut_types;
    END get_wa_remain_cut_types;



------------------------------------------------
-- getWAStatus
------------------------------------------------       
    FUNCTION get_wa_post_status (
        p_group_id wo_groups.group_id%type,
        p_notified wo_groups.notified%type,
        p_status wo_groups.status%type,
        p_schedule_id number
    ) return varchar2 
	as

        v_po_status varchar2(20);
        v_cnt int;
        v_is_onhold varchar2(1) := 'N';

    begin

        case p_status
            when 'COMPLETED' then
                v_po_status := p_status;
            when 'NEW' then
                if p_schedule_id is not null then
                    v_po_status := 'IN PROGRESS';
                else
                    if p_notified = 'Y' then
                        v_po_status := 'NOTIFIED';
                    else
                        v_po_status := 'OUTSTANDING';
                    end if;
                end if;
            else
                v_po_status := NULL;
        end case;   

		return v_po_status;     



    end get_wa_post_status; 


   --Used on page 310(Resufacing Region and Submit New Tender Item) and 634(Submit New Tender Item)
   --1. Bottom cut and its additional cost 2. Top cut to its Bottom cut  
    procedure add_addtional_item_to_base (
        p_submission_seq number,
        p_contract_code varchar,
        p_approved varchar2 default null
        ) is
    v_tender_item_id varchar2(20);
    v_tender_item_id_additional varchar2(20):=null;
    v_cut_stage varchar2(20);
    v_standard_depth number;

    cursor c_tender_items is
      select cut_stage, standard_depth
      from tender_items
      where tender_item_id=v_tender_item_id;

    cursor c_woti is
      select * from work_order_tender_items where submission_seq=P_SUBMISSION_SEQ AND parent_work_order_item_id is null for update;

    cursor c_woti_finish is
      select * from work_order_tender_items where submission_seq=P_SUBMISSION_SEQ AND parent_work_order_item_id is not null;
  begin
    --cut bottom and addtional cost item
    for c in c_woti loop
      v_tender_item_id := c.tender_item_id;

      for c1 in c_tender_items loop
        v_cut_stage := c1.cut_stage;
        v_standard_depth := nvl(c1.standard_depth,0);
      end loop;

      select add_on_id
      into v_tender_item_id_additional
      from tender_item_addons
      where tender_item_id=c.tender_item_id and extended_base_flag='Y';

      --if v_cut_stage='Start' and nvl(c.depth,0)>pr_package.base_depth and v_tender_item_id_additional is not null then
      if v_cut_stage='Start' and v_tender_item_id_additional is not null then
          /*insert into work_order_tender_items(tender_item_id, quantity,length, width, depth, group_id, submission_seq, inspection_id,parent_work_order_item_id, approved, approved_by, approved_date)
          values (v_tender_item_id_additional, round(c.length*c.width*least(c.depth-pr_package.base_depth, pr_package.extended_base_depth)/1000,2), c.length, c.width, least(c.depth-pr_package.base_depth, pr_package.extended_base_depth), c.group_id, c.submission_seq, c.inspection_id, c.work_order_item_id, p_approved, decode(p_approved, null, null, v('APP_USER')),decode(p_approved, null, null, sysdate));*/
          if nvl(c.depth,0)>v_standard_depth then
            insert into work_order_tender_items(tender_item_id, quantity,length, width, depth, group_id, submission_seq, inspection_id,parent_work_order_item_id, approved, approved_by, approved_date, add_on_to)
            values (v_tender_item_id_additional, round(c.quantity*(c.depth-v_standard_depth)/1000,2), c.length, c.width, c.depth-v_standard_depth, c.group_id, c.submission_seq, c.inspection_id, c.work_order_item_id, p_approved, decode(p_approved, null, null, v('APP_USER')),decode(p_approved, null, null, sysdate), c.work_order_item_id);
          end if;
          update work_order_tender_items set parent_work_order_item_id=work_order_item_id where current of c_woti;
      end if;
    end loop;

    --Assign parent cut bottom item's parent_work_order_item_id to itself
    /*for c in c_woti_finish loop
      update work_order_tender_items set parent_work_order_item_id=work_order_item_id where parent_work_order_item_id is null and work_order_item_id=c.parent_work_order_item_id;
    end loop;*/

    EXCEPTION
        WHEN NO_DATA_FOUND THEN
           RETURN;
        WHEN OTHERS THEN
            apex_error.add_error(p_message => 'ADD_ADDITIONAL_ITEM_TO_BASE'
            || sqlcode
            || ' - '
            || sqlerrm,p_display_location => apex_error.c_inline_in_notification);

            RETURN;


  end add_addtional_item_to_base;    

 --------------------------------------------------------
 -- set_cut_cat_start_date_status
 --------------------------------------------------------
  procedure set_cut_cat_start_date_status(
        p_inspection_id number default null,
        p_group_id      number default null,
        p_category_code number default null
    )
    is
        v_group_id          number;
        v_cut_types         varchar2(1000);
        v_cut_category_code number;
    begin

        if p_inspection_id is null and p_group_id is null then        
            raise_application_error( -20000, 'At least p_group_id or p_group_id is not null !' );
        end if;

        if p_group_id is not null then
            v_group_id := p_group_id;
        else

            select wg.group_id into v_group_id from wo_groups wg
                           inner join insp_inspections insp
                           on wg.group_id = insp.group_id
                where insp.inspection_id = p_inspection_id;

         end if;
/*
        select regexp_replace( LISTAGG( wpp.resttype_code, ',' ) WITHIN GROUP (ORDER BY wpp.resttype_code),'([^,]+)(,\1)*(,|$)', '\1\3') 
        into v_cut_types
              from wo_groups mwg
              left join wo_pr_polygon wpp
              on mwg.group_id = wpp.group_id
         group by mwg.group_id 
         having mwg.group_id = v_group_id;
      */    

        -- bulk process for start date and in-progress status
        /*
            - when the first item in the category submitted, set the start date 
              for the category in wo_group, and status for the category as in-progress
        */
        for rec in (

             select ref_pr_resttype.category_code, min( insp.start_date ) min_insp_start_date
             from work_order_tender_items items
             inner join insp_inspections insp
             on insp.inspection_id = items.inspection_id
             and insp.group_id = items.group_id
         --    and insp.inspection_id = p_inspection_id
             inner join tender_items 
             on tender_items.tender_item_id = items.tender_item_id
             inner join ( select resttype_code, group_id from wo_pr_polygon where group_id = v_group_id ) polygon
             on polygon.group_id = items.group_id
             and polygon.resttype_code = tender_items.resttype_code
             inner join ref_pr_resttype
             on ref_pr_resttype.resttype_code = tender_items.resttype_code
             where items.quantity > 0
             and items.group_id = v_group_id

             group by ref_pr_resttype.category_code

        ) loop

            -- set start-date column if it is not null
            update wo_groups 
                set cut_cat_1_start_date = rec.min_insp_start_date,
                    cut_cat_1_status = 'IN-PROGRESS'
                where -- cut_cat_1_start_date is null 
              --  and 
                ( 
                    ( p_category_code is null and rec.category_code = 1 )
                    or
                    ( p_category_code is not null and rec.category_code = 1 and rec.category_code = p_category_code )
                )
                and group_id = v_group_id
                ; 

            update wo_groups 
                set cut_cat_2_start_date = rec.min_insp_start_date,
                    cut_cat_2_status = 'IN-PROGRESS'
                where -- cut_cat_2_start_date is null 
             --   and 
                ( 
                    ( p_category_code is null and rec.category_code = 2 )
                    or
                    ( p_category_code is not null and rec.category_code = 2 and rec.category_code = p_category_code )
                )
                and group_id = v_group_id
                ;


        end loop;

        -- bulk process for finished status
        /*
            - if the cat status is not already 'finish',  calculate if there is at least one 
             finish stage item submitted to each estimated cut type (by polygon table) in the 
             category, if yes, set the cat status as 'finish'
        */
        for rec in (



        select 
            a.category_code, a.total_cut_types, b.finished_cut_type_cnt           
        from
        (
            select
                category_code, count(*) total_cut_types
            from
            (
                 select distinct ref_pr_resttype.category_code, ref_pr_resttype.resttype_code 
                    from wo_pr_polygon 
                    inner join ref_pr_resttype
                    on ref_pr_resttype.resttype_code = wo_pr_polygon.resttype_code

                    where group_id = v_group_id

            )
            group by category_code
        ) a

        left join                
        (
            select
                category_code, count(*) finished_cut_type_cnt
            from
            (
                select ref_pr_resttype.category_code, wo_pr_polygon.resttype_code, count(*) cnt
                 from work_order_tender_items items

         --        inner join insp_inspections insp
          --       on insp.inspection_id = items.inspection_id
        --         and insp.group_id = items.group_id
             --    and insp.inspection_id = p_inspection_id

                 inner join tender_items 
                 on tender_items.tender_item_id = items.tender_item_id
                 inner join wo_pr_polygon
                 on wo_pr_polygon.resttype_code = tender_items.resttype_code
                 and wo_pr_polygon.group_id = items.group_id
                 inner join ref_pr_resttype
                 on ref_pr_resttype.resttype_code = tender_items.resttype_code
                 where items.quantity > 0
                 and upper( tender_items.cut_stage ) = 'FINISH'
                 and items.group_id = v_group_id

                 group by ref_pr_resttype.category_code, wo_pr_polygon.resttype_code
             )
             group by category_code

        ) b
        on a.category_code = b.category_code
        where a.total_cut_types = b.finished_cut_type_cnt


        ) loop

            -- set finish status 
            update wo_groups 
                set cut_cat_1_status = 'FINISH'
                where 
                ( 
                    ( p_category_code is null and rec.category_code = 1 )
                    or
                    ( p_category_code is not null and rec.category_code = 1 and rec.category_code = p_category_code )
                )
                and group_id = v_group_id
                ;

            update wo_groups 
                set cut_cat_2_status = 'FINISH'
                where
                ( 
                    ( p_category_code is null and rec.category_code = 2 )
                    or
                    ( p_category_code is not null and rec.category_code = 2 and rec.category_code = p_category_code )
                )
                and group_id = v_group_id
                ;          

        end loop;


    end set_cut_cat_start_date_status;

 --------------------------------------------------------
 -- is_old_pr
 --------------------------------------------------------
    function is_old_pr(
        f_contract_code number default null,
        f_group_id      number default null,
        f_inspection_id number default null
    ) return varchar2
    is
       v_ret varchar2(100) := null;
       v_cnt int;
    begin

        if ( f_contract_code is null and f_group_id is null and f_inspection_id is not null ) 
           or
           ( f_contract_code is null and f_group_id is not null and f_inspection_id is null ) 
           or
           ( f_contract_code is not null and f_group_id is null and f_inspection_id is null ) 
        then
            if f_contract_code is not null then

                select count(*) into v_cnt from contracts inner join v_contracts_for_insp 
                    on contracts.project_code = v_contracts_for_insp.project_code
                    and contract_group = 'PR19'
                    and contracts.contract_code = f_contract_code;

            elsif f_group_id is not null then

                select count(*) into v_cnt from contracts inner join v_contracts_for_insp 
                    on contracts.project_code = v_contracts_for_insp.project_code
                    and contract_group = 'PR19'
                    inner join wo_groups 
                    on contracts.contract_code = wo_groups.contract_code

                    where wo_groups.group_id = f_group_id;

            elsif f_inspection_id is not null then

                select count(*) into v_cnt from contracts inner join v_contracts_for_insp 
                    on contracts.project_code = v_contracts_for_insp.project_code
                    and contract_group = 'PR19'
                    inner join wo_groups 
                    on contracts.contract_code = wo_groups.contract_code
                    inner join insp_inspections 
                    on insp_inspections.group_id = wo_groups.group_id
                    where insp_inspections.inspection_id = f_inspection_id;

            end if;

            select 
                case when v_cnt > 0
                     then 'Y'
                     else 'N'
                end

            into v_ret 
            from dual;


        else
            v_ret := 'N/A';
        end if;

        return v_ret;

    end is_old_pr;

    /*function get_paired_work_tender_item(
  p_work_order_item_id_from work_order_tender_items.work_order_item_id%type,
  p_item_type_to varchar2 default 'top_base' --extra_depth, top_base
  ) return work_order_tender_items.work_order_item_id%type as
  v_work_order_item_id work_order_tender_items.work_order_item_id%type;
  begin

    for rec in (select wi.work_order_item_id,wi.parent_work_order_item_id,
                        ti.tender_item_id, ti.cref_tender_item_id, ti.cut_stage, 
                        ta.add_on_id, ta.extended_base_flag 
                from work_order_tender_items wi
                inner join tender_items ti on ti.tender_item_id = wi.tender_item_id 
                left outer join tender_item_addons ta on ta.tender_item_id = ti.tender_item_id
                where wi.work_order_item_id = p_work_order_item_id_from)
        loop
            case p_item_type_to
            when 'extra_depth' then 
                if rec.extended_base_flag is null then 
                    return null;
                else 
                    select work_order_item_id into v_work_order_item_id
                    from work_order_tender_items wi 
                    where wi.parent_work_order_item_id = rec.work_order_item_id
                        and wi.tender_item_id = rec.add_on_id ;
                    return v_work_order_item_id ;
                end if;
             else 
                if rec.extended_base_flag is not null then 
                    return rec.parent_work_order_item_id;
                end if;
                if rec.cref_tender_item_id is not null then
                    return rec.parent_work_order_item_id;
                end if;
                if rec.cref_tender_item_id is null and lower(rec.cut_stage) = 'start' then
                    select work_order_item_id into v_work_order_item_id from work_order_tender_items wi
                    inner join tender_items ti on wi.tender_item_id = ti.tender_item_id
                    where wi.parent_work_order_item_id = rec.work_order_item_id and 
                          ti.cref_tender_item_id = rec.tender_item_id;
                    return v_work_order_item_id ;
                end if;
             end case;
        end loop;

        return null;

        exception when no_data_found then
            return null;


  end get_paired_work_tender_item;*/

    function get_paired_work_tender_item(
  p_work_order_item_id_from work_order_tender_items.work_order_item_id%type,
  p_item_type_to varchar2 default 'top_base' --extra_depth, top_base
  ) return work_order_tender_items.work_order_item_id%type as
  v_work_order_item_id work_order_tender_items.work_order_item_id%type;
  begin

    for rec in (select wi.work_order_item_id,wi.parent_work_order_item_id,
                        ti.tender_item_id, ti.cref_tender_item_id, ti.cut_stage, 
                        ta.add_on_id, ta.extended_base_flag 
                from work_order_tender_items wi
                inner join tender_items ti on ti.tender_item_id = wi.tender_item_id 
                left outer join tender_item_addons ta on ta.tender_item_id = ti.tender_item_id
                where wi.work_order_item_id = p_work_order_item_id_from)
        loop
            case p_item_type_to
            when 'extra_depth' then 
                if rec.extended_base_flag is null then 
                    return rec.parent_work_order_item_id;
                else 
                    select work_order_item_id into v_work_order_item_id
                    from work_order_tender_items wi 
                    where wi.parent_work_order_item_id = rec.work_order_item_id
                        and wi.tender_item_id = rec.add_on_id ;
                    return v_work_order_item_id ;
                end if;
             else 
                if rec.cref_tender_item_id is not null then
                    return rec.parent_work_order_item_id;
                end if;
                if rec.cref_tender_item_id is null and lower(rec.cut_stage) = 'start' then
                    select work_order_item_id into v_work_order_item_id from work_order_tender_items wi
                    inner join tender_items ti on wi.tender_item_id = ti.tender_item_id
                    where wi.parent_work_order_item_id = rec.work_order_item_id and 
                          ti.cref_tender_item_id = rec.tender_item_id;
                    return v_work_order_item_id ;
                end if;
             end case;
        end loop;

        return null;

        exception when no_data_found then
            return null;


  end get_paired_work_tender_item;

  function get_item_status(
  p_work_order_item_id work_order_tender_items.work_order_item_id%type 
  ) return varchar2 as
  v_status varchar2(20);
  begin

    select approved into v_status from work_order_tender_items where work_order_item_id =   p_work_order_item_id;
    return v_status;
    exception when no_data_found then
            return null;
  end get_item_status;


  function is_inspect_item_allowed(
  p_work_order_item_id work_order_tender_items.work_order_item_id%type ,
  p_action varchar2 
  ) return varchar2 as
  v_paired_work_item_id work_order_tender_items.work_order_item_id%type ;
  v_status varchar2(10);
  begin

        v_paired_work_item_id := get_paired_work_tender_item(p_work_order_item_id);

        if v_paired_work_item_id is null then 
            return 'Y'; 
        end if;

        v_status := get_item_status (v_paired_work_item_id);


        case 
            when upper(v_status) = 'Y' and upper(p_action) = 'APPROVE'  then return 'Y';
            when upper(v_status) = 'N' and upper(p_action) = 'REJECT' then return 'Y';
            when v_status is null then return 'Y';
            else return get_alert_msg(v_status,p_action);
        end case;

  end is_inspect_item_allowed;

  function get_alert_msg(
  p_status varchar2,
  p_action varchar2 
  ) return varchar2 as
  begin

    case
    when upper(p_status) = 'N' and upper(p_action) = 'APPROVE' then
        return 'The corresponding base/top item has been rejected, you cannot approve this item.';
    when upper(p_status) = 'Y' and upper(p_action) = 'REJECT' then
        return 'The corresponding base/top item has been approved, you cannot reject this item.';
    else 
        return 'You cannot' || p_action || 'this item.';
    end case;
  end get_alert_msg;

  function get_wa_status_from_cat
 (
  p_status in varchar2,
  p_complete_status_approval varchar2,
  p_cut_types in varchar2,
  p_remaining_cut_types in varchar2,
  p_cut_cat_1_status in varchar2,
  p_cut_cat_2_status in varchar2,
  p_start_date_1 in date default null,
  p_start_date_2 in date default null,
  p_dispute_1_cnt in number default null,
  p_upload_1_cnt in number default null,
  p_verify_1_cnt in number default null,
  p_dispute_2_cnt in number default null,
  p_upload_2_cnt in number default null,
  p_verify_2_cnt in number default null,
  p_on_hold in varchar2 default null,
  p_cnt_upload in number default null,
  p_cnt_dispute in number default null
)  return varchar2 as
  v_cat_1_status varchar2(100);
  v_cat_2_status varchar2(100);
  v_cnt number;
BEGIN
   if p_on_hold is not null then
    if p_on_hold = 'Y' then return 'ON-HOLD'; end if;
   end if;

    v_cat_1_status := get_cat_status
  (
   p_cut_types       
  ,p_remaining_cut_types
  ,p_start_date_1
  ,'1'
  ,p_dispute_1_cnt
  ,p_upload_1_cnt
  ,p_verify_1_cnt
  ,p_cut_cat_1_status
  );

   v_cat_2_status := get_cat_status
  (
   p_cut_types      
  ,p_remaining_cut_types
  ,p_start_date_2
  ,'2'
  ,p_dispute_2_cnt
  ,p_upload_2_cnt
  ,p_verify_2_cnt
  ,p_cut_cat_2_status
 );

  select coalesce(p_dispute_1_cnt,0)+ coalesce(p_dispute_2_cnt,0) + coalesce(p_cnt_dispute,0) 
      + coalesce(p_cnt_upload,0) 
      + coalesce(p_verify_1_cnt,0) + coalesce(p_verify_2_cnt,0)
    into v_cnt from dual;
  case
  when upper(p_status) = 'COMPLETED' then

    case when p_complete_status_approval = 'Y' then return 'COMPLETED';
         when p_complete_status_approval is null then return 'COMPLETED';
         when p_complete_status_approval = 'N' then return 'DISPUTE';
         else return NULL;
    end case;

  when upper(p_status) ='NEW' then
     case

        when (lower(v_cat_1_status) = 'complete') and (lower(v_cat_2_status) = 'complete') then
            case when v_cnt  = 0 then return 'COMPLETED';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'COMPLETE';
            end case;

        when  ( (lower(v_cat_1_status) = 'complete' and v_cat_2_status is null ) 
          or (lower(v_cat_2_status) = 'complete' and v_cat_1_status is null )) then
            case when v_cnt  = 0 then return 'COMPLETED';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'COMPLETE';
            end case;

        --- details
        when (v_cat_1_status is null and v_cat_2_status is null and v_cnt = 0 ) then 
            case when v_cnt  = 0 then return 'OUTSTANDING';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'OUTSTANDING';
            end case;

        when  lower(v_cat_1_status) like '%overdue%'  
        or lower(v_cat_2_status) like '%overdue%'
        or trunc(sysdate,'DD') - trunc(p_start_date_1,'DD')>def_security_admin.get_app_param_value('cms_wa_overdue_days')
        or trunc(sysdate,'DD') - trunc(p_start_date_2,'DD')>def_security_admin.get_app_param_value('cms_wa_overdue_days')
        then return 'OVERDUE' ;

        when (v_cat_1_status is null and v_cat_2_status is null ) then --return 'OUTSTANDING';
            case when v_cnt  = 0 then return 'OUTSTANDING';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'OUTSTANDING';
            end case;


        when (lower(v_cat_1_status) like '%due%' or lower(v_cat_2_status) like '%due%' ) then return 'IN-PROGRESS';

        when (lower(v_cat_1_status) = 'outstanding'  and lower(v_cat_2_status) = 'outstanding' ) then --return 'IN-PROGRESS';
            case when v_cnt  = 0 then return 'OUTSTANDING';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'OUTSTANDING';
            end case;

        when (v_cat_1_status is null and lower(v_cat_2_status) = 'outstanding' ) then --return 'OUTSTANDING';
            case when v_cnt  = 0 then return 'OUTSTANDING';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'OUTSTANDING';
            end case;

        when (v_cat_2_status is null and lower(v_cat_1_status) = 'outstanding' ) then --return 'OUTSTANDING';
            case when v_cnt  = 0 then return 'OUTSTANDING';
                 when v_cnt  > 0 then return 'IN-PROGRESS';
                 else return 'OUTSTANDING';
            end case;


        else return 'IN-PROGRESS';
     end case;
  else return null;
  end case;
END get_wa_status_from_cat;

  function    get_cat_status
(
  p_cut_types           varchar2,
  p_remaining_cut_types varchar2,
  p_cat_start_date      date,
  p_cut_cat_code        varchar2,
  p_dispute_cnt          number default null,
  p_upload_cnt           number default null,
  p_verify_cnt           number default null,
  p_cut_cat_status      varchar2 default null
) return varchar2 as
v_days number;
v_overdue_days number;
v_due_status varchar2(20);
v_cut_cnt number;
v_cat_overdue_days number;  
begin



    if p_cut_cat_code is null then return null; end if;


    if p_cut_types is null then return null; end if;

    for cut_type in (select * from ref_pr_resttype where category_code = p_cut_cat_code and status ='A') 
    loop
        if instr(p_cut_types, cut_type.resttype_code)>0 then 
            v_cut_cnt :=1; 
            exit;
        end if;
    end loop;

    if p_cat_start_date is null then   

        --if p_cut_types  = p_remaining_cut_types then return 'outstanding'; end if;
       if v_cut_cnt > 0 then return 'outstanding'; end if;


    end if;

    if p_cat_start_date is not null then

        if upper(p_cut_cat_status) = 'FINISH' then  --(both start and finish stage items submitted) 
            if (p_dispute_cnt =0 or p_dispute_cnt is null) 
            and ( p_upload_cnt = 0 or p_upload_cnt is null)
            --and ( p_verify_cnt =0 or p_verify_cnt is null) 
            then
                    return 'complete'; 
            end if;

        end if;

        v_overdue_days := DEF_SECURITY_ADMIN.get_app_param_value(
                                                p_param_name => 'cms_cut_category_' ||  p_cut_cat_code  || '_overdue_days'
                                            );

        v_days := trunc(sysdate,'DD') - trunc(p_cat_start_date,'DD') ;  



        if p_cut_cat_code = '1' then 
            v_cat_overdue_days := def_security_admin.get_app_param_value('cms_cut_category_1_overdue_days');
        end if;

        if p_cut_cat_code = '2' then 
            v_cat_overdue_days := def_security_admin.get_app_param_value('cms_cut_category_2_overdue_days');
        end if;

        case 
        when v_days = v_cat_overdue_days then 
            v_due_status := 'Due Today';
        when v_days > v_cat_overdue_days then 
            v_days := v_days - v_overdue_days;
            v_due_status := 'Overdue '||v_days;
        when v_days < v_cat_overdue_days then 
            v_days :=  v_overdue_days - v_days ;
            v_due_status := 'Due in '||v_days;
        else v_days := null;
        end case;
        return v_due_status;

    end if;

    return null;
  END get_cat_status;

  function get_contract_code(manipulated_contract_name varchar2) return varchar2 AS
    v_contract_code varchar2(20);
  begin
    WITH v_active_contracts as
    (
   select contract_code, project_code, rownum, 'Contract'||trim(rownum) as contract_name
from 
(
select * from contracts
where contract_type='PERM RESTORATION' and status='A' 
order by contract_code
)
    )
    select contract_code into v_contract_code from v_active_contracts where contract_name=manipulated_contract_name;
    return v_contract_code;
  end;

  function get_project_code(manipulated_contract_name varchar2) return varchar2 AS
    v_project_code varchar2(20);
  begin
    WITH v_active_contracts as
    (
select contract_code, project_code, rownum, 'Contract'||trim(rownum) as contract_name
from 
(
select * from contracts
where contract_type='PERM RESTORATION' and status='A' 
order by contract_code
)
    )
    select project_code into v_project_code from v_active_contracts where contract_name=manipulated_contract_name;
    return v_project_code;
  end;

  PROCEDURE sync_bte_items(
    p_work_order_item_id NUMBER) AS

   v_bottom_tender_item_id number;
   v_add_on_id number;
   v_exist varchar(1) := 'N';

   cursor cur_bottom_item is
        select woti.*, ti.standard_depth  
        from work_order_tender_items woti
        inner join tender_items ti
        on woti.tender_item_id=ti.tender_item_id
        where work_order_item_id=p_work_order_item_id and
              work_order_item_id=parent_work_order_item_id;

      cursor cur_top_item is
        select woti.*
        from work_order_tender_items woti
        inner join tender_items ti
        on woti.tender_item_id=ti.tender_item_id and 
           ti.cref_tender_item_id=v_bottom_tender_item_id
        where woti.parent_work_order_item_id=p_work_order_item_id and
              woti.work_order_item_id <> woti.parent_work_order_item_id
        for update;

      cursor cur_extended_item is
        select woti.*
        from work_order_tender_items woti
        inner join tender_items ti
        on woti.tender_item_id=ti.tender_item_id
        inner join tender_item_addons tia
        on tia.tender_item_id=v_bottom_tender_item_id
          and tia.add_on_id=ti.tender_item_id
          and extended_base_flag='Y'
        where woti.parent_work_order_item_id=p_work_order_item_id and
              woti.work_order_item_id <> woti.parent_work_order_item_id;

    BEGIN
        for c in cur_bottom_item loop
          v_bottom_tender_item_id := c.tender_item_id;
          for c1 in cur_top_item loop
          --update WORK_ORDER_TENDER_ITEMS set length=to_number(v_x3), width=to_number(v_x4), depth=to_number(v_x5), quantity=round(to_number(v_x3)*to_number(v_x4)*least(to_number(v_x5)-base_depth, extended_base_depth)/1000,2) WHERE WORK_ORDER_ITEM_ID=v_work_order_item_id;
            IF NVL(c.quantity,0)<>NVL(c1.quantity,0) OR NVL(c.length,0)<>NVL(c1.length,0) OR NVL(c.width,0)<>NVL(c1.width,0) THEN
              update WORK_ORDER_TENDER_ITEMS set length=c.length, width=c.width, quantity=c.quantity WHERE current of cur_top_item;
            END IF;
          end loop;
        end loop;  

        for c in cur_bottom_item loop            
          v_bottom_tender_item_id := c.tender_item_id;
          select add_on_id into v_add_on_id from tender_item_addons where tender_item_id=c.tender_item_id and extended_base_flag='Y';

          if c.depth-c.standard_depth<=0 then
              delete from work_order_tender_items where tender_item_id=v_add_on_id and parent_work_order_item_id=p_work_order_item_id;
          else
            for c1 in cur_extended_item loop
              v_exist := 'Y';
              IF NVL(c.quantity,0)<>NVL(c1.quantity,0) OR NVL(c.length,0)<>NVL(c1.length,0) OR NVL(c.width,0)<>NVL(c1.width,0) OR c1.depth<>(c.depth-c.standard_depth) THEN
                update WORK_ORDER_TENDER_ITEMS set length=c.length, width=c.width, depth=c.depth-c.standard_depth, quantity=round(c.quantity*(c.depth-c.standard_depth)/1000,2) WHERE tender_item_id=v_add_on_id and parent_work_order_item_id=p_work_order_item_id;
              END IF;
            end loop;
            if v_exist='N' and c.depth-c.standard_depth>0 then
              --select add_on_id into v_add_on_id from tender_item_addons where tender_item_id=c.tender_item_id and extended_base_flag='Y';
              insert into work_order_tender_items(tender_item_id, quantity,length, width, depth, group_id, inspection_id, parent_work_order_item_id, add_on_to) 
              values (v_add_on_id, round(c.quantity*(c.depth-c.standard_depth)/1000,2), c.length, c.width, c.depth-c.standard_depth, c.group_id, c.inspection_id, p_work_order_item_id, p_work_order_item_id);
            end if;
          end if;
        end loop;  
    EXCEPTION
        WHEN OTHERS THEN
            htp.p(sqlerrm);
    END sync_bte_items;


  function get_cut_id(p_group_id IN number) return number is
    v_cut_id number(2);
  begin
    select nvl(min(cut_id),0) into v_cut_id from wo_pr_polygon where group_id=p_group_id and objectid=-1;
    return v_cut_id;
  end;

  function show_add_cuts(p_group_id IN number) return boolean is
    v_ret number;
  begin
    select count(*) into v_ret from wo_pr_polygon where group_id=p_group_id and cut_id>0; 
    return (v_ret<1);
  end;

------------------------------------------------
-- load_insp_crew
--   This will be the background process triggered when contractor 
--   schedules inspection with work assingments and crews,
--   or, this happens when inspector admin assign
--   inspector
------------------------------------------------      
    procedure load_insp_crew(
        p_insp_id       number,
        p_crew_id       number default null,
        p_contractor_id number default null
    )
    is
    begin

        -- First , populate insp_labour and insp_eqmt
        for rec in (

                select member_id, member_type
                    from insp_crew_members 
                    where crew_id = p_crew_id 

        ) loop

            if rec.member_type = 'labour' then

                insert into insp_labour ( inspection_id, labour_name, labour_id, crew_id )
                  select p_insp_id, labour_name, rec.member_id, p_crew_id
                      from def_labour 
                      where id = rec.member_id
                      -- actually, this is not necessary because id is already the primary key
                      and contractor_id = p_contractor_id;


            elsif rec.member_type = 'equipment' then

                insert into insp_eqmt ( inspection_id, eqmt_name, eqmt_id, crew_id)
                      select p_insp_id, eqmt_name, rec.member_id, p_crew_id
                          from def_eqmt 
                          where id = rec.member_id
                          -- actually, this is not necessary because id is already the primary key
                          and contractor_id = p_contractor_id;

            end if;

        end loop;


        -- secondly, populate insp_crew
        insert into insp_crew ( inspection_id, crew_name, crew_id )
            select p_insp_id, crew_name, p_crew_id
                from def_crew
                where id = p_crew_id and contractor_id = p_contractor_id;

    end load_insp_crew;

   FUNCTION GET_ACTIVITY_DESC(
        P_ACTCODE IN VARCHAR2,
        P_ACTGROUP IN VARCHAR2 
    ) RETURN VARCHAR2 AS 
    V_ACTDESC VARCHAR2(200);
    BEGIN
        SELECT ACTDESC INTO V_ACTDESC FROM REF_ACTIVITY_DESC WHERE ACTCODE= P_ACTCODE AND ACTGROUP=P_ACTGROUP;
        RETURN V_ACTDESC;
        EXCEPTION WHEN NO_DATA_FOUND THEN
        RETURN NULL;
    END GET_ACTIVITY_DESC;
    
    function isSche_in_GracePeriod(
        p_schedule_date             IN DATE,
        p_afterhours                IN VARCHAR2,
        p_inspector_assigned_date   IN DATE
    ) return varchar2
    is
        retval varchar2(1) := 'N';
    begin

        if (
                ( p_inspector_assigned_date + 1 < SYSDATE AND trunc(p_inspector_assigned_date,'DD') = trunc(p_schedule_date,'DD') )
                or
                ( ( p_afterhours = 'Y' AND p_schedule_date + 2 < SYSDATE ) OR ( p_afterhours <> 'Y' AND p_schedule_date + 1 < SYSDATE ) )
            )
        then 
            retval := 'Y';
        end if;

        return retval;

    end isSche_in_GracePeriod;
    
    
    --------------------------------------------------------
 -- function get_app_username
 --------------------------------------------------------   
  function get_app_username return varchar2
  is
  begin
  
  
    if trim( v('CURRENT_USERNAME') ) is null or lower( v('CURRENT_USERNAME') ) = 'nobody' then
        return v('APP_USER');
    else
        return v('CURRENT_USERNAME');
    end if;
    
 
  end get_app_username;
 
 --------------------------------------------------------
 -- function init_status_value
 -------------------------------------------------------- 
  function init_status_value (
        f_contract_type varchar2,
        f_contract_code varchar2 default null
    ) return varchar2
    is
    begin
    
        CASE f_contract_type 
         WHEN 'SURVEY ABANDON' THEN
            RETURN 'UNSCHEDULED';
         WHEN 'RESTORATION' THEN
            RETURN 'OUTSTANDING EMERGENCY';
         ELSE
            RETURN 'OUTSTANDING';
        END CASE;
        
    end init_status_value;

END pr_package;
/
