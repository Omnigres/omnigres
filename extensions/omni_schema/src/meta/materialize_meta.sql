create function materialize_meta(
    from_schema regnamespace,
    to_schema regnamespace) returns void
    language plpgsql
as
$create_remote_meta$
declare
begin
    perform set_config('search_path', to_schema || ',' || from_schema, true);

--## for view in meta_views
    create materialized view if not exists "/*{{ view }}*/" as
        select * from "/*{{ view }}*/" with no data;
--## endfor

    create function refresh_meta() returns void
        language plpgsql
    as
    $refresh_meta$
    begin
--## for view in meta_views
        refresh materialized view "/*{{ view }}*/";
--## endfor
    end;
    $refresh_meta$;
    execute format('alter function refresh_meta() set search_path = %s', to_schema || ',' || from_schema);

    perform refresh_meta();
    return;
end;
$create_remote_meta$;