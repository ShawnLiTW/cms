CREATE OR REPLACE PACKAGE       "LOV_PACKAGE" AS 

/*----------------------------------------------------------------------------------------
-- Package Name - LOV_PACKAGE                                  
-- Database - Oracle 11g               
--                                    
-- Created By:  Lisa Situ
-- Created On:  Nov, 2017
-- Last Modified:  
--                                                                                     --
-- Description:                                                                        --
-- This Package contains functions/procedures for dynamic LOVS in CMS app              --
--                                                                                     --
--- Modification history :
--                         Nov, 2017 Created
--                         
-----------------------------------------------------------------------------------------*/

    FUNCTION charge_back_status RETURN VARCHAR2;

    FUNCTION restoration_type RETURN VARCHAR2;

    FUNCTION month_of_year RETURN VARCHAR2;

    FUNCTION month_of_year (
        p_year VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION list_of_years RETURN VARCHAR2;

    FUNCTION list_of_contracts (
        p_app_user        IN VARCHAR2 DEFAULT NULL,
        p_page_id         IN VARCHAR2 DEFAULT NULL,
        p_contract_type   IN VARCHAR2 DEFAULT NULL,
        p_function        IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    function lov_contract_ret_contractor_id
    return varchar2;

    function lov_contracts_ret_contr_code
    return varchar2;

    function lov_contract_ret_contract_code
    return varchar2;

    function lov_all_inspectors
    return varchar2;

    function lov_crews_ret_crew_id
    return varchar2;

    function lov_user_active_project_code(
        p_contract_type in varchar2 default null
    )
    return varchar2;

    function lov_user_active_insp_proj_code(
        p_contract_type varchar2 default null,
        p_inspection_date date default trunc(sysdate),
        p_user_role_literal varchar2
    )
    return varchar2;

    FUNCTION lov_contract_file_type (
        p_contract_type  VARCHAR2,
        p_status         VARCHAR2
    ) RETURN VARCHAR2;



    FUNCTION lov_required_process (
        p_contract_type  VARCHAR2,
        p_process_type    VARCHAR2,
        p_status          VARCHAR2 default 'A',
        p_app_user        VARCHAR2 default null
    ) RETURN VARCHAR2;

    FUNCTION lov_document_type RETURN VARCHAR2;

    FUNCTION lov_item_doc_type (
        p_tender_item_id  number       
    ) RETURN VARCHAR2;

    FUNCTION lov_contract_tender_items (
        p_contract_code   IN VARCHAR2 DEFAULT NULL,
        p_item_category   IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2;

    FUNCTION lov_pr_contract_tender_items (
        p_contract_code   IN VARCHAR2    
    ) RETURN VARCHAR2;

    FUNCTION lov_pr_contract_tender_items_1 (
        p_contract_code   IN VARCHAR2,
        p_group_id   IN NUMBER DEFAULT NULL                
    ) RETURN VARCHAR2;

    FUNCTION lov_contractor_tender_items (
        p_app_user_check   IN varchar2 DEFAULT 'N'
    ) RETURN VARCHAR2;

    FUNCTION lov_contract_tender_items_wa (
        p_contract_code   IN VARCHAR2 DEFAULT NULL,
        p_item_category   IN VARCHAR2 DEFAULT NULL,
        p_group_id   IN NUMBER DEFAULT NULL        
    ) RETURN VARCHAR2;

    FUNCTION lov_contract_tender_items_wa_v20 RETURN VARCHAR2;
    
    FUNCTION lov_tender_list RETURN VARCHAR2;
    
    FUNCTION lov_all_immed_supervisors
    RETURN VARCHAR2;


END lov_package;
/


CREATE OR REPLACE PACKAGE BODY       "LOV_PACKAGE" AS

/*----------------------------------------------------------------------------------------
-- Package Name - LOV_PACKAGE                                  
-- Database - Oracle 11g               
--                                    
-- Created By:  Lisa Situ
-- Created On:  Nov, 2017
-- Last Modified:  
--                                                                                     --
-- Description:                                                                        --
-- This Package contains functions/procedures for dynamic LOVS in CMS app              --
--                                                                                     --
--- Modification history :
--                         Nov, 2017 Created
--                         
-----------------------------------------------------------------------------------------*/

    FUNCTION charge_back_status RETURN VARCHAR2
        AS
    BEGIN
    -- TODO: Implementation required for FUNCTION LOV_PACKAGE.LOV_CHARGE_BACK_STATUS
        RETURN 'select STATUS_CODE d, STATUS_CODE r from REF_CHARGE_BACK_STATUS WHERE  STATUS = ''A'' order by SEQ';
    END charge_back_status;

    FUNCTION restoration_type RETURN VARCHAR2
        AS
    BEGIN
        RETURN 'select CODE d, ID r from REF_RESTORATION_TYPE WHERE  STATUS = ''A'' order by SEQ';
    END restoration_type;

    FUNCTION month_of_year RETURN VARCHAR2
        AS
    BEGIN
        RETURN 'select month_display as d, lpad(month_value,2,''0'') as r
        from wwv_flow_months_mon'; --where month_value <= to_number(to_char(sysdate, ''mm''))';
    END month_of_year;

    FUNCTION list_of_years RETURN VARCHAR2
        AS
    BEGIN
        RETURN 'SELECT TO_CHAR(SYSDATE,''YYYY'')-LEVEL+1 AS D , TO_CHAR(SYSDATE,''YYYY'')-LEVEL+1 AS R FROM DUAL CONNECT BY LEVEL <= 3';
    END list_of_years;

    FUNCTION month_of_year (
        p_year VARCHAR2
    ) RETURN VARCHAR2
        AS
    BEGIN
        IF
            TO_CHAR(SYSDATE,'yyyy') = p_year OR TO_CHAR(SYSDATE,'yy') = p_year
        THEN
            RETURN 'select month_display as d, lpad(month_value,2,''0'') as r
        from wwv_flow_months_mon where month_value <= to_number(to_char(sysdate, ''mm''))'
;
        ELSE
            RETURN 'select month_display as d, lpad(month_value,2,''0'') as r
        from wwv_flow_months_mon'; --where month_value <= to_number(to_char(sysdate, ''mm''))';
        END IF;
    END month_of_year;

    FUNCTION list_of_contracts (
        p_app_user        IN VARCHAR2 DEFAULT NULL,
        p_page_id         IN VARCHAR2 DEFAULT NULL,
        p_contract_type   IN VARCHAR2 DEFAULT NULL,
        p_function        IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2
        AS
    BEGIN
        CASE
            p_function
            WHEN 'TRANSFER_WO' THEN  -- CAN ONLY TRANSFER WORK ORDER TO CONTRACT WHERE THE USER IS A CONTRACT ADMIN OF
                RETURN 'SELECT PROJECT_CODE||''-''||CONTRACT_TYPE, CONTRACT_CODE FROM CONTRACTS 
              WHERE (EXISTS (SELECT 1 FROM USER_CONTRACTS uc INNER JOIN USERS ur ON uc.user_id = ur.user_id WHERE ur.ROLE_CD = ''CA'' and UPPER(ur.username) = UPPER('''
                || p_app_user
                || ''')  ) 
                     OR EXISTS (SELECT 1 FROM USERS ur WHERE ur.ROLE_CD in (''BA'',''SA'') and UPPER(ur.username) = UPPER('''
                || p_app_user
                || ''') )) 
                AND STATUS = ''A''
                AND CONTRACT_TYPE <> ''RESTORATION''';
            ELSE
                RETURN NULL;
        END CASE;
    END list_of_contracts;


    function lov_contract_ret_contractor_id
    return varchar2
    is
    begin

        return 'select ' ||
                  'project_code || '' - '' || contract_type d, ' ||
                  'contractor_id r ' ||
                'from contracts ' ||
                'where upper(contract_type) = ''PERM RESTORATION'' ' ||
                'and contractor_id is not null ' ||
                'order by 1';

    end lov_contract_ret_contractor_id;

------------------------------------------------
-- lov_contracts_ret_contr_code
------------------------------------------------       
    function lov_contracts_ret_contr_code
    return varchar2
    is
    begin

        return 'select ' ||
                  'project_code || '' - '' || contract_type d, ' ||
                  'contract_code r ' ||
                'from contracts ' ||
                'inner join table( pr_package.get_contract_code_table( p_contract_type => ''PERM RESTORATION'' )) b ' ||
                'on contracts.contract_code = b.contract_code ' || 
                'where upper(contracts.contract_type) = ''PERM RESTORATION'' ' ||
                'and project_code is not null ' ||
                'and status = ''A'' ' ||
                'order by 1';

    end lov_contracts_ret_contr_code;

    function lov_contract_ret_contract_code
    return varchar2
    is
    begin

        return 'select ' ||
                  'project_code || '' - '' || contract_type d, ' ||
                  'contract_code r ' ||
                'from contracts ' ||
                'where upper(contract_type) = ''PERM RESTORATION'' ' ||
                'and project_code is not null ' ||
                'and status = ''A'' ' ||
                'order by 1';

    end lov_contract_ret_contract_code;


    function lov_all_inspectors
    return varchar2
    is
        cnt int;
    begin

    --    raise_application_error( -20000, 'P160_INCLUDE_ALL_INSPECTORS: ' || v('P160_INCLUDE_OTHER_INSPECTORS') );

        select count(*) into cnt 
            from users 
            where (
                upper( username ) = upper( v('APP_USER') ) and status_cd = 'A' and role_cd in ( 'SA','CA', 'BA' )
                )
            or ( v('P' || v('APP_PAGE_ID') || '_INCLUDE_ALL_INSPECTORS') = 'Y' );

        if cnt > 0 then

            return 'select ' ||

                   'case when first_name is not null then ' ||
                   '          first_name || '' '' || last_name ' ||
                   '     else username ' ||
                   'end d, ' ||
                   'a.user_id r ' ||

                'from  ' ||
                '( ' ||
                    'select distinct user_id from table( def_security_admin.get_group_all_usernames_table( ''g_cms_inspectors'' ) ) ' ||

                ') a ' ||
                --'inner join ( select * from users where status_cd is null or status_cd = ''A'' ) b ' ||
                'left join ( select * from users where status_cd = ''A'' ) b ' ||
                'on a.user_id = b.user_id';

        else

            return 'select ' ||

                   'case when first_name is not null then ' ||
                   '          first_name || '' '' || last_name ' ||
                   '     else username ' ||
                   'end d, ' ||
                   'a.user_id r ' ||

                'from  ' ||
                '( ' ||
                    'select distinct a.user_id ' || 
                    'from table( def_security_admin.get_group_all_usernames_table( ''g_cms_inspectors'' ) ) a ' ||
                    'inner join table( INSP.SUPERVISOR_MEMBERS( v(''F_APP_USER_ID''), ''g_cms_inspectors'', ''INSP'', ''ALL'')) sm ' ||
                    'on a.user_id = sm.user_id ' ||

                ') a ' ||
                'inner join ( select * from users where status_cd is null or status_cd = ''A'' ) b ' ||
                'on a.user_id = b.user_id';


        end if;


    end lov_all_inspectors;

------------------------------------------------
-- lov_crews_ret_crew_id
------------------------------------------------       
    function lov_crews_ret_crew_id
    return varchar2
    is
    begin

        return 'select ' ||
                  'dc.crew_name d, ' ||
                  'dc.id r ' ||
                'from def_crew dc ' ||
                'inner join table( pr_package.get_crew_id_table( )) b ' ||
                'on dc.id = b.contract_code ' || 
                'order by 1';

    end lov_crews_ret_crew_id;

------------------------------------------------
-- lov_crews_ret_crew_id
------------------------------------------------       
    function lov_user_active_project_code(
        p_contract_type varchar2 default null
    )
    return varchar2
    is
    begin

        if p_contract_type is null then


            return 
                'select ' ||
            --    '  case when PROJECT_CODE not in ( ''19-308'', ''19-309'' ) then ' ||
            -- '  case when PROJECT_CODE not in ( ''18-330'' ) then ' ||
                 ' case when PROJECT_CODE not in (select project_code from v_contracts_for_insp where contract_group = ''PR19'') then '||

                '     PROJECT_CODE||'' - ''||CONTRACT_NAME||''-''||CONTRACT_TYPE ' ||
                '       else ' ||
                '     PROJECT_CODE||'' - (PR19) ''||CONTRACT_NAME||''-''||CONTRACT_TYPE ' ||
                ' end d,  ' ||
                '     CONTRACT_CODE r  ' ||
                'from CONTRACTS ' ||
                'WHERE PROJECT_CODE IS NOT NULL  ' ||
                'AND STATUS=''A'' ' ||
                'AND CONTRACT_CODE IN  ' ||
                '( ' ||
                '    SELECT CONTRACT_CODE  ' ||
                '    FROM USER_CONTRACTS inner  ' ||
                '    join users on USER_CONTRACTS.user_id = users.user_id  ' ||
                '    WHERE upper(USERNAME) = v(''APP_USER'')  ' ||         
                ') ' ||
                 'order by 1';

        else

            if instr( p_contract_type, ',' ) > 1 then

                return 
                    'select ' ||
                    --    '  case when PROJECT_CODE not in ( ''19-308'', ''19-309'' ) then ' ||
                  --  '  case when PROJECT_CODE not in ( ''18-330'' ) then ' ||
                    ' case when PROJECT_CODE not in (select project_code from v_contracts_for_insp where contract_group = ''PR19'') then '||

                    '     PROJECT_CODE||'' - ''||CONTRACT_NAME||''-''||CONTRACT_TYPE ' ||
                    '       else ' ||
                    '     PROJECT_CODE||'' - (PR19) ''||CONTRACT_NAME||''-''||CONTRACT_TYPE ' ||
                    ' end d,  ' ||
                    '     CONTRACT_CODE r  ' ||
                    'from CONTRACTS ' ||
                    'WHERE PROJECT_CODE IS NOT NULL  ' ||
                    'AND STATUS=''A'' ' ||
                    'AND CONTRACT_CODE IN  ' ||
                    '( ' ||
                    '    SELECT CONTRACT_CODE  ' ||
                    '    FROM USER_CONTRACTS inner  ' ||
                    '    join users on USER_CONTRACTS.user_id = users.user_id  ' ||
                    '    WHERE upper(USERNAME) = v(''APP_USER'')  ' ||
                    ') ' ||
                    'and contract_type in ( ' || p_contract_type || ' ) ' ||
                    'order by 1';

            else

                return 
                    'select ' ||
                    '     PROJECT_CODE||'' - ''||CONTRACT_NAME||''-''||CONTRACT_TYPE d,  ' ||
                    '     CONTRACT_CODE r  ' ||
                    'from CONTRACTS ' ||
                    'WHERE PROJECT_CODE IS NOT NULL  ' ||
                    'AND STATUS=''A'' ' ||
                    'AND CONTRACT_CODE IN  ' ||
                    '( ' ||
                    '    SELECT CONTRACT_CODE  ' ||
                    '    FROM USER_CONTRACTS inner  ' ||
                    '    join users on USER_CONTRACTS.user_id = users.user_id  ' ||
                    '    WHERE upper(USERNAME) = v(''APP_USER'')  ' ||
                    ') ' ||
                    'and contract_type = ''' || p_contract_type || ''' ' ||
                    'order by 1';


            end if;

        end if;


    end lov_user_active_project_code;

    function lov_user_active_insp_proj_code(
        p_contract_type varchar2 default null,
        p_inspection_date date default trunc(sysdate),
        p_user_role_literal varchar2 
    )
    return varchar2
    is
    begin
        if p_user_role_literal='SUPERVISOR' then
            return lov_user_active_project_code(p_contract_type);
        end if;

        if p_contract_type is null then


            return 
                'select ' ||
                '     PROJECT_CODE||'' - ''||CONTRACT_NAME||''-''||CONTRACT_TYPE|| ' ||
                '     case ' ||
                '       when contract_type=''GENERAL REPAIRS'' and substr(project_code, 1,2)>=15 then ''(NEW)'' '||
                '       else null '|| 
                '     end d, '||
                '     CONTRACT_CODE r  ' ||
                'from CONTRACTS ' ||
                'WHERE PROJECT_CODE IS NOT NULL  ' ||
                'AND STATUS=''A'' ' ||
                'AND CONTRACT_CODE IN  ' ||
                '( ' ||
                '    SELECT uc.CONTRACT_CODE  ' ||
                '    FROM USER_CONTRACTS uc ' ||
                '    inner join users u on uc.user_id = u.user_id  ' ||
                '    inner join insp_daily_schedules ids on ids.inspector_id = u.user_id and uc.CONTRACT_CODE=ids.contract_code and ids.schedule_date='''||p_inspection_date||''''||
                '    WHERE upper(USERNAME) = v(''APP_USER'')  ' ||         
                ') ' ||
                 'order by 1';

        else

            if instr( p_contract_type, ',' ) > 1 then

                return 
                    'select ' ||
                    '     PROJECT_CODE||'' - ''||CONTRACT_NAME||''-''||CONTRACT_TYPE d,  ' ||
                    '     CONTRACT_CODE r  ' ||
                    'from CONTRACTS ' ||
                    'WHERE PROJECT_CODE IS NOT NULL  ' ||
                    'AND STATUS=''A'' ' ||
                    'AND CONTRACT_CODE IN  ' ||
                    '( ' ||
                    '    SELECT uc.CONTRACT_CODE  ' ||
                    '    FROM USER_CONTRACTS uc  ' ||
                    '    inner join users u on uc.user_id = u.user_id  ' ||
                    '    inner join insp_daily_schedules ids on ids.inspector_id = u.user_id and uc.CONTRACT_CODE=ids.contract_code and ids.schedule_date='''||p_inspection_date||''''||
                    '    WHERE upper(USERNAME) = v(''APP_USER'')  ' ||
                    ') ' ||
                    'and contract_type in ( ' || p_contract_type || ' ) ' ||
                    'order by 1';

            else

                return 
                    'select ' ||
                    '     PROJECT_CODE||'' - ''||CONTRACT_NAME||''-''||CONTRACT_TYPE d,  ' ||
                    '     CONTRACT_CODE r  ' ||
                    'from CONTRACTS ' ||
                    'WHERE PROJECT_CODE IS NOT NULL  ' ||
                    'AND STATUS=''A'' ' ||
                    'AND CONTRACT_CODE IN  ' ||
                    '( ' ||
                    '    SELECT ids.CONTRACT_CODE  ' ||
                    --'    FROM USER_CONTRACTS uc ' ||
                    '    FROM  ' ||
                    --'    inner join users u on uc.user_id = u.user_id  ' ||
                    '   users u ' ||
                    --'    inner join insp_daily_schedules ids on ids.inspector_id = u.user_id and uc.CONTRACT_CODE=ids.contract_code and ids.schedule_date='''||p_inspection_date||''''||
                    '    inner join insp_daily_schedules ids on ids.inspector_id = u.user_id and ids.schedule_date='''||p_inspection_date||''''||

                    '    WHERE upper(USERNAME) = v(''APP_USER'')  ' ||
                    ') ' ||
                    'and contract_type = ''' || p_contract_type || ''' ' ||
                    'order by 1';


            end if;

        end if;


    end lov_user_active_insp_proj_code;

    --To be retired by FUNCTION lov_contract_tender_items_wa
    FUNCTION lov_contract_tender_items (
        p_contract_code   IN VARCHAR2 DEFAULT NULL,
        p_item_category   IN VARCHAR2 DEFAULT NULL
    ) RETURN VARCHAR2
    IS
    BEGIN
        return 'select item_id || '' - ''||item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' ||
            ' AND category=''' || p_item_category || '''' ||
            ' order by numeric_item_id(item_id)';
    END lov_contract_tender_items;

 /*   FUNCTION lov_contract_tender_items_wa (
        p_contract_code   IN VARCHAR2 DEFAULT NULL,
        p_item_category   IN VARCHAR2 DEFAULT NULL,
        p_group_id   IN NUMBER DEFAULT NULL        
    ) RETURN VARCHAR2
    IS
    BEGIN
        if p_group_id is not null then
            return 'select item_id || '' - ''||item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' ||
            ' AND category=''' || p_item_category || '''' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' AND tender_item_id not in (select contract_code from table( pr_package.get_not_allowed_ti_table(' || p_group_id || ')))' ||            
            ' order by category, numeric_item_id(item_id)';
        else
            return 'select item_id || '' - ''||item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' ||
            ' AND category=''' || p_item_category || '''' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' order by category, numeric_item_id(item_id)';
        end if;
    END lov_contract_tender_items_wa;*/

    FUNCTION lov_contract_tender_items_wa (
        p_contract_code   IN VARCHAR2 DEFAULT NULL,
        p_item_category   IN VARCHAR2 DEFAULT NULL,
        p_group_id   IN NUMBER DEFAULT NULL        
    ) RETURN VARCHAR2
    IS
    BEGIN
        if p_group_id is not null then
            /*return 'select item_id || '' - ''||item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' ||
            ' AND category=''' || p_item_category || '''' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' AND tender_item_id not in (select contract_code from table( pr_package.get_not_allowed_ti_table(' || p_group_id || ')))' ||            
            ' order by category, numeric_item_id(item_id)';*/

            return 'with group_items as '||
            '( '||
            'select ti.item_id, ti.tender_item_id, ti.cref_tender_item_id, sum(decode(woti.work_order_item_id, null,0,1)) cnt  '||
            'from tender_items ti  '||
            'inner join wo_groups wg  '||
            'on ti.contract_code=wg.contract_code  '||
            'left outer join WORK_ORDER_TENDER_ITEMS woti  '||
            'on ti.tender_item_id=woti.tender_item_id '||
            'and woti.group_id=wg.group_id '||
            'where wg.group_id='|| p_group_id ||' and  '||
            --'ti.category=''' || p_item_category ||''' and '||
            'ti.category like '''||p_item_category||''' and '||
            '(supplement is null or supplement=''N' || ''')' ||
            'group by ti.item_id, ti.tender_item_id, ti.cref_tender_item_id) '||
            'select ti.item_id || '' - ''||ti.item_description d, ti.tender_item_id r  '||
            'from tender_items ti '||
            'inner join group_items t1 '||
            'on ti.tender_item_id=t1.tender_item_id '||
            'left outer join group_items t2 '||
            'on t1.cref_tender_item_id=t2.tender_item_id '||
            'where t2.cnt is null or t1.cnt<>t2.cnt '||
            'order by numeric_item_id(ti.item_id) ';

        else
            return 'select item_id || '' - ''||item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' ||
            ' AND category=''' || p_item_category || '''' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' order by category, numeric_item_id(item_id)';
        end if;
    END lov_contract_tender_items_wa;    

    --Initially created for Tabular Form Select List items on apex V20.2,
    FUNCTION lov_contract_tender_items_wa_v20 RETURN VARCHAR2
    IS
    BEGIN
        if v('P' || v('APP_PAGE_ID') || '_RESTORATION_CAT') is not null then
            return 'with group_items as '||
            '( '||
            'select ti.item_id, ti.tender_item_id, ti.cref_tender_item_id, sum(decode(woti.work_order_item_id, null,0,1)) cnt  '||
            'from tender_items ti  '||
            'inner join wo_groups wg  '||
            'on ti.contract_code=wg.contract_code  '||
            'left outer join WORK_ORDER_TENDER_ITEMS woti  '||
            'on ti.tender_item_id=woti.tender_item_id '||
            'and woti.group_id=wg.group_id '||
            'where wg.group_id='|| v('P' || v('APP_PAGE_ID') || '_GROUP_ID') ||' and  '||
            --'ti.category=''' || p_item_category ||''' and '||
            'ti.category like '''||v('P' || v('APP_PAGE_ID') || '_RESTORATION_CAT')||''' and '||
            '(supplement is null or supplement=''N' || ''')' ||
            'group by ti.item_id, ti.tender_item_id, ti.cref_tender_item_id) '||
            'select ti.item_id || '' - ''||ti.item_description d, ti.tender_item_id r  '||
            'from tender_items ti '||
            'inner join group_items t1 '||
            'on ti.tender_item_id=t1.tender_item_id '||
            'left outer join group_items t2 '||
            'on t1.cref_tender_item_id=t2.tender_item_id '||
            'where t2.cnt is null or t1.cnt<>t2.cnt '||
            'order by numeric_item_id(ti.item_id) ';

        else
            return 'select item_id || '' - ''||item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| v('P' || v('APP_PAGE_ID') || '_CONTRACT_CODE') || '''' ||
            ' AND category=''' || v('P' || v('APP_PAGE_ID') || '_RESTORATION_CAT') || '''' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' order by category, numeric_item_id(item_id)';
        end if;
    END lov_contract_tender_items_wa_v20;    


    --TO be retired by FUNCTION lov_pr_contract_tender_items_1
    FUNCTION lov_pr_contract_tender_items (
        p_contract_code   IN VARCHAR2) RETURN VARCHAR2
    IS
    BEGIN
        --return 'select  category||'' [ '' ||item_id || '' ] - ''||item_description d, tender_item_id r ' ||
        return 'select  item_id || '' . ''|| category || '' - '' || item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' || ' and category in (''' ||'CONSTRUCTION'', ''RESURFACING'', ''ALLOWANCE'')' ||
            ' order by  numeric_item_id(item_id), category ';
    END lov_pr_contract_tender_items;


    FUNCTION lov_tender_list RETURN VARCHAR2 IS
    BEGIN
        RETURN 'SELECT ITEM_ID||'' - ''||ITEM_DESCRIPTION D,TENDER_ITEM_ID R FROM TENDER_ITEMS WHERE (SUPPLEMENT <> ''Y'' OR SUPPLEMENT IS NULL) AND CONTRACT_CODE = :P'||v('APP_PAGE_ID')||'_CONTRACT_CODE ORDER BY numeric_item_id(ITEM_ID)';
    END lov_tender_list;
    
    FUNCTION lov_pr_contract_tender_items_1 (
        p_contract_code   IN VARCHAR2,
        p_group_id IN NUMBER DEFAULT NULL) RETURN VARCHAR2
    IS
    BEGIN
        IF p_group_id IS NOT NULL THEN
            --return 'select  category||'' [ '' ||item_id || '' ] - ''||item_description d, tender_item_id r ' ||
            return 'select  item_id || '' . ''|| category || '' - '' || item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' || ' and category in (''' ||'CONSTRUCTION'', ''RESURFACING'', ''ALLOWANCE'')' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' AND tender_item_id not in (select contract_code from table( pr_package.get_not_allowed_ti_table(' || p_group_id || ')))' ||            
            ' order by  numeric_item_id(item_id), category ';
        ELSE
            return 'select  item_id || '' . ''|| category || '' - '' || item_description d, tender_item_id r ' ||
            ' from tender_items' ||
            ' WHERE contract_code='''|| p_contract_code || '''' || ' and category in (''' ||'CONSTRUCTION'', ''RESURFACING'', ''ALLOWANCE'')' ||
            ' AND (supplement is null or supplement=''N' || ''')' ||
            ' order by  numeric_item_id(item_id), category ';
        END IF;
    END lov_pr_contract_tender_items_1;


    FUNCTION lov_contract_file_type (
        p_contract_type  VARCHAR2,
        p_status         VARCHAR2
    ) RETURN VARCHAR2
    IS
    BEGIN

        return 'select ' ||

                    'b.type_name,  ' ||
                    'a.type_cd ' ||

                'from CONTRACT_TYPE_ATTACHMENTS a ' ||
                'inner join REF_WA_ATTACHMENT_TYPE b ' ||
                'on a.type_cd = b.type_cd ' ||
                'where a.contract_type = ''' || p_contract_type || ''' '  ||
                'and a.status = ''' || p_status || ''' ' ||
                'and b.status = ''' || p_status || ''' ';


    END lov_contract_file_type;


    FUNCTION lov_document_type RETURN VARCHAR2
    IS
    BEGIN

        return 'select ' ||

                    'type_name,  ' ||
                    'type_cd ' ||

                'from ref_document_type  ' ||               
                'where status = ''A'' ';


    END lov_document_type;

    FUNCTION lov_item_doc_type (
        p_tender_item_id  number       
    ) RETURN VARCHAR2
    IS
    BEGIN

        return 'select distinct ' ||

                    --'case when display_name is null then doc_type else ''['' || doc_type || ''] '' || display_name end display_name,  ' ||
                    'case when display_name is null then doc_type else  display_name end display_name,  ' ||
                    'doc_type ' ||

                'from def_tender_item_doc  ' ||               
                'where status = ''A'' ' ||
                'and tender_item_id = ' || p_tender_item_id
                ;


    END lov_item_doc_type;

  FUNCTION lov_required_process (
        p_contract_type  VARCHAR2,
        p_process_type    VARCHAR2,
        p_status          VARCHAR2 default 'A',
        p_app_user        VARCHAR2 default null
    ) RETURN VARCHAR2 AS
  BEGIN
      return 'select ' ||

                    'type_name,  ' ||
                    'type_cd ' ||

                'from def_required_process  ' ||     
                'where applicable_contract_type = ''' || p_contract_type || ''' '  ||
                'and process_type = ''' || p_process_type || ''' ' ||
                'and status = ''' || p_status || ''' ';

  END lov_required_process;

  ------------------------------------------------
-- lov_contracts_ret_contr_code
------------------------------------------------       
    FUNCTION lov_contractor_tender_items (
        p_app_user_check   IN varchar2 DEFAULT 'N'
    ) RETURN VARCHAR2
    is
    begin
    /*
        complete sample query here:

        select distinct 
                  contractor_name d, 
                  a.contractor_id r 
                from contractors a 
                left join users b on b.contractor_id = a.contractor_id 
                where ( 'N' = 'N' )                 
                or 
                ( 'N' = 'Y'                 
                  and 
                    (

                        DEF_SECURITY_ADMIN.is_appuser_has_access_retnum (
                            'CMS',
                            'CMS contract admin access',
                            v('APP_USER')
                        ) = 1

                        or 
                        (
                            DEF_SECURITY_ADMIN.is_appuser_has_access_retnum (
                                'CMS',
                                'CMS contract admin access',
                                v('APP_USER')
                            ) = 0
                            and 
                            upper(b.username) = upper( v('APP_USER') )
                        )


                    )

                )

                order by 1;

    */
        return 'select distinct ' ||
                  'contractor_name d, ' ||
                  'a.contractor_id r ' ||
                'from contractors a ' ||  
                'left join users b on b.contractor_id = a.contractor_id ' ||
                'where ( ''' || p_app_user_check || ''' = ''N'' ) ' ||               
                'or ' || 
                '( ''' || p_app_user_check || ''' = ''Y'' ' ||               
                '  and ' ||     
                '    (' ||     

                   '     DEF_SECURITY_ADMIN.is_appuser_has_access_retnum (' ||     
                  '         p_app_code =>  ''CMS'',' ||     
                   '        p_priv_name =>  ''CMS contract admin access'',' ||     
                  '         p_username => v(''APP_USER'')' ||     
                  '      ) = 1' ||     
                        
                   '     or ' ||     
                   '     (' ||     
                  '          DEF_SECURITY_ADMIN.is_appuser_has_access_retnum (' ||     
                  '          p_app_code =>    ''CMS'',' ||     
                  '          p_priv_name =>    ''CMS contract admin access'',' ||     
                 '           p_username =>    v(''APP_USER'')' ||     
                 '           ) = 0' ||     
                 '           and ' ||     
                 '           upper(b.username) = upper( v(''APP_USER'') )' ||     
                 '       )' ||      


                '    )' ||     

                ')' ||     
                'order by 1';

    end lov_contractor_tender_items;

  ------------------------------------------------
-- lov_all_immed_supervisors
------------------------------------------------       
    FUNCTION lov_all_immed_supervisors
    RETURN VARCHAR2
    is
    begin

        return 'select ' ||

               '     case when first_name is null  ' ||
               '          then username  ' ||
               '          else ''[ '' || username || '' ] '' || first_name || '' '' || last_name  ' ||
               '     end d, ' ||
              '      user_id r ' ||
              '  from users where role_cd in ( ''SUP'') AND status_cd  = ''A'' ' ||

              '  union ' ||

              '  select  ' ||

              '      case when first_name is null  ' ||
              '           then username  ' ||
              '          else ''[ '' || username || '' ] '' || first_name || '' '' || last_name  ' ||
              '      end d, ' ||
              '      user_id r ' ||

              '  from table( def_security_admin.get_group_all_usernames_table( ''g_cms_supervisors'' ) ) a ' ||
              '  inner join users b ' ||
              '  on a.user_id = b.user_id ' ||
              '  where b.status_cd is null or b.status_cd <> ''I'' ' ||

              '  order by d ' 
                ;

    end lov_all_immed_supervisors;

END lov_package;
/
